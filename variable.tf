variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
  
}
variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
  default     = "default"
  
}
variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
  
}
variable  "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0ecb62995f68bb549" // Example AMI ID for Amazon Linux 2 in us-west-2{
  
}