#fetch data of availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names , 0 ,3 )
  public_subnet = [for k , az in local.azs : cidrsubnet(var.cidr_block , var.bits , k)]
  private_subnet = [for k , az in local.azs : cidrsubnet(var.cidr_block , var.bits , 10 + k)]
}