# DevOps Project - Hexlet

This repository contains the infrastructure configuration for a typical web application set up in Yandex Cloud using Terraform and Ansible.

## Prerequisites

1. Set up access keys for Terraform by providing the standard S3 credentials as environment variables if you are working with remote backend:
   ```bash
   export AWS_ACCESS_KEY_ID="your_yandex_access_key"
   export AWS_SECRET_ACCESS_KEY="your_yandex_secret_key"
   ```
2. Have `terraform` and WSL (with `ansible-vault` available) installed.

## Setup Instructions

### 1. Initialize and Deploy Infrastructure

Use the provided `Makefile` aliases:
`make init` - Initializes terraform required providers and S3 backend.
`make plan` - Reviews the required infrastructure.
`make apply` - Deploys the infrastructure components.

### 2. DNS Record configuration

After successfully running `make apply`, Terraform will emit outputs including:
- `certificate_dns_challenge_name`
- `certificate_dns_challenge_value`

**You must** enter these CNAME values into your Domain's DNS settings (for `danya-hexlet-devops.ru`) so the Application Load Balancer gets the Let's Encrypt HTTPS Certificate successfully issued.

### 3. Application Deployment via Ansible
Terraform generates the DB password and an SSH Key pair (`.ssh/id_rsa`). The private key is saved locally into the `ansible` folder to facilitate configuring the VMs over SSH in future steps.

To manually encrypt/decrypt the secrets:
`make vault-encrypt`
`make vault-decrypt`