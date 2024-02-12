output "id" {
  description = "The ID(s) of the DigitalOcean Load Balancer(s)"
  value       = join("", digitalocean_loadbalancer.main[*].id)
}

output "ip" {
  description = "The IP address(es) associated with the DigitalOcean Load Balancer(s)"
  value       = join("", digitalocean_loadbalancer.main[*].ip)
}

output "urn" {
  description = "The Uniform Resource Name (URN) of the DigitalOcean Load Balancer(s)"
  value       = join("", digitalocean_loadbalancer.main[*].urn)
}
