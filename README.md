# Terraform Null RKE module

**RKE** is a Terraform module defining the required resources for creating a `rke2`, `k3s` cluster using remote shell connection

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/null"

  name        = "platform"
  description = "Platform Network"
  external    = "external"
  subnets     = ["192.168.1.0/24", "192.168.2.0/24"]
  tenant_id   = data.openstack_identity_project_v3.this.id
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT]()

---
