variable "region" {
    type = string
    default = "northamerica-northeast2"
}

variable "db_version" {
    type = string
    default = "POSTGRES_14"
}

variable "instance_type" {
    type = string
    default = "db-f1-micro"
}

variable "user_name" {
    type = string
    default = "statstraxler@gmail.com"
}

variable "disk" {
    type = map
    default = {
        autoresize: true,
        type: "PD_SSD",
        size: 10
    }
}

variable "ip_configuration" {
  description = "The ip_configuration settings subblock"
  default     = {}
}

variable "project_id" {
  type = string
}

variable "user_password" {
  type = string
}