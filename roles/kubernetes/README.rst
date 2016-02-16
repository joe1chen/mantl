Kubernetes
==========

.. versionadded:: 0.2

**NOTES:** This is NOT kubernetes-mesos/Mantl framework, this is a standalone kubernetes cluster.

**WARNING**: Do NOT install on top of existing Mantl cluster as it might brake it!

**REQUIREMENTS:**

- Terraform binaries installed 
- Run ``pip install -r requirements.txt``
- Fresh formed cluster with terraform on your cloud of choice

Installation instructions:
--------------------------

**TERRAFORM STEPS:**

- From root folder of the project ``cp terraform/<$YourCloudProvider>.sample.tf  .``
- Rename <$YourCloudProvider>.sample.tf to <$YourCloudProvider>.tf
- Populate your <$YourCloudProvider>.tf

Run:

``terraform get && terraform plan && terraform apply``

Your infrastructure shoud be up and running at this point.

**Variables:**

Go over:

- `kubernetes_vars.yml <https://github.com/CiscoCloud/microservices-infrastructure/blob/master/kubernetes_vars.yml>`_ and populate variables per your requirements.
- kubernetes `defaults <https://github.com/CiscoCloud/microservices-infrastructure/blob/master/roles/kubernetes/defaults/main.yml>`_ and set vars like dns_domain,kube_version and others.


**ANSIBLE STEPS:**

Go over kubernetes.yml and kubernetes_vars.yml and populate variables per your requirements.

- Copy ./terraform.sample.yml into a new file and populate the file (e.g terraform.yml)
- Run ``ansible-playbook playbooks/upgrade-packages-all-at-once.yml``  ( this will update CentOS to required version )
- Run ``./security-setup``
- Run ``ansible-playbook -e @security.yml -e @kubernetes_vars.yml kubernetes.yml``

Cluster should be up and running if ansible had no failures!
