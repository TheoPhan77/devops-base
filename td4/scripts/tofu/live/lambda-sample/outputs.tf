output "api_endpoint" {
  description = "The API Gateway endpoint"
  value       = "${trim(module.gateway.api_endpoint, "/")}/"
}