resource "aws_instance" "vimala_ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = "Sadaf-EC2-Instance"
    }
  
}