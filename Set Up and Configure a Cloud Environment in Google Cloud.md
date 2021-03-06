<h1 align='center'> Set Up and Configure a Cloud Environment in Google Cloud: Challenge Lab </h1>

<strong>Note: Make sure the region is `us-east1` and the zone is `us-east1-b`</strong>

<h2> Steps </h2>

1. [Create development VPC manually](#1)
1. [Create production VPC using Deployment Manager](#2)
1. [Create bastion host](#3)
1. [Create and configure Cloud SQL Instance](#4)
1. [Create Kubernetes cluster](#5)
1. [Prepare the Kubernetes cluster](#6)
1. [Create a WordPress deployment](#7)
1. [Enable monitoring](#8)
1. [Provide access for an additional engineer](#9)<br>
 

<h3 id=1>Create development VPC manually</h3>

* Create a VPC called `griffin-dev-vpc` with **Custom** mode
```
gcloud compute networks create griffin-dev-vpc \
    --subnet-mode=custom \
```
* Create a subnet  called `griffin-dev-wp` and set the IP address range as `192.168.16.0/20`
```
gcloud compute networks subnets create griffin-dev-wp \
    --network=griffin-dev-vpc \
    --range=192.168.16.0/20 \
    --region=us-east1
```
* Create a subnet  called `griffin-dev-mgmt` and set the IP address range as `192.168.32.0/20`
```
gcloud compute networks subnets create griffin-dev-mgmt \
    --network=griffin-dev-vpc \
    --range=192.168.32.0/20 \
    --region=us-east1
```

<h3 id=2>Create production VPC using Deployment Manager</h3>

* Copy the Deployment Manager configuration files
```
gsutil cp -r gs://cloud-training/gsp321/dm ~/
```

* Edit the `prod-network.yaml` file
```
cd dm
edit prod-network.yaml
```
* Set `SET_REGION` as `us-east1` in the file and save the change.
* Create the VPC network with the mentioned configuration file
```
gcloud deployment-manager deployments create griffin-prod --config prod-network.yaml
```
![Here is result shown in Step 2](./image/1_step2.jpg)

<h3 id=3>Create bastion host</h3>

* [what is bastion host](https://cloud.google.com/solutions/connecting-securely#bastion)
```
gcloud compute instances create griffin-dev-db \
--zone=us-east1-b \
--tags=bastion \
--network-interface subnet=griffin-dev-mgmt \
--network-interface subnet=griffin-prod-mgmt
```
* Create firewall rules
```
gcloud compute firewall-rules create allow-bastion-dev-ssh \
    --network griffin-dev-vpc \
    --action allow \
    --target-tags bastion \
    --source-ranges 192.168.32.0/20 \
    --rules tcp:22
```
```
gcloud compute firewall-rules create allow-bastion-prod-ssh \
    --network griffin-prod-vpc \
    --action allow \
    --target-tags bastion \
    --source-ranges 192.168.48.0/20 \
    --rules tcp:22
```
<h3 id=4>Create and configure Cloud SQL Instance</h3>

* Create a cloud SQL instance
```
gcloud sql instances create griffin-dev-db \
 --region=us-east1 
```
* Set a password
```
gcloud sql users set-password root --host=% --instance griffin-dev-db --password admin
```
* Connect to this instance
```
gcloud sql connect griffin-dev-db --user=root --quiet
```
* Input the password you set just now
* Prepare the WordPress environment
```
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO "wp_user"@"%" IDENTIFIED BY "stormwind_rules";
FLUSH PRIVILEGES;
```
* Exit
```
exit
```

![Here is result shown in Step 4](./image/1_step6.PNG)

<h3 id=5>Create Kubernetes cluster</h3>

```
gcloud container clusters create griffin-dev \
   --zone us-east1-b \
   --num-nodes=2 \
   --machine-type=n1-standard-4 \
   --network=griffin-dev-vpc \
   --subnetwork=griffin-dev-wp
```
<h3 id=6>Prepare the Kubernetes cluster</h3>

* Copy the files from `gs://cloud-training/gsp321/wp-k8s`
```
gsutil cp -r gs://cloud-training/gsp321/wp-k8s ~/
```

* Edit the `wp-k8s/wp-env.yaml` file
```
cd ~/wp-k8s
edit wp-env.yaml
```

* Replace username_goes_here -> `wp_user` and password_goes_here ->  `stormwind_rules`, and save the change.
![wp-env.yaml](./image/1_step6_1.jpg)

* Fetch cluster endpoint and auth data, kubeconfig entry generated for current cluster.
```
gcloud container clusters get-credentials griffin-dev --zone=us-east1-b
```

* Apply configuration changes to the cluster.
```
kubectl apply -f wp-env.yaml
```

* [Create a private key for the service account](https://cloud.google.com/sdk/gcloud/reference/iam/service-accounts/keys/create) which was already set up and add the  key to k8s environment.
```
gcloud iam service-accounts keys create key.json \
    --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
kubectl create secret generic cloudsql-instance-credentials \
    --from-file key.json
```

<h3 id=7>Create a WordPress deployment</h3>

* Edit the `wp-k8s/wp-deployment.yaml` file
```
cd ~/wp-k8s
edit wp-deployment.yaml
```

* Replace YOUR_SQL_INSTANCE with **griffin-dev-db's Instance connection name**, and save the change.
 
![configuration file](./image/1_step7_1.JPG)
* Create deployment and the service with `wp-service.yaml`
```
kubectl create -f wp-deployment.yaml
kubectl create -f wp-service.yaml
```
* Complete the installation of WordPress

![WordPress Login in page](./image/1_step7_2.JPG)
![Test Page](./image/1_step7_3.JPG)

<h3 id=8>Enable monitoring</h3>

* Create [Uptime Check](https://cloud.google.com/monitoring/uptime-checks)

`Monitoring`->`Uptime checks`->`???CREATE UPTIME CHECK`

![Uptime Check](./image/1_step8_1.JPG)

<h3 id=9>Provide access for an additional engineer</h3>

![Grant Access](./image/1_step9.jpg)

In order to complete this lab, I tried several times.

It's still a bit difficult for a beginner.(??????`???????)

???????????????
