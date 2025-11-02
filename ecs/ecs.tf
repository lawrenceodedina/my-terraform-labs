#ecs cluster
resource "aws_ecs_cluster" "myecscluster" {
  name = "uzumaki-cluster"
}

#ecs task definiton
resource "aws_ecs_task_definition" "mytaskdef" {
  family = "uzumaki-family"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu    = "1024"
  memory = "2048"
  execution_role_arn = aws_iam_role.ecstaskrole.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.image_name}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
TASK_DEFINITION
runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture = "X86_64"
}
}

#ecs service
resource "aws_ecs_service" "myecsservice" {
  name            = "uzumaki"
  launch_type = "FARGATE"
  cluster         = aws_ecs_cluster.myecscluster.id
  task_definition = aws_ecs_task_definition.mytaskdef.arn
  desired_count   = 2
  load_balancer {
    target_group_arn = aws_lb_target_group.uzumakitg.arn
    container_name   = var.container_name
    container_port   = 80
  }
  network_configuration {
   subnets = [ aws_subnet.sub1.id, aws_subnet.sub2.id ]
   security_groups = [aws_security_group.albsg.id]
   assign_public_ip = true
 }
}