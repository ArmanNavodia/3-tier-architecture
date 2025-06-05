output "key_pair_id_out" {
  value = aws_key_pair.terraform-key.id 
   }
  output "private_key_pem" {
  value     = tls_private_key.id_rsa.private_key_pem
  sensitive = true
}