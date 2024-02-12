provider "digitalocean" {

}

locals {
  name        = "demo"
  environment = "lb"
  region      = "nyc3"
}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "git::https://github.com/opsstation/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = local.name
  environment = local.environment
  label_order = ["name", "environment"]
  region      = local.region
  ip_range    = "10.10.0.0/24"

}

##------------------------------------------------
module "droplet" {
  source             = "git::https://github.com/opsstation/terraform-digitalocean-droplet.git?ref=v1.0.0"
  name               = local.name
  environment        = local.environment
  region             = local.region
  image_name         = "ubuntu-22-04-x64"
  ipv6               = false
  backups            = false
  monitoring         = false
  droplet_size       = "s-1vcpu-1gb"
  droplet_count      = 2
  block_storage_size = 5
  vpc_uuid           = module.vpc.id
  ssh_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQA"
  user_data          = file("user-data.sh")
  inbound_rules = [
    {
      allowed_ip    = ["0.0.0.0/0"]
      allowed_ports = "22"
    },
    {
      allowed_ip    = ["0.0.0.0/0"]
      allowed_ports = "80"
    }
  ]
}
##------------------------------------------------
## Load Balancer module call
##------------------------------------------------
module "load-balancer" {
  source                         = "./../../"
  name                           = local.name
  environment                    = local.environment
  region                         = local.region
  vpc_uuid                       = module.vpc.id
  droplet_ids                    = module.droplet.id
  enabled_redirect_http_to_https = false
  forwarding_rule = [
    {
      entry_port      = 80
      entry_protocol  = "http"
      target_port     = 80
      target_protocol = "http"
    },
    {
      entry_port       = 443
      entry_protocol   = "http"
      target_port      = 80
      target_protocol  = "http"
      certificate_name = "test"
    }
  ]
}
