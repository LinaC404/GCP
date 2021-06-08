1.

```
gcloud compute instances create nucleus-jumphost \
--machine-type=f1-micro \
--zone=us-east1-b
```

2.
```
gcloud config set compute/zone us-east1-b
```

```
gcloud  container clusters create webserver1
```

```
gcloud container clusters get-credentials webserver1
```

```
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:2.0
```
