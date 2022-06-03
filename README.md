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

  type = "k3s"
  master_nodes = {
    0 = {
      name         = "Master1"
      pre_create   = ""
      post_create  = ""
      pre_destroy  = ""
      post_destroy = ""
      labels       = ["platform=linux"]
      taints       = []
      connection = {
        type     = "ssh"
        host     = "192.168.100.10"
        user     = "ubuntu"
        password = "ubuntu"
      }
    }
  }
  worker_nodes = {
    0 = {
      name         = "Worker1"
      pre_create   = ""
      post_create  = ""
      pre_destroy  = ""
      post_destroy = ""
      labels       = ["platform=linux"]
      taints       = []
      connection = {
        type     = "ssh"
        host     = "192.168.100.20"
        user     = "ubuntu"
        password = "ubuntu"
      }
    }
    1 = {
      name         = "Worker2"
      pre_create   = ""
      post_create  = ""
      pre_destroy  = ""
      post_destroy = ""
      labels       = ["platform=linux"]
      taints       = []
      connection = {
        type     = "ssh"
        host     = "192.168.100.21"
        user     = "ubuntu"
        password = "ubuntu"
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
