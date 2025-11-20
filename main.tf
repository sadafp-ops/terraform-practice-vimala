resource "aws_instance" "sadaf_ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = "Sadaf-EC2-Instance"
    }
  
}