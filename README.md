# Installing Docker on Ubuntu 10.04

## 1.0 Download Docker

Following the example here: https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver

Note: There is no release for Bioinic so we will use 17.10 installation

### 1.1 Get Certificates

```bash
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
### 1.2 Add to apt-repo

Add to apt-repo either stable, edge, or nightly.


Add the artful stable build:
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable"
```

Do not do this:
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

If you do, you can remove it with '-r'
```
sudo add-apt-repository -r "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
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
### 1.4 Install Docker Community Edition (CE)

We can now install docker ce:

```bash
sudo apt install docker-ce
```



