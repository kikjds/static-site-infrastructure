# Static Site Infrastructure

Terraform and Ansible automation for deploying a static website on a Debian-based Linux server with Nginx, including Cloudflare Origin CA TLS certificates.

## Prerequisites

- Ansible installed on the control machine.
- Terraform installed on the control machine.
- The Ansible collections declared in `collections/requirements.yml`, installed with:

  ```sh
  ansible-galaxy collection install --requirements-file collections/requirements.yml
  ```

- SSH access with sudo privileges to a Debian-based target server.
- Cloudflare credentials and the target server IP address exported as Terraform input variables (for example, `TF_VAR_CLOUDFLARE_API_TOKEN`, `TF_VAR_CLOUDFLARE_ACCOUNT_ID`, and `TF_VAR_IPV4_SERVER_ADDRESS`).
- Port `443` open in the server firewall and, when applicable, in the cloud provider firewall.

## Setup

Create a local inventory from the example and fill in the target host connection details:

```sh
cp inventory.ini.example inventory.ini
```

Set the account name and path to the public SSH key in `group_vars/all.yaml`:

```yaml
username: Admin
ssh_key_path: /home/user/.ssh/id_ed25519.pub
```

Update the static site files in `page/`. Adjust `configs/page.conf` when the document root or TLS certificate paths differ from the defaults.

## Deployment

Make the deployment script executable and run it:

```sh
chmod +x deploy.sh
./deploy.sh
```

Verify the deployment by opening `https://<domain-name>`.
