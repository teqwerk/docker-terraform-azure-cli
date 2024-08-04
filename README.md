[![Build docker images](https://github.com/teqwerk/docker-terraform-azure-cli/actions/workflows/docker-buildx.yaml/badge.svg)](https://github.com/teqwerk/docker-terraform-azure-cli/actions/workflows/docker-buildx.yaml)
[![Get latest release version](https://github.com/teqwerk/docker-terraform-azure-cli/actions/workflows/get-latest-versions.yaml/badge.svg)](https://github.com/teqwerk/docker-terraform-azure-cli/actions/workflows/get-latest-versions.yaml)

# Terraform and Azure CLI Docker Image

This repository provides a Docker image that includes both [Terraform](https://developer.hashicorp.com/terraform) and [Azure CLI](https://docs.microsoft.com/cli/azure/?view=azure-cli-latest), built on top of Alpine Linux. It is intended to be used as a CI/CD tool for managing Azure resources using Terraform but can be used locally as well.

## Available Images

Available images can be found in the [GitHub Container Registry](https://github.com/teqwerk/docker-terraform-azure-cli/pkgs/container/terraform-azure-cli).

## What's Inside

- **Azure CLI**: A command-line tool for managing Azure resources.
- **Terraform**: An infrastructure as code tool for building, changing, and versioning infrastructure safely and efficiently.
- **Supporting Packages**: Additional tools like `git` and `python3`.

## Getting Started

### Prerequisites

- Docker installed on your machine. You can download it from [here](https://docs.docker.com/get-docker/).

### Getting the Image

You can pull the pre-built image from the GitHub Container Registry:

```bash
docker pull ghcr.io/teqwerk/terraform-azure-cli:latest
```

**OR** you can build the image yourself:

```bash
git clone https://github.com/teqwerk/docker-terraform-azure-cli.git && cd docker-terraform-azure-cli
docker build --build-arg TERRAFORM_VERSION=1.9.3 --build-arg AZURE_CLI_VERSION=2.62.0 .
```

### Running the Container

You can run the container using the following command:

```bash
docker run -it --rm ghcr.io/teqwerk/terraform-azure-cli:latest
```

Once inside the container, you can use terraform and az commands as you would normally:

```bash
terraform --version
az --version
```

## Updating Versions

The versions of Terraform and Azure CLI are managed in the `versions.json` file. The GitHub Actions workflows automatically update these versions every `24 h` and rebuild the Docker image.

## Contributing

Nice you are thinking about contributing! Contributions are always welcome! Please feel free to open an issue or submit a pull request.
