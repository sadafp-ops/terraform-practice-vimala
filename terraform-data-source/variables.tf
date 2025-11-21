variable "aws_region" {
    description = "The AWS region to create resources in"
    type = string
    default = "us-east-1"
}
variable "instance_type" {
    description = "The type of instance to create"
    type = string
    default = "t3.micro"
}

variable "instance_count" {
    description = "The number of instances to create"
    type = number
    default = 2

}
variable "tags" {
    description = "A map of tags to assign to the resources"
    type = map(string)
    default = {}
}