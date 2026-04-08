variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instances."
  type        = string
}

variable "mngr_instance_type" {
  description = "Instance type for manager nodes"
  type        = string
}

variable "worker_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
}

variable "docker-swarm-sg_id" {
  description = "Swarm security group IDs for communication"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable azs {
  description = "List of availability zones"
  type        = list(string)
}