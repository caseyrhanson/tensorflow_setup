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
## 2.1 Build Cloud9

Build an image from docker file
```
IMAGE="caseyrhanson/opal_c9:1.0"
cd docker/c9
docker build -t $IMAGE ./
docker login
docker push $IMAGEE
```

## 2.2 Prepping `workspace`
The `workspace` directory will hold each individual c9 home directory.

For example, for `crhanso2`, his directory will be located at `/workspace/crhanso2` on the machine, but will be mounted '/workspace' within his cloud9. 

The `workspace/tfuser` directory will hold the shared space. This will be mounted as `/workspace/home` for each cloud9 user.

To ensure that the user `tfuser` loads into this space, create a  `/workspace/tfuser` and softlink `/home/tfuser` -> `/workspace/tfuser`.

This way, `tfuser` will ssh into the shared space.

```
sudo mkdir -p /workspace/tfuser
sudo ln -s /workspace/tfuser /home
```

## 2.3 Run Cloud9
The following script will run cloud9 instances users `crhanso2` and `blatti` on 8081 and 8082
```bash
## Basic Cloud9 parameters for users. **Note that UPORT will be incremented**.
IMAGE="caseyrhanson/opal_c9:1.0"
C9PASS="t"
USERS="crhanso2 blatti"
UPORT=8081
DOCKER_VERBOSE="yes"

## Docker ARGS common to all users
OPTIONS="-d --restart=always --privileged";
VOLUMES="-v /var/run/docker.sock:/var/run/docker.sock";
VOLUMES+=" -v $(which docker):$(which docker)";
VOLUMES+=" -v /workspace/shared:/workspace/shared";

## Iterate over all users - in this case crhanso2 and blatti
for USER in $USERS; do
  ## Set up USER arguments
  USER_VOLUMES=" -v /workspace/$USER:/workspace $VOLUMES";
  USER_OPTIONS="$OPTIONS --name c9-$USER -h c9-$USER -p $UPORT:8181 $USER_VOLUMES";
	COMMAND="--auth $USER:$C9PASS";
  
  ## Run verbose 
  if [[ ! -z "$DOCKER_VERBOSE" ]]; then
    echo "docker run $USER_OPTIONS $IMAGE $COMMAND";
  fi
  
  ## Run command
  docker run $USER_OPTIONS $IMAGE $COMMAND;
  
  ## Increment UPORT
  UPORT=`echo $UPORT | awk '{s=$1+1; print s}'`;
 done
 ```

## 2.3 Link Directories
ln -s /workspace/home/tfuser/ /home/
