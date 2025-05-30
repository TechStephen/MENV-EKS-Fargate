output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.app_vpc.id
}

output "subnet_ids" {
  description = "The ID of the subnet"
  value       = [aws_subnet.app_subnet_one.id, aws_subnet.app_subnet_two.id, aws_subnet.nat_subnet_one.id, aws_subnet.nat_subnet_two.id]    
}