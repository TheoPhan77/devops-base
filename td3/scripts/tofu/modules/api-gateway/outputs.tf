output "api_endpoint" {
  description = "The endpoint for the API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}
