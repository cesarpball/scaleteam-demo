variable "project_name" {
  default = "nginx"
}

# ALB
variable "scale_alb_internal" {
  description = "Specify if the ALB is internet facing or not"
  type        = bool
  default     = false
}
variable "scale_alb_timeout" {
  description = "Specify the ALB timeout"
  type        = string
  default     = "60"
}

variable "scale_alb_enable_deletion_protection" {
  description = "Prevent ALB from deletion"
  type        = bool
  default     = false
}

#TG
variable "scale_tg_port" {
  description = "Target Group Port"
  type        = number
  default     = 80
}

variable "scale_tg_protocol" {
  description = "Target Group Port"
  type        = string
  default     = "HTTP"
}


variable "scale_health_check_port" {
  description = "Port to use to connect with the target. Valid values are either ports 1-65535"
  type        = number
  default     = 80
}
variable "scale_health_check_protocol" {
  description = "Protocol to use to connect with the target. Defaults to HTTP"
  type        = string
  default     = "HTTP"
}

variable "scale_health_check_path" {
  description = "Protocol to use to connect with the target. Defaults to HTTP"
  type        = string
  default     = "/"
}

variable "scale_health_check_healthy_threshold" {
  description = "Protocol to use to connect with the target. Defaults to HTTP"
  type        = number
  default     = 3
}

variable "scale_health_check_unhealthy_threshold" {
  description = "Protocol to use to connect with the target. Defaults to HTTP"
  type        = number
  default     = 3
}

variable "scale_health_check_interval" {
  description = "Protocol to use to connect with the target. Defaults to HTTP"
  type        = number
  default     = 30
}

variable "cidr" {
  default = "10.0.0.0/16"
}
variable "default_tags" {
  description = "Default tags"
  type        = map(string)

  default = {
    Name        = "your-name"
    cost-center = "cost"
    environment = "environment"
    app         = "nginx"

  }
}