output "dns_alb" {
  value = aws_lb.scale.dns_name
}