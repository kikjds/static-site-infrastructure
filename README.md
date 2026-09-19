# Static Site Infrastructure

Automation for deploying static websites on Linux servers using Nginx, SSL and Cloudflare.

## Setup

Create a local inventory from the example and fill in the target host connection details:

```sh
cp inventory.ini.example inventory.ini
```

Create the encrypted file containing the administrator password:

```sh
ansible-vault create vars/secrets.yaml
```

Add the password in the editor that opens:

```yaml
password: "your-password"
```
