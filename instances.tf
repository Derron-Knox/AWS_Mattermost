#update security groups, private keys, and

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create and bootstrap bastion EC2
resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.bastion-instance-type
  key_name                    = "Mattermost"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = aws_subnet.pubsub-1.id

  tags = {
    Name = "bastion"
  }

  #The code below is ONLY the provisioner block which needs to be
  #inserted inside the resource block for Jenkins EC2 master Terraform
  #Jenkins Master Provisioner:

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
  && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' --private-key ~/.ssh/PATHTOPRIVATEKEY
  }

}

#deploy mattermost application EC2s
resource "aws_instance" "mattermost-application" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.bastion-instance-type
  key_name                    = "Mattermost"
  count                       = var.application-instance-count
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.mattermost-application-servers.id]
  subnet_id                   = aws_subnet.privsub.id

  tags = {
    Name = "mattermost_application"
  }

}

#deploy Prometheus EC2
resource "aws_instance" "promethus" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.prometheus-instance-type
  key_name                    = "Mattermost"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.mattermost-application-servers.id]
  subnet_id                   = aws_subnet.privsub.id

  tags = {
    Name = "prometheus"
  }

}

#deploy grafana EC2
resource "aws_instance" "grafana" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.grafana-instance-type
  key_name                    = "Mattermost"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.mattermost-application-servers.id]
  subnet_id                   = aws_subnet.privsub.id

  tags = {
    Name = "grafana"
  }

}

#deploy job server EC2
resource "aws_instance" "job_server" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.jobserver-instance-type
  key_name                    = "Mattermost"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.mattermost-application-servers.id]
  subnet_id                   = aws_subnet.privsub.id

  tags = {
    Name = "job_server"
  }

}