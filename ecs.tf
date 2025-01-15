# resource "aws_ecr_repository" "nginx" {
#   name                 = "nginx"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }


module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "scale-nginx"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/scale"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }


  tags = var.default_tags

}

resource "aws_ecs_service" "nginx-hello" {
  name            = "${var.project_name}-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 2

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }

  network_configuration {
    security_groups  = [aws_security_group.sg_task.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.scale.arn
    container_name   = "nginx-hello"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "nginx" {
  family = "api"
  #task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  #execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name  = "nginx-hello"
      image = "nginxdemos/hello:0.4"

      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

    }
  ])
}