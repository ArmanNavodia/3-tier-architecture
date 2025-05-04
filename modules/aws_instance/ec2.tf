# Data source to retrieve the latest Ubuntu AMI meeting specific criteria
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

# Resource block for the frontend instance
resource "aws_instance" "frontend" {
  count                       = length(var.list_public_subnet)  # Creating instances based on the count of public subnets
  ami                         = data.aws_ami.ubuntu.id  # Using the Ubuntu AMI data source
  instance_type               = "t2.medium"  # Instance type for the frontend
  key_name                    = var.key_pair_id  # SSH key pair for authentication
  subnet_id                   = var.list_public_subnet[count.index]  # Subnet for the instance
  vpc_security_group_ids      = var.set_Security_Group_public  # Security groups for the instance
  associate_public_ip_address = true  # Assigning public IP address
  tags = {
    Name = "WebServer - ${count.index}"  # Tagging the instance
  }

  # Connection settings for SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/../key_pair/id_rsa")
    host        = self.public_ip
  }

  # Provisioning files from local to remote machine
  provisioner "file" {
    source      = "${path.module}/installClient.sh"
    destination = "/home/ubuntu/installClient.sh"
  }

  # Executing commands on the remote machine
  provisioner "remote-exec" {
    inline = [
      "echo finding dns name",
      "echo 'ALB_DNS_NAME=${var.pvtalb_dns_name}'",
      "echo \"export SERVER_URL=http://${var.pvtalb_dns_name}\" >> /home/ubuntu/.bashrc",
      "export SERVER_URL=http://${var.pvtalb_dns_name}",
      "echo $SERVER_URL",
      "echo set finished",
      "chmod +x /home/ubuntu/installClient.sh",
      "sh /home/ubuntu/installClient.sh",
    ]
  }

  # Dependencies of frontend instance
  depends_on = [var.pvtalb_dns_name, aws_instance.backend]
}

# Resource block for the backend instance
resource "aws_instance" "backend" {
  count                       = length(var.list_public_subnet)  # Creating instances based on the count of private subnets
  ami                         = data.aws_ami.ubuntu.id  # Using the Ubuntu AMI data source
  instance_type               = "t2.medium"  # Instance type for the backend
  key_name                    = var.key_pair_id  # SSH key pair for authentication
  subnet_id                   = var.list_private_subnet[count.index]  # Subnet for the instance
  vpc_security_group_ids      = var.set_Security_Group_private  # Security groups for the instance
  associate_public_ip_address = false  # Not assigning public IP address
  tags = {
    Name = "App server - ${count.index}"  # Tagging the instance
  }
}
