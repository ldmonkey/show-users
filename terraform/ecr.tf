resource "aws_ecr_repository" "this" {
  name                 = "all-users-flask-webapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
