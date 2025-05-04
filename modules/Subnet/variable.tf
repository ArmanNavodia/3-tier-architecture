variable "subnets_public"{
type=list(object({
    name = string
    cidr_block= string
    az=string
}))
default = [ 
    {name="publicSubnetA", cidr_block="10.0.1.0/24", az="ap-south-1a"},
    {name="publicSubnetB", cidr_block="10.0.2.0/24", az="ap-south-1b"},
 ]
}
variable "vpc_id" {
  
}
variable "subnets_private"{
type=list(object({
    name = string
    cidr_block= string
    az=string
}))
default = [ 
   {name="privateSubnetA", cidr_block="10.0.3.0/24", az="ap-south-1a"},
    {name="privateSubnetB", cidr_block="10.0.4.0/24", az="ap-south-1b"}
 ]
}
