#!/bin/bash

set -euo pipefail

if ! command -v ansible &> /dev/null || ! command -v terraform &> /dev/null; then
    echo "Error: Ansible or Terraform is not installed"
    exit 1
fi

if [[ $# -ne 1 ]] || [[ "$1" != "add-domain" && "$1" != "deploy" ]]; then
    echo "Usage: $0 {add-domain|deploy}"
    echo "  add-domain  Create the Cloudflare zone and display its authoritative name servers."
    echo "  deploy      Configure DNS, Origin CA TLS, Nginx, and the static site after the zone is active."
    exit 1
fi

read -r -p "Insert domain name: " domain
if [[ -z "$domain" ]]; then
    echo "Wrong domain name"
    exit 1
fi
export TF_VAR_DOMAIN_NAME="$domain"

terraform -chdir=cloudflare init

if [[ "$1" == "add-domain" ]]; then
    terraform -chdir=cloudflare apply -target=cloudflare_zone.domain
    echo
    echo "Configure the following name servers at the domain registrar:"
    terraform -chdir=cloudflare output cloudflare_name_servers
    echo
    echo "Wait until the domain is active in Cloudflare, then run: $0 deploy"
    exit 0
fi

read -r -p "Confirm that $domain is active in Cloudflare and the server configuration is valid (Y/N): " input
if [[ "$input" == "Y" ]]; then
    ansible-playbook playbooks/install-nginx.yaml
    ansible-playbook playbooks/copy-page-files.yaml
    terraform -chdir=cloudflare apply

    export TLS_CERTIFICATE_PEM="$(terraform -chdir=cloudflare output -raw origin_certificate_pem)"
    export TLS_PRIVATE_KEY_PEM="$(terraform -chdir=cloudflare output -raw origin_private_key_pem)"

    ansible-playbook playbooks/copy-tls-materials.yaml
    ansible-playbook playbooks/setup-nginx.yaml
    ansible-playbook playbooks/create-user.yaml
    ansible-playbook playbooks/disable-root-password-access.yaml
else
    echo "Deployment cancelled"
fi
