terraform {
  backend "s3" {
    bucket         = "tfstate-vimala"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
