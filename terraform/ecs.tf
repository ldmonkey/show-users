resource "aws_ecs_cluster" "ecs-cluster" {
  name = "all-users-flask-webapp"

  tags = {
    Name = "all-users-flask-webapp"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "all-users-flask-webapp"
  requires_compatibilities = [
  "FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = 256
  memory                = 512
  execution_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  container_definitions = data.template_file.task_definition_template.rendered
}

resource "aws_ecs_service" "flask-service" {
  name            = "all-users-flask-webapp-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [
    aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.public_subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "all-users-flask-webapp"
    container_port   = var.flask_app_port
    target_group_arn = aws_alb_target_group.target_group.id
  }

  depends_on = [
    aws_alb_listener.alb-listener
  ]
}
