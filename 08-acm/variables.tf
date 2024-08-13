# Project Variables
variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "zone_name" {
  default = "harshadevops.site"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = true
  }
}
