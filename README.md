# Terraform Module RKE

![pipeline](https://github.com/cktf/terraform-module-rke/actions/workflows/cicd.yml/badge.svg)
![release](https://img.shields.io/github/v/release/cktf/terraform-module-rke?display_name=tag)
![license](https://img.shields.io/github/license/cktf/terraform-module-rke)

**RKE** is a Terraform module useful for bootstraping **HA** kubernetes clusters using **k3s** and **rke2** on **Remote Machines**

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/module"

  name = "master"
  type = "k3s"
  labels = {
    platform = "linux"
  }
  connections = [{
    type     = "ssh"
    host     = "192.168.172.185"
    port     = 22
    user     = "ubuntu"
    password = "ubuntu"
  }]

  node_pools = {
    pool1 = {
      name = "node"
      connections = [
        {
          type     = "ssh"
          host     = "192.168.172.186"
          port     = 22
          user     = "ubuntu"
          password = "ubuntu"
        },
        {
          type     = "ssh"
          host     = "192.168.172.187"
          port     = 22
          user     = "ubuntu"
          password = "ubuntu"
        }
      ]
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
