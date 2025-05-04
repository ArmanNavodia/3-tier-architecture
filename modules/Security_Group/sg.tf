# Create a security group for the public facing Application Load Balancer (ALB)
resource "aws_security_group" "public_alb_security_group" {
  name        = "public_alb_sg"
  description = "Security group for public-facing ALB"
  vpc_id      = var.vpc_id

  # Ingress rule allowing HTTP traffic from anywhere
  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the private facing ALB
resource "aws_security_group" "private_ALB_sg" {
  name        = "private_alb_sg"
  description = "Security group for private-facing ALB"
  vpc_id      = var.vpc_id

  # Ingress rule allowing HTTP traffic from instances in the public instance security group
  ingress {
    description     = "HTTP from private Instance"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instance_sg.id]
  }

  # Ingress rule allowing SSH traffic from anywhere
  ingress {
    description = "SSH from Public Instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dependency on the public instance security group
  depends_on = [aws_security_group.public_instance_sg]
}

# Create a security group for the public facing instance
resource "aws_security_group" "public_instance_sg" {
  name        = "public_instance_sg"
  description = "Security group for public-facing instance"
  vpc_id      = var.vpc_id

  # Ingress rule allowing HTTP traffic from the public ALB security group
  ingress {
    description     = "HTTP from Public Instance"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb_security_group.id]
  }

  # Ingress rule allowing SSH traffic from anywhere
  ingress {
    description = "SSH from Public Instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dependency on the public ALB security group
  depends_on = [aws_security_group.public_alb_security_group]
}

# Create a security group for the private instance
resource "aws_security_group" "private_instance_sg" {
  name        = "private_instance_sg"
  description = "Security group for private instance"
  vpc_id      = var.vpc_id

  # Ingress rule allowing HTTP traffic from the private ALB security group
  ingress {
    description     = "HTTP from private ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ALB_sg.id]
  }

  # Ingress rule allowing SSH traffic from the public instance security group
  ingress {
    description     = "SSH from Public Instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instance_sg.id]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dependency on the private ALB security group
  depends_on = [aws_security_group.private_ALB_sg]
}

# Create a security group for the database instance
resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Security group for database instance"
  vpc_id      = var.vpc_id

  # Ingress rule allowing MongoDB traffic from the private instance security group
  ingress {
    description     = "Mongo from private Instance"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.private_instance_sg.id]
  }

  # Ingress rule allowing SSH traffic from the public instance security group
  ingress {
    description     = "SSH from Public Instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instance_sg.id]
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dependency on the private instance security group
  depends_on = [aws_security_group.private_instance_sg]
}
