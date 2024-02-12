output "id" {
  description = "The ID of the Load Balancer"
  value       = module.load-balancer.id
}

output "ip" {
  description = "The IP address of the Load Balancer"
  value       = module.load-balancer.ip
}

output "urn" {
  description = "The Uniform Resource Name (URN) of the Load Balancer"
  value       = module.load-balancer.urn
}
