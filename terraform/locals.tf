locals {
  subnets = flatten([aws_subnet.public_subnets.*.id])
}

