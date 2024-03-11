## Motivation

just working through some atlas terraform examples

https://github.com/ariga/terraform-provider-atlas/tree/master/examples/provider

## Getting started

```shell
pkgx install terraform
pkgx install atlasgo.io
```

## Running the module

seeing if we get things working with postgres …

`terraform init` works fine. `terraform plan` and `terraform apply` fail.

```
╷
│ Error: Atlas Plan Error
│
│   with atlas_schema.this,
│   on main.tf line 57, in resource "atlas_schema" "this":
│   57: resource "atlas_schema" "this" {
│
│ Unable to generate migration plan, got error: Error: postgres: scanning system variables: dial tcp 127.0.0.1:5433: connect:
│ connection refused
```
