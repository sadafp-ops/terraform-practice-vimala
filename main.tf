resource "aws_instance" "sadaf-ec2-servers" {
  for_each      = var.servers
  ami           = var.ami_id
  instance_type = each.value.var.instance_type

  tags = {
    Name = each.key
  }
}
