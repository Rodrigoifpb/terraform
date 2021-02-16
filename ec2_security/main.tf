provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "seg-lb" {
  name        = "seg-lb"
  description = "segurança do lb"
  vpc_id      = "${aws_vpc.rede.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Load Balancer"
  }
}

resource "aws_lb" "lb" {
  name            = "ALB"
  security_groups = ["${aws_security_group.seg-lb.id}"]
  subnets         = ["${aws_subnet.public_a.id}"]

  tags {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.rede.id}"

  health_check = {
    path              = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "lbl" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }
}

resource "aws_security_group" "autoscaling" {
  name        = "autoscaling"
  description = "seg do autoscaling para acesso ssh e http"
  vpc_id      = "${aws_vpc.rede.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.seg-lb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Auto Scaling"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = "autoscaling-launcher"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_pair}"
  security_groups             = ["${aws_security_group.autoscaling.id}"]
  associate_public_ip_address = true

  user_data = "${file("script.sh")}"
}

resource "aws_autoscaling_group" "thi" {
  name                      = "thi"
  vpc_zone_identifier       = ["${aws_subnet.public_a.id}"]
  launch_configuration      = "${aws_launch_configuration.this.name}"
  min_size                  = 2
  max_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.tg.arn}"]
  enabled_metrics           = ["${var.enabled_metrics}"]
}

module "scaleup" {
  source = "./scale_policy"

  name = "scaleup"

  autoscaling_group_name = "${aws_autoscaling_group.thi.name}"

  scaling_adjustment = "1"
}

module "scaledown" {
  source = "./scale_policy"

  name = "scaledown"

  autoscaling_group_name = "${aws_autoscaling_group.thi.name}"

  scaling_adjustment = "-1"
}

# cloudwatch alarmes

resource "aws_cloudwatch_metric_alarm" "up" {
  alarm_name          = "ALB Scale UP"
  alarm_description   = "Subir ec2 quando for igual ou maior que 80% do uso de cpu 1 vez em 60 segundos"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.thi.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${module.scaleup.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "down" {
  alarm_name          = "ALB Scale DOWN"
  alarm_description   = "Descer ec2 se o uso de cpu for menor ou igual a 50% 1 vez em 60 segundos"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.thi.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${module.scaledown.arn}"]
}