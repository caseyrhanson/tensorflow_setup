# Installing Docker on Ubuntu 10.04

## 1.0 Download Docker

Following the example here: https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver

### 1.1 Get Certificates

```bash
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
### 1.2 Bionic stable, edge, nightly builds to sources.list

Create a new file for the Docker repository at `/etc/apt/sources.list.d/docker.list`. In that file, place one of the following lines choosing either stable, nightly or edge builds:

```
STABLE (NOT YET AVAILABLE!), please check availabilty before using:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
EDGE:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge
NIGHTLY:
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic nightly
```

For example, to add the Bionic Stable build:
```
sudo echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> /etc/apt/sources.list.d/docker.list
```

### 1.3 Add GPG Key
You now need the GNU Privacy Guard (GPG) key. Download and add it as follows:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

The return value should be
```
OK
```

Once you have the key, re-update Apt:
```bash
sudo apt update
```
