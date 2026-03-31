data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
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
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}-manager-${count.index + 1}"
    Role = "manager"
  }

  user_data = templatefile("${path.module}/userdata.sh", {
    node_role   = "manager"
    environment = "dev"
  })
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
    volume_size = 25
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}-worker-${count.index + 1}"
    Role = "worker"
  }

  user_data = templatefile("${path.module}/userdata.sh", {
    node_role   = "worker"
    environment = "dev"
  })
}
