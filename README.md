# Static Site Infrastructure

Ansible automation for deploying a static website on a Debian-based Linux server with Nginx. TLS certificates and Cloudflare.

## Prerequisites

- Ansible installed on the control machine.
- The Ansible collections declared in `collections/requirements.yml`, installed with:

  ```sh
  ansible-galaxy collection install --requirements-file collections/requirements.yml
  ```

- SSH access with sudo privileges to a Debian-based target server.
- TLS certificate and private key already available on the target server at `/etc/nginx/ssl/cert.pem` and `/etc/nginx/ssl/cert.key`.
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

Run the playbooks in this order. The first command uses the existing administrator credentials from `inventory.ini`; subsequent commands can use the newly created account after updating the inventory.

```sh
ansible-playbook playbooks/create-user.yaml
ansible-playbook playbooks/install-nginx.yaml
ansible-playbook playbooks/copy-page-files.yaml
ansible-playbook playbooks/setup-nginx.yaml
```

The last playbook installs the virtual-host configuration and reloads Nginx. Verify the deployment by opening `https://<server-address>`.
