# Changelog

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v2.3.0...v3.0.0) (2025-06-10)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* small refactor ([#30](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/30)) ([04104c3](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/04104c3fd026bd7f783f17489f6b05c57cc94689))
* Type definitions are added.
*  Several naming improvements

### Upgrade from v2.3.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- The property and variable resource_group is renamed to resource_group_name
## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v2.2.1...v2.3.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/19)) ([8072e6b](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/8072e6b73f9a22250c4c95a4efd1f7ef4d0b2aff))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#22](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/22)) ([3eba427](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/3eba427551e9d6e0545379d68a9c003c4917c745))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#23](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/23)) ([74c5176](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/74c51767b3856e468aceeb193d78b40d433cfd09))
* remove temporary files when deployment tests fails ([#20](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/20)) ([e09df92](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/e09df926727fb1850f052b7dc5e4ef18fd3f2816))

## [2.2.1](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v2.2.0...v2.2.1) (2024-12-16)


### Bug Fixes

* refactor rules and vnet links within fw rulesets, updated docs ([#16](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/16)) ([fc8fe15](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/fc8fe15afee515ce2e7ada0d39764c3737f3423e))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v2.1.0...v2.2.0) (2024-11-12)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#14](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/14)) ([9c9c3e5](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/9c9c3e5de12cdb0b5233b6ef5720693e1db99e4b))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#12](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/12)) ([5999069](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/5999069381845c6b914242dc9100e17248e8d25a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/11)) ([bd25e87](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/bd25e870c42075ae95a0256fa3318ebfd590b11a))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v1.1.0...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#9](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/9)) ([8d7f0c6](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/8d7f0c6f476767f4f88a3654d83c46a75f15e729))

### Upgrade from v1.1.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v1.0.1...v1.1.0) (2024-09-06)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#5](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/5)) ([71185be](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/71185be901e52f7f7462343c17a56f30f6499428))


### Bug Fixes

* made outbound endpoint fully optional and simplified tests ([#7](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/7)) ([4801879](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/4801879ecf3915da473975c05c33a715864f9fe8))

## [1.0.1](https://github.com/CloudNationHQ/terraform-azure-dnspr/compare/v1.0.0...v1.0.1) (2024-08-19)


### Bug Fixes

* fix some usage module references ([#3](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/3)) ([68accba](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/68accba585ff9e2dba65bcc1be069e32318dc9f2))

## 1.0.0 (2024-08-19)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-dnspr/issues/1)) ([054061a](https://github.com/CloudNationHQ/terraform-azure-dnspr/commit/054061a57eb0b873f2b3d9c6957a804cc1a3aa44))
