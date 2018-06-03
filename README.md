# Installing Docker on Ubuntu 10.04

## 1.0 Get Certificates
Following the example here: https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver

```
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

Create a new file for the Docker repository at /etc/apt/sources.list.d/docker.list. In that file, place one of the following lines choosing either stable, nightly or edge builds:

`=STABLE (NOT YET AVAILABLE!), please check availabilty before using:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
EDGE:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge
NIGHTLY:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic nightly
`
