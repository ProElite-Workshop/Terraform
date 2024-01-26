variable "cidr_ab" {
    type = map
    default = {
        Non-Prod  = "192"
        Prod      = "172"
    }
}

locals {
    private_subnets         = [
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.4.0/24",
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.5.0/24",
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.6.0/24"
    ]

    public_subnets          = [
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.1.0/24",
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.2.0/24",
        "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.3.0/24"
    ]
}

data "aws_availability_zones" "available" {
    state = "available"
}



variable "cidr_range" {
    type = string
    description = "cidr_range"
}

locals {
    availability_zones = data.aws_availability_zones.available.names
}

variable "environment" {
    type = string
    description = "Options: Non-Prod,Prod"
}

variable "TenantName" {
    type = string
    description = "Name of the TenantName"
}


variable "cluster_version" {
    type = string
    description = "cluster_version"
}

#RDS database variables

variable "storage_type" {
    type = number
    default = null
    description = "Storage type for RDS Database"
}
variable "engine" {
    type = string
    description = "RDS Database Engine Name"
}

variable "engine_version" {
    type = string
    description = "RDS Database Engine Version"
}

variable "instance_class" {
    type = string
    description = "RDS Database Instance type/class"
}


variable "username" {
    type = string
    description = "RDS Database Username"
}

variable "password" {
    type = string
    description = "RDS Database Password"
}

variable "db_name" {
    type = string
    description = "RDS Database Name"
}



variable "db_subnet_group_description" {
    type = string
    description = "subnet group description"
}