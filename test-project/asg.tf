# creates ami image from an ec2 instance
resource "aws_ami_from_instance" "utcwebappami" {
  name = var.ami_name
  source_instance_id = aws_instance.webapps[keys(aws_instance.webapps)[0]].id
  depends_on = [ aws_instance.webapps ]
}


# launch template using ami image
resource "aws_launch_template" "launchtemplate" {
    instance_type = var.instance_type
    image_id = aws_ami_from_instance.utcwebappami.id
    vpc_security_group_ids = [aws_security_group.WebAppSG.id]
    key_name = aws_key_pair.utcwebapp.key_name
    user_data = base64encode(templatefile("userdata.tftpl", {efsid=aws_efs_file_system.efs.id, bucket_name=aws_s3_bucket.utcbucket.bucket}))
    private_dns_name_options {
      hostname_type = "ip-name"
    }
    iam_instance_profile {
      arn = aws_iam_instance_profile.webappprofile.arn
    }
}


# ASG from launch template
resource "aws_autoscaling_group" "utcasg" {
  name = "utcasg"
  vpc_zone_identifier = values(module.vpc.private_app_subnet_ids)
  desired_capacity = 1
  max_size = 2
  min_size = 1
  launch_template {
    id = aws_launch_template.launchtemplate.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [ desired_capacity, target_group_arns ]
  }
}

#and add it to the alb
resource "aws_autoscaling_attachment" "asgattachment" {
  autoscaling_group_name = aws_autoscaling_group.utcasg.id
  lb_target_group_arn = aws_lb_target_group.alb_tg.arn
}


# ASG policy (scale up)
resource "aws_autoscaling_policy" "scailing_up" {
  name = "utcscaleuppolicy"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  autoscaling_group_name = aws_autoscaling_group.utcasg.name
  cooldown = 300
}


# cloudwatch alarm to trigger the ASG policy to scale up instances when cpu reaches 80%
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "utc-scale-up"
  alarm_description = "Alarm to scale up instances"
  alarm_actions = [aws_autoscaling_policy.scailing_up.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  statistic = "Average"
  namespace = "AWS/EC2"
  period = 120
  threshold = 80
  dimensions = {
    AutoScailingGroupName = aws_autoscaling_group.utcasg.name
  }
}


# ASG policy to scale down instances when CPU goes down. (removing instances)
resource "aws_autoscaling_policy" "scailing_down" {
  name = "utcscaleuppolicy"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  autoscaling_group_name = aws_autoscaling_group.utcasg.name
  cooldown = 300
}


# cloudwatch alarm to trigger the ASG policy to remove instances when cpu goes down
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name = "utc-scale-up"
  alarm_description = "Alarm to scale down instances when using less than or equal to 60"
  alarm_actions = [aws_autoscaling_policy.scailing_down.arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  statistic = "Average"
  namespace = "AWS/EC2"
  period = 120
  threshold = 60
  dimensions = {
    AutoScailingGroupName = aws_autoscaling_group.utcasg.name
  }
}


# sns topic
resource "aws_sns_topic" "snstopic" {
  name = "${var.project_Name}-topic"
}


# subscription for that topic with the team email.
resource "aws_sns_topic_subscription" "snssub" {
  protocol = "email"
  topic_arn = aws_sns_topic.snstopic.arn
  endpoint = var.email
}


#Configure auto-scaling notification using that topic.
resource "aws_autoscaling_notification" "name" {
  group_names = [ aws_autoscaling_group.utcasg.name ]
  topic_arn = aws_sns_topic.snstopic.arn
  notifications = [ 
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
   ]
}