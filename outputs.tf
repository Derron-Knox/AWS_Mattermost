# output bastion IP to CLI
output "bastion-Public-IP" {
  value = aws_instance.bastion.public_ip
}

# output Matter most instance private IPs
output "mattermost-application-Private-IPs" {
  value = {
    for instance in aws_instance.mattermost-application :
    instance.id => instance.private_ip
  }
}

# output Matter most db endpoints
output "db-enpoints" {
  value = {
    for instance in aws_rds_cluster_instance.cluster_instances :
    instance.id => instance.endpoint
  }
}

output "promethus-IP" {
  value = aws_instance.promethus.private_ip
}

output "grafana-IP" {
  value = aws_instance.grafana.private_ip
}

output "job_server-IP" {
  value = aws_instance.job_server.private_ip
}