output "app_gateway_public_ip" {
  value       = module.app_gateway.public_ip
  description = "The public IP address of the Application Gateway"
}