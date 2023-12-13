# [1.17.0](https://github.com/cktf/terraform-module-rke/compare/1.16.0...1.17.0) (2023-12-13)


### Features

* upgrade script modules ([3e0477a](https://github.com/cktf/terraform-module-rke/commit/3e0477a289fc3050d5904810bd33fca9e16dcae5))

# [1.16.0](https://github.com/cktf/terraform-module-rke/compare/1.15.0...1.16.0) (2023-12-11)


### Features

* add agent token output ([251e245](https://github.com/cktf/terraform-module-rke/commit/251e245437cfdcc02991a899b65a21776d21d67d))

# [1.15.0](https://github.com/cktf/terraform-module-rke/compare/1.14.3...1.15.0) (2023-12-11)


### Bug Fixes

* base64decode certs and key ([120292b](https://github.com/cktf/terraform-module-rke/commit/120292b793c4201cf9128568d709759a698a28ad))
* change .terraform.lock.hcl ([46d7fe8](https://github.com/cktf/terraform-module-rke/commit/46d7fe8e6e0e60e203b48534e4d8ef7039ddae66))
* change install script add export ([40c6c82](https://github.com/cktf/terraform-module-rke/commit/40c6c82914d1949b827e0550109f42cf8ac7f1e3))
* change random_string to random_password ([53f29cb](https://github.com/cktf/terraform-module-rke/commit/53f29cbfb7a122620e1465d47aaff90371bb736a))


### Features

* add new cluster installer ([25e912a](https://github.com/cktf/terraform-module-rke/commit/25e912a5c55edc306b6b9b5b6584d87cc2e28759))

## [1.14.3](https://github.com/cktf/terraform-module-rke/compare/1.14.2...1.14.3) (2022-12-15)


### Bug Fixes

* run post create script before starting service ([74ad6bb](https://github.com/cktf/terraform-module-rke/commit/74ad6bbb6b3a36e4f9a34bf854d28b8db9378b3f))

## [1.14.2](https://github.com/cktf/terraform-module-rke/compare/1.14.1...1.14.2) (2022-11-10)


### Bug Fixes

* change version constraints ([3eb7927](https://github.com/cktf/terraform-module-rke/commit/3eb7927c34425ff93b3b3c1257d7ac24e43e2979))

## [1.14.1](https://github.com/cktf/terraform-module-rke/compare/1.14.0...1.14.1) (2022-09-04)


### Bug Fixes

* disable local-storage by default ([5664801](https://github.com/cktf/terraform-module-rke/commit/566480120836267edb8d9bcbdac25e6da1a84847))

# [1.14.0](https://github.com/cktf/terraform-module-rke/compare/1.13.0...1.14.0) (2022-09-03)


### Features

* add linux support to terraform lock file ([9657ad5](https://github.com/cktf/terraform-module-rke/commit/9657ad5f910d2c661f6338585be7e3652095285a))

# [1.13.0](https://github.com/cktf/terraform-module-rke/compare/1.12.4...1.13.0) (2022-08-25)


### Features

* enable metrics-server by default ([3f15459](https://github.com/cktf/terraform-module-rke/commit/3f15459267821ed2e0b20041d5389ed0c0bb2cac))

## [1.12.4](https://github.com/cktf/terraform-module-rke/compare/1.12.3...1.12.4) (2022-08-25)


### Bug Fixes

* default value for private_alb, public_alb on empty ([f79d701](https://github.com/cktf/terraform-module-rke/commit/f79d701054ba00ba6f58f80a5a642d7842e101b1))

## [1.12.3](https://github.com/cktf/terraform-module-rke/compare/1.12.2...1.12.3) (2022-08-03)


### Bug Fixes

* change template file names ([435e044](https://github.com/cktf/terraform-module-rke/commit/435e044ec7186169a759ec559f0d5f8bf9764e39))

## [1.12.2](https://github.com/cktf/terraform-module-rke/compare/1.12.1...1.12.2) (2022-08-02)


### Bug Fixes

* add extra_args, extra_envs to agent nodes ([f7389fe](https://github.com/cktf/terraform-module-rke/commit/f7389fe22e5efc706422e8b3c12ddc2d079e2a73))

## [1.12.1](https://github.com/cktf/terraform-module-rke/compare/1.12.0...1.12.1) (2022-08-02)


### Bug Fixes

* add pre, post destroy scripts ([b474fe0](https://github.com/cktf/terraform-module-rke/commit/b474fe078c26439786d77b9e199f82f99cbc2262))

# [1.12.0](https://github.com/cktf/terraform-module-rke/compare/1.11.1...1.12.0) (2022-08-02)


### Bug Fixes

* add terraform lock file ([31e45f9](https://github.com/cktf/terraform-module-rke/commit/31e45f99f933f1ca9875f26b75919714c434a9ab))
* remove unused name variable ([00cf8ce](https://github.com/cktf/terraform-module-rke/commit/00cf8ce3df12337d4ed2898cc85dcba689bc1606))


### Features

* refactor submodules and merge into root module ([3e39287](https://github.com/cktf/terraform-module-rke/commit/3e39287eb5bcc89bfea5b226cd1ac1885471c1c3))

## [1.11.1](https://github.com/cktf/terraform-module-rke/compare/1.11.0...1.11.1) (2022-07-28)


### Bug Fixes

* force all endings to LF ([e04269a](https://github.com/cktf/terraform-module-rke/commit/e04269afe25cb5d52426736492275d656b44d247))

# [1.11.0](https://github.com/cktf/terraform-module-rke/compare/1.10.2...1.11.0) (2022-06-13)


### Features

* replace standard-version with semantic-release ([56b1f99](https://github.com/cktf/terraform-module-rke/commit/56b1f99de6e92f9dff48402fafa0701db7581855))
