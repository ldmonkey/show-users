data "aws_availability_zones" "azs" {}

data "template_file" "task_definition_template" {
  template = file("task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = var.flask_app_image
  }
}

data "aws_caller_identity" "current" {}