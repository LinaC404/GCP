<h1 align='center'> Set Up and Configure a Cloud Environment in Google Cloud: Challenge Lab </h1>

<strong>Note: Make sure the region is `us-east1` and the zone is `us-east-1`</strong>

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
git status
git add
git commit
```
* Create a subnet  called `griffin-dev-wp` and set the IP address range as `192.168.16.0/20`
```
git status
git add
git commit
```
* Create a subnet  called `griffin-dev-mgmt` and set the IP address range as `192.168.32.0/20`
```
git status
git add
git commit
```

<h3 id=2>Create production VPC using Deployment Manager</h3>
* 

![Here is result shown in Step 2](./image/1_step2.jpg)

<h3 id=3>Create bastion host</h3>
<h3 id=4>Create and configure Cloud SQL Instance</h3>
<h3 id=5>Create Kubernetes cluster</h3>
<h3 id=6>Prepare the Kubernetes cluster</h3>
<h3 id=7>Create a WordPress deployment</h3>
<h3 id=8>Enable monitoring</h3>
<h3 id=9>Provide access for an additional engineer</h3>

