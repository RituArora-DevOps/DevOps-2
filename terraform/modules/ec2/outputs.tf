output "instance_id" {
  value = aws_instance.jenkins_server.id
}

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "private_ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.jenkins_server.private_dns
}
