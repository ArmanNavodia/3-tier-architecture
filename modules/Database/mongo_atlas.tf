 terraform{
 required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.4.6"
    }
  }
 }
resource "mongodbatlas_cluster" "cluster-test" {
  project_id              = "662246844cede663ddd13b16"
  name                    = "TEST"

  # Provider Settings "block"
  provider_name = "TENANT"
  backing_provider_name = "AWS"
  provider_region_name = "AP_SOUTH_1"
  provider_instance_size_name = "M0"
}

//whitelist ip address of white bastion ip
resource "mongodbatlas_project_ip_access_list" "whitelist_bastion_ip" {
  project_id = "662246844cede663ddd13b16"
  ip_address = var.bastion_ip
  comment    = "bastion ip"
}

//whitelist  elastic ip
resource "mongodbatlas_project_ip_access_list" "whitelist_elastic_ip" {
  project_id = "662246844cede663ddd13b16"
  ip_address = var.elastic_ip
  comment    = "elastic ip"
}
resource "mongodbatlas_database_user" "test" {
  username           = "admin"
  password           = "admin"
  project_id         = "662246844cede663ddd13b16"
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = mongodbatlas_cluster.cluster-test.name
  }
    roles {
    role_name     = "readWrite"
    database_name = "my_app"
  }

  labels {
    key   = "user"
    value = "admin"
  }
  labels {
    key = "password"
    value="admin"
  }


}

