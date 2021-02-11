variable "name" {}

variable "adjustment_type" {
  default = "ChangeInCapacity"
}

variable "autoscaling_group_name" {}

variable "scaling_adjustment" {}

variable "cooldown" {
  default = "300"
}

variable "policy_type" {
  default = "SimpleScaling"
}
