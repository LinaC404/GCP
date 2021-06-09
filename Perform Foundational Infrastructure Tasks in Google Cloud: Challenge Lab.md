<h1 align='center'>Perform Foundational Infrastructure Tasks in Google Cloud: Challenge Lab</h1>

**Note: all resources should be created in region `us-east1` and zone `us-east1-b`**

* <h2>Task 1: Create a bucket</h2>

```
export PROJECT_ID=$(gcloud info --format='value(config.project)')
```
```
gsutil mb -p $PROJECT_ID -l us-east1 -b on gs://photobucket-404
```
* <h2><a href='https://cloud.google.com/pubsub/docs/quickstart-cli'>Task 2: Create a Pub/Sub topic</a></h2>

```
gcloud pubsub topics create upload_topic
```

* <h2>Task 3: Create the thumbnail Cloud Function</h2>

* Create a function and specify dependencies (`index.js` and `package.json`)

```javascript
/* globals exports, require */
//jshint strict: false
//jshint esversion: 6
"use strict";
const crc32 = require("fast-crc32c");
const gcs = require("@google-cloud/storage")();
const PubSub = require("@google-cloud/pubsub");
const imagemagick = require("imagemagick-stream");

exports.thumbnail = (event, context) => {
  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64"
  const bucket = gcs.bucket(bucketName);
  const topicName = "upload_topic"; /*REPLACE_WITH_YOUR_TOPIC ID*/
  const pubsub = new PubSub();
  if ( fileName.search("64x64_thumbnail") == -1 ){
    // doesn't have a thumbnail, get the filename extension
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length );
    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg'){
      // only support png and jpg at this point
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
      const gcsObject = bucket.file(fileName);
      let newFilename = filename_without_ext + size + '_thumbnail.' + filename_ext;
      let gcsNewObject = bucket.file(newFilename);
      let srcStream = gcsObject.createReadStream();
      let dstStream = gcsNewObject.createWriteStream();
      let resize = imagemagick().resize(size).quality(90);
      srcStream.pipe(resize).pipe(dstStream);
      return new Promise((resolve, reject) => {
        dstStream
          .on("error", (err) => {
            console.log(`Error: ${err}`);
            reject(err);
          })
          .on("finish", () => {
            console.log(`Success: ${fileName} → ${newFilename}`);
              // set the content-type
              gcsNewObject.setMetadata(
              {
                contentType: 'image/'+ filename_ext.toLowerCase()
              }, function(err, apiResponse) {});
              pubsub
                .topic(topicName)
                .publisher()
                .publish(Buffer.from(newFilename))
                .then(messageId => {
                  console.log(`Message ${messageId} published.`);
                })
                .catch(err => {
                  console.error('ERROR:', err);
                });

          });
      });
    }
    else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  }
  else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
};
```
```json
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/storage": "1.5.1",
    "@google-cloud/pubsub": "^0.18.0",
    "fast-crc32c": "1.0.4",
    "imagemagick-stream": "4.1.1"
  },
  "devDependencies": {},
  "engines": {
    "node": ">=4.3.2"
  }
}
```

* Deploy the function to the pub/sub topic

```
gcloud functions deploy thumbnail \
  --trigger-resource photobucket-404 \
  --trigger-event google.storage.object.finalize \
  --region us-east1 \
  --runtime nodejs10
```

* Download the image from [URL](https://storage.googleapis.com/cloud-training/gsp315/map.jpg) and upload it to the bucket

* <h2>Task 4: Remove the previous cloud engineer</h2>
