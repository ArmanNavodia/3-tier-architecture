// Module declarations

module "VPC" {
  source = "./modules/VPC"
}

module "key_pair" {
  source = "./modules/key_pair"
}

module "Security_Group" {
  source = "./modules/Security_Group"
  vpc_id = module.VPC.vpc_main_out
}

module "Subnet" {
  source = "./modules/Subnet"
  vpc_id = module.VPC.vpc_main_out
}

module "Internet_Gateway" {
  source = "./modules/Internet_Gateway"
  vpc_id = module.VPC.vpc_main_out
}

// Public Application Load Balancer module

module "public_alb" {
  source            = "./modules/aws_alb"
  subnets           = module.Subnet.public_subnets_out
  vpc_id            = module.VPC.vpc_main_out
  name              = "public-alb"
  alb_sg            = [module.Security_Group.public_alb_sg]
  port_listen       = 80
  port_forward      = 80
  internal_facing   = false
  path_health_check = "/"
  asg-name          = module.autoscaling_group_frontend.name
}

// Private Application Load Balancer module

module "private_alb" {
  source            = "./modules/aws_alb"
  subnets           = module.Subnet.private_subnets_out
  vpc_id            = module.VPC.vpc_main_out
  name              = "private-alb"
  alb_sg            = [module.Security_Group.private_alb_sg]
  port_listen       = 80
  port_forward      = 5000
  internal_facing   = true
  path_health_check = "/health"
  asg-name          = module.autoscaling_group_backend.name
}

// Database module

module "Database" {
  source     = "./modules/Database"
  bastion_ip = module.bastion_instance.bastion_public_ip
  elastic_ip = module.natgateway.elatic_ip_out
}

module "bastion_instance" {
  source                    = "./modules/bastion"
  key_pair_id               = module.key_pair.key_pair_id_out
  set_Security_Group_public = [module.Security_Group.public_instance_sg]
  public_subnet             = module.Subnet.public_subnets_out[0]
}
// EC2 instance module

# module "EC2_instance" {
#   source                     = "./modules/aws_instance"
#   list_public_subnet         = module.Subnet.public_subnets_out
#   list_private_subnet        = module.Subnet.private_subnets_out
#   set_Security_Group_public  = [module.Security_Group.public_instance_sg]
#   set_Security_Group_private = [module.Security_Group.private_instance_sg]
#   key_pair_id                = module.key_pair.key_pair_id_out
#   pvtalb_dns_name            = module.private_alb.load_balancer_out
#   database_server            = module.Database.ec2_db_out
#   db_instance_private_ip     = module.Database.db_instance_private_ip_out
#   depends_on                 = [module.Database]
# }

// NAT Gateway module

module "natgateway" {
  source        = "./modules/NAT_Gateway"
  public_subnet = module.Subnet.public_subnets_out[0]
}

// Route table module

module "route_table" {
  vpc_id              = module.VPC.vpc_main_out
  internet_gateway_id = module.Internet_Gateway.internet_gateway_out
  source              = "./modules/aws_route_table"
  public_subnets      = module.Subnet.public_subnets_out
  private_subnets     = module.Subnet.private_subnets_out
  natgateway_id       = module.natgateway.nat_gw_out
}

// Null resource to execute script on the database instance

resource "null_resource" "execute_script_on_bastion_instance" {
  depends_on = [module.bastion_instance]

  triggers = {
    instance_id = module.bastion_instance.bastion_public_ip
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/modules/key_pair/id_rsa")
    host        = module.bastion_instance.bastion_public_ip
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "${path.module}/install_mongo.sh"
    destination = "/home/ubuntu/install_mongo.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_mongo.sh",
      "sh /home/ubuntu/install_mongo.sh",
    ]
  }
}

# data "template_file" "addmenuTemplate" {
#   template = file("${path.module}/addMenu.sh")
#   vars={
#     MONGO_URL=module.Database.output_connection_string_with_username_password
#   }
#   }

resource "null_resource" "script_to_add_menu_database" {
  # depends_on = [ null_resource.execute_script_on_server_instance ]
  depends_on = [module.bastion_instance, module.Database, null_resource.execute_script_on_bastion_instance]
  triggers = {
    instance_id = module.Database.output_connection_string_with_username_password
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/modules/key_pair/id_rsa")
    host        = module.bastion_instance.bastion_public_ip
    timeout     = "1m"
  }

  provisioner "file" {
    #source      = data.template_file.addmenuTemplate.rendered
    content = templatefile("${path.module}/addMenu.sh",
    {MONGO_URL=module.Database.output_connection_string_with_username_password})
    destination = "/home/ubuntu/addMenu.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/addMenu.sh",
      "sh /home/ubuntu/addMenu.sh",
    ]
  }
}


// Auto Scaling Group module

module "autoscaling_group_frontend" {
  source                        = "./modules/ASG"
  name                          = "frotend_asg"
  set_Security_Group            = [module.Security_Group.public_instance_sg]
  alb_dns                       = module.public_alb.load_balancer_out
  list_subnet                   = module.Subnet.public_subnets_out
  key_pair_id                   = module.key_pair.key_pair_id_out
  lb_targetgrp_arn_out          = module.public_alb.lb_targetgrp_arn_out
  min_size                      = var.min_size_webrole
  max_size                      = var.max_size_webrole
  desired_capacity              = var.desired_capacity_webrole
  instance_type                 = var.frontend_inst_type
  boolean_public_ip_to_instance = true
  set_Security_Group_instance   = [module.Security_Group.public_instance_sg]
  user_data_script = base64encode(templatefile("${path.module}/installClient.sh", {
    alb_dns = module.private_alb.load_balancer_out
  }))
  depends_on = [module.private_alb]
}
module "autoscaling_group_backend" {
  source                        = "./modules/ASG"
  name                          = "backend_asg"
  set_Security_Group            = [module.Security_Group.private_instance_sg]
  alb_dns                       = module.public_alb.load_balancer_out
  list_subnet                   = module.Subnet.private_subnets_out
  key_pair_id                   = module.key_pair.key_pair_id_out
  lb_targetgrp_arn_out          = module.private_alb.lb_targetgrp_arn_out
  min_size                      = var.min_size_bgrole
  max_size                      = var.max_size_bgrole
  desired_capacity              = var.desired_capacity_bgrole
  instance_type                 = var.backend_inst_type
  boolean_public_ip_to_instance = false
  set_Security_Group_instance   = [module.Security_Group.private_instance_sg]
  user_data_script = base64encode(templatefile("${path.module}/installServer.sh", {
    #    dbinstance_ip=module.Database.db_instance_private_ip_out
    MONGO_URL = module.Database.output_connection_string_with_username_password
  }))
  depends_on = [module.Database]
}