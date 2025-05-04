data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Owner ID for Canonical
  filter {
    name   = "name"
    values = ["${var.image_name}"]  # Filtering by image name provided as a variable
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]  # Filter for EBS root device type
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Filter for HVM virtualization type
  }
}
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id  # Using the Ubuntu AMI data source
  instance_type               = "t2.micro"  # Instance type for the frontend
  key_name                    = var.key_pair_id  # SSH key pair for authentication
  subnet_id                   = var.public_subnet  # Subnet for the instance
  vpc_security_group_ids      = var.set_Security_Group_public  # Security groups for the instance
  associate_public_ip_address = true  # Assigning public IP address
  tags = {
    Name = "bastion"  # Tagging the instance
  }
}