# CentOS Workstation in Docker

This repository contains the dockerfile and build script for running a CentOS (latest) workstation as a docker container.

## Usage

Execute with the following substituting your own name, ports, and timezone:
```
docker run -d \
  --name=centos \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ='America/Chicago' \
  -p 2223:22 \
  --restart unless-stopped \
  rhambacher/centos-workstation
```

Ports: <HOST>:<CONTAINER>

Default Login
	Username: root
	Password:  password

Enter container's shell to change:
```
docker exec -ti centos bash


[root@container /]# passwd
Changing password for user root.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@container /]# 
```
