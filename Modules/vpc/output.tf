output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.app_vpc.id
}

output "subnet_ids" {
  description = "The ID of the subnet"
  value       = [aws_subnet.app_subnet.id]    
}