# Terraform Module RKE

![pipeline](https://github.com/cktf/terraform-module-rke/actions/workflows/cicd.yml/badge.svg)
![release](https://img.shields.io/github/v/release/cktf/terraform-module-rke?display_name=tag)
![license](https://img.shields.io/github/license/cktf/terraform-module-rke)

Terraform alternative to [k3sup](https://github.com/alexellis/k3sup), which supports both [K3s](https://k3s.io/) and [RKE2](https://rke2.io/)

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/module"

  type      = "k3s"
  server_ip = "192.168.100.10"

  servers = {
    1 = {
      connection = {
        type     = "ssh"
        host     = "192.168.100.10"
        port     = 22
        user     = "root"
        password = "pass"
      }
    }
  }
  agents = {
    1 = {
      connection = {
        type     = "ssh"
        host     = "192.168.100.11"
        port     = 22
        user     = "root"
        password = "pass"
      }
    }
  }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

This project is licensed under the [MIT](LICENSE.md).  
Copyright (c) KoLiBer (koliberr136a1@gmail.com)
