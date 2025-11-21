data "aws_ami" "amazon_linux" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]


    }
    owners = ["amazon"]
}
data "aws_vpc" "default" {
    default = true
}
data "aws_subnets" "vpc_subnets" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    
    }
}
data "aws_security_group" "default_sg" {
    filter {
        name = "group-name"
        values = ["default"]
    }
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]

    }
}
locals {
  # Ensure we don't try to create more instances than available subnets
  usable_count = min([var.instance_count, length(data.aws_subnets.vpc_subnets.ids)])
  chosen_subnet_ids = slice(data.aws_subnets.vpc_subnets.ids, 0, local.usable_count)
}

# ---------------------------
# RESOURCE: create EC2 instances using data sources
# ---------------------------
resource "aws_instance" "app" {
  # use for_each so each instance sits in a different subnet
  for_each = { for idx, sid in local.chosen_subnet_ids : idx => sid }

  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  subnet_id     = each.value

  # Use default security group from data source (not recommended for prod but OK for demo)
  vpc_security_group_ids = [data.aws_security_group.default_sg.id]

  tags = {
    Name = "ds-demo-app-${each.key}"
    VPC  = data.aws_vpc.default.id
  }
}

# ---------------------------
# OPTIONAL: show which subnets were chosen (debug)
# ---------------------------
output "chosen_subnet_ids" {
  value = local.chosen_subnet_ids
}

