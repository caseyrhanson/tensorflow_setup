# Installing Docker on Ubuntu 10.04

## 1.0 Get Certificates
Following the example here: https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver

```
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

Create a new file for the Docker repository at /etc/apt/sources.list.d/docker.list. In that file, place one of the following lines choosing either stable, nightly or edge builds:

### Bionic stable, edge, nightly builds
Please check availabilty before using:
deb [arch=amd64]

1. STABLE (NOT YET AVAILABLE!): https://download.docker.com/linux/ubuntu 
2. EDGE: https://download.docker.com/linux/ubuntu 
3. NIGHTLY:https://download.docker.com/linux/ubuntu
````
