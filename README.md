# docker-proxmox-ansible

[![Build](https://github.com/nfaction/docker-proxmox7-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/nfaction/docker-proxmox7-ansible/actions/workflows/build.yml)

## Build image manually

Build a container and push it to Docker Hub:

```shell
docker login
docker build -f Dockerfile-PVE7 -t spikebyte/docker-proxmox7-ansible:latest .
docker push spikebyte/docker-proxmox7-ansible:latest

docker build -f Dockerfile-PVE8 -t spikebyte/docker-proxmox8-ansible:latest .
docker push spikebyte/docker-proxmox8-ansible:latest

docker build -f Dockerfile-PVE9 -t spikebyte/docker-proxmox9-ansible:latest .
docker push spikebyte/docker-proxmox9-ansible:latest
```

Test container:

```shell
docker run -it --rm -v $(pwd):/opt/ spikebyte/docker-proxmox7-ansible:latest bash

docker run -it --rm -v $(pwd):/opt/ spikebyte/docker-proxmox8-ansible:latest bash

docker run -it --rm -v $(pwd):/opt/ spikebyte/docker-proxmox9-ansible:latest bash
```

## References

* https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_Buster
* https://pve.proxmox.com/pve-docs/chapter-sysadmin.html#sysadmin_package_repositories
* https://pve.proxmox.com/pve-docs/chapter-pve-installation.html
* https://github.com/geerlingguy/docker-debian12-ansible/blob/master/Dockerfile
* https://github.com/geerlingguy/ansible-role-php/blob/51684c4c27a76efa134922cdadae2e6f76bb589b/molecule/default/molecule.yml

## Proxmox VE Enterprise

```
cat > /etc/apt/sources.list<< EOF
deb http://ftp.debian.org/debian bullseye main contrib
deb http://ftp.debian.org/debian bullseye-updates main contrib

# security updates
deb http://security.debian.org/debian-security bullseye-security main contrib
EOF

cat > /etc/apt/sources.list.d/pve-enterprise.list<< EOF
deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
EOF

# wget http://download.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
```
