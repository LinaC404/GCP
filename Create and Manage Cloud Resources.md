<h1 align='center'>　Create and Manage Cloud Resources: Challenge Lab　</h1>
<h2>Task1. Create a project jumphost instance</h2>

```
gcloud compute instances create nucleus-jumphost \
--machine-type=f1-micro \
--zone=us-east1-b
```

<h2>Task 2: Create a Kubernetes service cluster</h2>

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

```
kubectl expose deployment hello-app \
--type LoadBalancer \
--port 8080
```

<h2>Task 3: Set up an HTTP load balancer</h2>

```
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF
```

* Create an instance template.

```
gcloud compute instance-templates create nginx-template \
--metadata-from-file=startup-script=startup.sh
```

* Create a target pool.
```
gcloud compute target-pools create nginx-pool \
--region=us-east1
```

* Create a managed instance group.
```
gcloud compute instance-groups managed create nginx-group \
--base-instance-name=nginx \
--template=nginx-template \
--target-pool=nginx-pool \
--size=2
```

* Create a firewall rule to allow traffic (80/tcp).
```
gcloud compute firewall-rules create firewall-rule \
--allow tcp:80
```

```
gcloud compute forwarding-rules create fwd-rule \
--region=us-east1 \
--target-pool=nginx-pool \
--ports=80
```

* Create a health check.
```
gcloud compute http-health-checks create basic-check
```

```
gcloud compute instance-groups managed set-named-ports nginx-group \
 --zone=us-east1-b \
 --named-ports=http:80
```

* Create a backend service, and attach the managed instance group.
```
gcloud compute backend-services create nginx-backend \
--protocol=HTTP \
--http-health-checks=basic-check \
--global
```

```
gcloud compute backend-services add-backend nginx-backend \
--instance-group-zone=us-east1-b \
--instance-group=nginx-group \
--global
```

* Create a URL map, and target the HTTP proxy to route requests to your URL map.
```
gcloud compute url-maps create web-map \
--default-service=nginx-backend
```

```
gcloud compute target-http-proxies create http-proxy \
--url-map=web-map \
--description="QAQ proxy"
```

* Create a forwarding rule.

```
gcloud compute forwarding-rules create http-fwd-rule \
--target-http-proxy=http-proxy \
--ports=80 \
--global
```

The error message suggested that I should set global not region in some command lines.

Attention should be paid to the setting of `zone`, `region` and `global`.

Be patient when you meet the error "Please verify the web servers are serving on frontend of HTTP(s) Load Balancer". (a few minutes)

以上です。
