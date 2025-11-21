output "instance_ids" {
  description = "IDs of created EC2 instances"
  value       = [for i in aws_instance.app : i.id]
}

output "instance_public_ips" {
  description = "Public IPs of created instances (if available)"
  value       = [for i in aws_instance.app : i.public_ip]
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "latest_ami" {
  value = data.aws_ami.amazon_linux2.id
}
