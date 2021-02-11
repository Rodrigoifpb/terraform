resource "aws_autoscaling_policy" "thi" {
  name                   = "${var.name}"
  autoscaling_group_name = "${var.autoscaling_group_name}"
  adjustment_type        = "${var.adjustment_type}"
  scaling_adjustment     = "${var.scaling_adjustment}"
  cooldown               = "${var.cooldown}"
  policy_type            = "${var.policy_type}"
}