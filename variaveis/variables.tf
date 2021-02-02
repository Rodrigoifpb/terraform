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
  default     = ["2001:0DB8:AD1F:25E2:CADE:CAFE:F0CA:84C1","2001:0DB8:AD1F:25E2:CADE:CAFE:F0CB:84C1"]
}

variable "tags" {
  type        = "map"
  default     = {
    "Name" = "python"
    "Env" = "dev"
  }
}