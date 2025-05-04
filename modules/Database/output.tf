output "output_connection_string" {
  value = mongodbatlas_cluster.cluster-test.connection_strings[0].standard_srv
}

output "output_allconnection_string" {
  value = mongodbatlas_cluster.cluster-test.connection_strings
}

output "output_connection_string_with_username_password" {
  value = join("",concat(["mongodb+srv://admin:admin@"],regex("(?:\\/\\/)([^\\/]+)",mongodbatlas_cluster.cluster-test.connection_strings[0].standard_srv),["/my_app"]))
}
