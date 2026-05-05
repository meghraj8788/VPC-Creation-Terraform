output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = [for subnet in aws_subnet.public-rt : subnet.id]
}

output "private_subnet_id" {
  value = [for subnet in aws_subnet.private-rt : subnet.id]
}

output "az_map_public_subnet" {
  value = { for idx, az in local.azs : az => local.public_subnet[idx] }
}

output "az_map_private_subnet" {
  value = { for idx, az in local.azs : az => local.private_subnet[idx] }
}