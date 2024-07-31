# Terraform and Azure CLI Docker image

Available images can be found in the [GitHub Container Registry](https://github.com/teqwerk/docker-terraform-azure-cli/pkgs/container/terraform-azure-cli)

## This is inside

_build on top of alpine_

- [Azure CLI](https://docs.microsoft.com/cli/azure/?view=azure-cli-latest)
- [Terraform](https://developer.hashicorp.com/terraform)
- _some more supporting packages like `git` or `python3`_

## Build the image

```bash
docker build --build-arg TERRAFORM_VERSION=1.9.2 --build-arg AZURE_CLI_VERSION=2.62.0 .
```