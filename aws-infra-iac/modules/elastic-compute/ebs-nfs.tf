resource "aws_ebs_volume" "nfs_shared_storage" {
  availability_zone = var.azs[0]
  size              = 25
  type              = "gp3"
  encrypted         = true
  
  tags = {
    Name        = "swarm-nfs-shared-storage"
    Environment = "production"
    Purpose     = "NFS Shared Storage for Docker Swarm"
  }
}

resource "aws_volume_attachment" "nfs_shared_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.nfs_shared_storage.id
  instance_id = aws_instance.managers[0].id
}