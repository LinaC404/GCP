<h1 align='center'>Automating Infrastructure on Google Cloud with Terraform: Challenge Lab</h1>

<h2> Steps </h2>

1. [Create the configuration files](#1)
1. [Import infrastructure](#2)
1. [Configure a remote backend](#3)
1. [Modify and update infrastructure](#4)
1. [Taint and destroy resources](#5)
1. [Use a module from the Registry](#6)
1. [Configure a firewall](#7)
1. [(Optitional) Connectivity test](#8)

<h3 id=1>Create the configuration files</h3>

* Create the directory and configuration files as required.
```
touch main.tf variables.tf
mkdir modules && cd modules
mkdir instances && cd instances
touch instances.tf outputs.tf variables.tf
cd ..
mkdir storage && cd storage
touch storage.tf outputs.tf variables.tf
```

* Fill out the [`variables.tf`](../../blob/main/Automating%20Infrastructure%20(Terraform)/variables.tf) and [`main.tf`](../../blob/main/Automating%20Infrastructure%20(Terraform)/main.tf) ([More details...](https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build))
* Initialize Terraform
```
terraform init
```

<h3 id=2>Import infrastructure</h3>

  Get detailed information of the instances.
  > gcloud compute instances describe INSTANCE_NAME [--zone=ZONE] 

* Write the resource configuration([instances.tf](../../blob/main/Automating%20Infrastructure%20(Terraform)/modules/instances/instances.tf)) to match the existed instances.
* Ues command `terraform import` ([the details about this command](https://www.terraform.io/docs/extend/resources/import.html)) to import configurations into the `instances` module
```
export Instance1_ID=$(gcloud compute instances describe tf-instance-1 --zone=us-central1-a --format="value(id)")
terraform import  module.instances.google_compute_instance.tf-instance-1 $Instance1_ID
```
```
export Instance2_ID=$(gcloud compute instances describe tf-instance-2 --zone=us-central1-a --format="value(id)")
terraform import  module.instances.google_compute_instance.tf-instance-2 $Instance2_ID
```

* Apply changes
```
terraform plan
terraform apply
```
<h3 id=3>Configure a remote backend</h3>
<h3 id=4>Modify and update infrastructure</h3>
<h3 id=5>Taint and destroy resources</h3>
<h3 id=6>Use a module from the Registry</h3>
<h3 id=7>Configure a firewall</h3>
<h3 id=8>(Optitional) Connectivity test</h3>
