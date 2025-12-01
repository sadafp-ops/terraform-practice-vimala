output "instance_public_ip" {
  description = "Public IP of k3s node"
  value       = aws_instance.k3s_node.public_ip
}

output "k3s_instance_id" {
  description = "ID of the k3s EC2 instance"
  value       = aws_instance.k3s_node.id
}