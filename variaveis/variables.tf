variable "region" {
  type        = "string"
  default     = "us-east-1"
  description = "regiao padrao"
}

variable "access_key" {
  type        = "string"
  default     = "value"
}

variable "secret_key" {
  type        = "string"
  default     = "value"
}

variable "ami" {
  type        = "string"
  default     = "value"
  description = "linux basico"
}

variable "type" {
  
}

variable "ips" {
  type        = "list"
  default     = ["192.168.160.2","192.168.160.3"]
}

variable "tags" {
  type        = "map"
  default     = {
    "Name" = "python"
    "Env" = "dev"
  }
}