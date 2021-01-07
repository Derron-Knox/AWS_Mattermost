

## Requirements:

- Terraform
- Ansible
- AWS

Created to automate the deployment of AWS infrastructure and provision instances with the latest wordpress server software behind a private subnet. This will deploy a bastion host with ansbile installed to log into and deploy ansible scripts.


### Resources
1 VPN
3 public subnets
1 private subnet
1 nat gateway
1 internet gateway
3 Amazon Linux2 EC2 Instances
1 Application Loadbalancer


### Instructions:

- create s3 bucket to store state file and update backend.tf
- update path to aws private key in intances.tf and ansible.cfg files (--private-key ~/PATHTOPROVATEKEY )
- update database information in database.tf
- Deploy infrastructure with terraform init and apply
- log into bastion host with IP output displayed once terraform completes. 
- update ansible/roles/mattermost/vars with desired input
- update inventory with ip address of instances (or use dynamic inventory)
- run ansible-playbook main.yml
