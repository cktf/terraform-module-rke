# Terraform Module RKE

**RKE** is a Terraform module defining the required resources for creating a `rke2`, `k3s` cluster using `remote shell connection`

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/module"

  name       = "platform"
  network_id = module.network.id
  masters = {
    linux = {
      count       = 1
      subnet      = "192.168.1.0/24"
      image_name  = "ubuntu"
      flavor_name = "m1.small"
    }
  }
  workers = {
    linux = {
      count       = 2
      subnet      = "192.168.2.0/24"
      image_name  = "ubuntu"
      flavor_name = "m1.small"
    }
  }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT]()
