output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.gmk-vpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "docker-swarm-manager-sg_id" {
  description = "Security Group ID for Docker Swarm Manager"
  value       = aws_security_group.swarm.id
  
}

output "docker-swarm-lb-sg_id" {
  description = "Security Group ID for Docker Swarm Load Balancer"
  value       = aws_security_group.swarm_lb.id
}