# Terraform Infrastructure as Code (IaC) - digitalocean loadbalancer Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Authors](#authors)
- [License](#license)

## Introduction
This Terraform module creates structured loadbalancer for digitalocean resources with specific attributes.

## Usage

- Use the module by referencing its source and providing the required variables.

- Example:Basic
```hcl
module "load-balancer" {
  source      = "git::https://github.com/yadavprakash/terraform-digitalocean-loadbalancer.git"
  name        = local.name
  environment = local.environment
  region      = local.region
  vpc_uuid    = module.vpc.id
  droplet_ids = module.droplet.id
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
```
- Example:complete
```hcl
module "load-balancer" {
  source      = "git::https://github.com/yadavprakash/terraform-digitalocean-loadbalancer.git"
  name        = local.name
  environment = local.environment
  region      = local.region
  vpc_uuid    = module.vpc.id
  droplet_ids = module.droplet.id

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
      certificate_name = "demo"
    }
  ]

  healthcheck = [
    {
      port                     = 80
      protocol                 = "http"
      check_interval_seconds   = 10
      response_timeout_seconds = 5
      unhealthy_threshold      = 3
      healthy_threshold        = 5
    }
  ]
  sticky_sessions = [
    {
      type               = "cookies"
      cookie_name        = "lb-cookie"
      cookie_ttl_seconds = 300
    }
  ]

  firewall = [
    {
      deny  = "cidr:0.0.0.0/0"
      allow = "cidr:143.244.136.144/32"
    }
  ]
}
```
Please ensure you specify the correct 'source' path for the module.

## Module Inputs

- `name`: The name of the application.
- `environment`: The environment (e.g., "test", "production").
- `region`: The DigitalOcean region where resources will be deployed.
- `ip_range`: The IP range for the loadbalancer.
- `managedby`:  ManagedBy, eg 'yadavprakash'.


## Module Outputs
- This module currently does not provide any outputs.

# Examples
For detailed examples on how to use this module, please refer to the '[example](https://github.com/yadavprakash/terraform-digitalocean-loadbalancer/tree/master/_example)' directory within this repository.

## Authors
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/yadavprakash/terraform-digitalocean-loadbalancer/blob/master/LICENSE) file for details.



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/yadavprakash/terraform-digitalocean-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [digitalocean_loadbalancer.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/loadbalancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_algorithm"></a> [algorithm](#input\_algorithm) | The load balancing algorithm used to determine which backend Droplet will be selected by a client. It must be either round\_robin or least\_connections. The default value is round\_robin. | `string` | `"round_robin"` | no |
| <a name="input_disable_lets_encrypt_dns_records"></a> [disable\_lets\_encrypt\_dns\_records](#input\_disable\_lets\_encrypt\_dns\_records) | A boolean value indicating whether to disable automatic DNS record creation for Let's Encrypt certificates that are added to the load balancer. Default value is false. | `bool` | `false` | no |
| <a name="input_droplet_ids"></a> [droplet\_ids](#input\_droplet\_ids) | A list of the IDs of each droplet to be attached to the Load Balancer. | `list(string)` | `[]` | no |
| <a name="input_droplet_tag"></a> [droplet\_tag](#input\_droplet\_tag) | The name of a Droplet tag corresponding to Droplets to be assigned to the Load Balancer. | `string` | `null` | no |
| <a name="input_enable_backend_keepalive"></a> [enable\_backend\_keepalive](#input\_enable\_backend\_keepalive) | A boolean value indicating whether HTTP keepalive connections are maintained to target Droplets. Default value is false. | `bool` | `false` | no |
| <a name="input_enable_proxy_protocol"></a> [enable\_proxy\_protocol](#input\_enable\_proxy\_protocol) | A boolean value indicating whether PROXY Protocol should be used to pass information from connecting client requests to the backend service. Default value is false. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create the resources. Set to `false` to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_enabled_redirect_http_to_https"></a> [enabled\_redirect\_http\_to\_https](#input\_enabled\_redirect\_http\_to\_https) | A boolean value indicating whether HTTP requests to the Load Balancer on port 80 will be redirected to HTTPS on port 443. Default value is false. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | List of objects that represent the configuration of each healthcheck. | `list(any)` | `[]` | no |
| <a name="input_forwarding_rule"></a> [forwarding\_rule](#input\_forwarding\_rule) | List of objects that represent the configuration of each forwarding\_rule. | `list(any)` | `[]` | no |
| <a name="input_healthcheck"></a> [healthcheck](#input\_healthcheck) | List of objects that represent the configuration of each healthcheck. | `list(any)` | `[]` | no |
| <a name="input_http_idle_timeout_seconds"></a> [http\_idle\_timeout\_seconds](#input\_http\_idle\_timeout\_seconds) | Specifies the idle timeout for HTTPS connections on the load balancer in seconds. | `number` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_lb_size"></a> [lb\_size](#input\_lb\_size) | The size of the Load Balancer. It must be either lb-small, lb-medium, or lb-large. Defaults to lb-small. Only one of size or size\_unit may be provided. | `string` | `"lb-small"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project that the load balancer is associated with. If no ID is provided at creation, the load balancer associates with the user's default project. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create VPC, like `london-1` , `bangalore-1` ,`newyork-3` `toronto-1`. | `string` | `"blr-1"` | no |
| <a name="input_size_unit"></a> [size\_unit](#input\_size\_unit) | The size of the Load Balancer. It must be in the range (1, 100). Defaults to 1. Only one of size or size\_unit may be provided. | `number` | `1` | no |
| <a name="input_sticky_sessions"></a> [sticky\_sessions](#input\_sticky\_sessions) | List of objects that represent the configuration of each healthcheck. | `list(any)` | `[]` | no |
| <a name="input_vpc_uuid"></a> [vpc\_uuid](#input\_vpc\_uuid) | The ID of the VPC where the load balancer will be located. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID(s) of the DigitalOcean Load Balancer(s) |
| <a name="output_ip"></a> [ip](#output\_ip) | The IP address(es) associated with the DigitalOcean Load Balancer(s) |
| <a name="output_urn"></a> [urn](#output\_urn) | The Uniform Resource Name (URN) of the DigitalOcean Load Balancer(s) |
<!-- END_TF_DOCS -->
