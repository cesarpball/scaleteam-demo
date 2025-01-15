output "dns_alb" {
  description = "DNS value for the ALB"
  value       = aws_lb.scale.dns_name
}