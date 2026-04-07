data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "managers" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.mngr_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.docker-swarm-sg_id
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.name_prefix}-manager-${count.index + 1}"
    Role = "manager"
    Environment = "production"
  }

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname manager-${count.index + 1}
    echo "127.0.0.1 manager-${count.index + 1}" >> /etc/hosts
  EOF
  
}

# Worker Nodes
resource "aws_instance" "workers" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.worker_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.docker-swarm-sg_id
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.name_prefix}-worker-${count.index + 1}"
    Role = "worker"
    Environment = "production"
  }

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname worker-${count.index + 1}
    echo "127.0.0.1 worker-${count.index + 1}" >> /etc/hosts
  EOF
}


#########################################################################
