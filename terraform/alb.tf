resource "aws_alb" "alb" {
  load_balancer_type = "application"
  name               = "application-load-balancer"
  subnets            = aws_subnet.public_subnets.*.id
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_alb_target_group" "target_group" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}
