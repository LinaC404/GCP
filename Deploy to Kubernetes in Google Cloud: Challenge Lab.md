<h1 align='center'>Deploy to Kubernetes in Google Cloud: Challenge Lab</h1>

<strong>Note: Make sure the region is `us-east1` and the zone is `us-east1-b`</strong>

<h2> Steps </h2>

1. [Create a Docker image and store the Dockerfile](#1)
1. [Test the created Docker image](#2)
1. [Push the Docker image in the Container Repository](#3)
1. [Create and expose a deployment in Kubernetes](#4)
1. [Update the deployment with a new version of valkyrie-app](#5)
1. [Create a pipeline in Jenkins to deploy your app](#6)

<h3 id=1>Create a Docker image and store the Dockerfile</h3>

Each Google Project has zero or more git repositories that were associated with it.
> gcloud source repos list

Clones a git repository from current Google Cloud project into the specified directory.
> gcloud source repos clone REPOSITORY_NAME [DIRECTORY_NAME]

Clone the valkyrie-app source code repository
```
source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking.sh)
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud source repos clone valkyrie-app --project=$PROJECT_ID
```

Create a `Dockerfile`
```
cd valkyrie-app/
cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF
```

To tag the image `valkyrie-app` with `v0.0.1`.
```
docker build -t valkyrie-app:v0.0.1 .
```

Don't forget to run the `step1.sh` to check your work. 
```
cd ..
./step1.sh
```

<h3 id=2>Test the created Docker image</h3>
<h3 id=3>Push the Docker image in the Container Repository</h3>
<h3 id=4>Create and expose a deployment in Kubernetes</h3>
<h3 id=5>Update the deployment with a new version of valkyrie-app</h3>
<h3 id=6>Create a pipeline in Jenkins to deploy your app</h3>
