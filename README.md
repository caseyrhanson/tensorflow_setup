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
sudo apt-get update
```

*** Optional: Check apt-policy***
The `apt-cache policy` comamnd displays the priorities of package sources as well as those of individual packages
```bash
apt-cache policy docker-ce
```

### 1.4 Install and Verify Docker Community Edition (CE)

We can now install docker ce:

```bash
sudo apt-get install -y docker-ce
```

Verify the version:

```bash
docker --version
```

The output:
```bash
Docker version 18.03.1-ce, build 9ee9f40
```
### 1.5 Summary 

The following can be run in one swoop:

```sh
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
docker --version
```

# 2.0 Build Images
## 2.1 Cloud9

Build an image from docker file
```
C9NAME="caseyrhanson/opal_c9:1.0"
cd docker/c9
docker build -t $C9NAME ./
docker login
docker push $C9NAME
```

The following script will run cloud9 instances users `crhanso2` and `blatti` on 8081 and 8082
```bash

## Basic Cloud9 parameters for users. **Note that UPORT will be incremented**.
C9NAME="caseyrhanson/opal_c9:1.0"
C9PASS="tmppass"
USERS="crhanso2 blatti"
LOCAL_USER="tfuser"
UPORT=8081
DOCKER_VERBOSE="yes"

## Docker ARGS common to all users
DOCKER_ARGS="  --restart=always --privileged";
DOCKER_ARGS+=" -v /var/run/docker.sock:/var/run/docker.sock";
DOCKER_ARGS+=" -v $(which docker):$(which docker)";
DOCKER_ARGS+=" -v /home/$LOCAL_USER:/workspace/$LOCAL_USER";

## Iterate over all users - in this case crhanso2 and blatti
for USER in $USERS; do
  ## Set up USER arguments
  USER_ARGS="  --name c9-$USER -h c9-$USER -p $UPORT:8181 -v /home/$USER:/workspace $C9NAME";
  USER_ARGS+=" --auth $USER:$C9PASS --collab -a $USER:$C9PASS";
  
  ## Run verbose 
  if [ ! -z "$DOCKER_VERBOSE" ]]; then
    echo "Running docker run command for $USER on $UPORT:";
    echo "  docker run -d $USER_ARGS $DOCKER_ARGS
  fi
  
  ## Run command
  docker run -d $USER_ARGS $DOCKER_ARGS
  
  ## Increment UPORT
  UPORT=`echo $UPORT | awk '{s=$1+1; print s}'`;
 done
 
 ```
