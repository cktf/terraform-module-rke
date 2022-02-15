# Terraform Module RKE

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

  type     = "k3s"
  registry = "https://mirror.gcr.io"
  masters = {
    master1 = {
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
    master2 = {
      name   = "Master2"
      labels = ["platform=linux"]
      taints = []
      connection = {
        type     = "ssh"
        host     = "192.168.100.11"
        user     = "ubuntu"
        password = "ubuntu"
      }
    }
  }

  workers = {
    worker1 = {
      name   = "Worker1"
      labels = ["platform=linux"]
      taints = []
      connection = {
        type     = "ssh"
        host     = "192.168.100.20"
        user     = "ubuntu"
        password = "ubuntu"
      }
    }
    worker2 = {
      name   = "Worker2"
      labels = ["platform=linux"]
      taints = []
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

[MIT](mit)
