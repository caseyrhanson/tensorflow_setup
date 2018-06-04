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

*Optional: Check apt-policy*
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

The `workspace/shared` directory will hold the shared space. This will be mounted as `/workspace/shared` for each cloud9 user.

```
sudo mkdir -p /workspace/shared
```

## 2.3 Run Cloud9
The following script will run cloud9 instances users `crhanso2` and `blatti` on 8081 and 8082
```bash
## Basic Cloud9 parameters for users. **Note that UPORT will be incremented**.
IMAGE="caseyrhanson/opal_c9:1.0"
C9PASS="tmppass"
USERS="crhanso2 blatti"
UPORT=8081
DOCKER_VERBOSE="yes"

## Docker ARGS common to all users
OPTIONS="-d --restart=always --privileged";
VOLUMES="-v /var/run/docker.sock:/var/run/docker.sock";
VOLUMES+=" -v $(which docker):$(which docker)";
VOLUMES+=" -v /home/:/workspace/home/";
VOLUMES+=" -v /mnt/:/workspace/mnt/";

## Iterate over all users - in this case crhanso2 and blatti
for USER in $USERS; do
  ## Set up USER arguments
  USER_VOLUMES=" -v /home/$USER/:/workspace/ $VOLUMES";
  USER_OPTIONS="$OPTIONS --name c9-$USER -h c9-$USER -p $UPORT:8181 $USER_VOLUMES";
	COMMAND="--auth $USER:$C9PASS";
  
  ## Run verbose  output
  if [[ ! -z "$DOCKER_VERBOSE" ]]; then
    echo "docker run $USER_OPTIONS $IMAGE $COMMAND";
  fi
  
  ## Run command
  docker run $USER_OPTIONS $IMAGE $COMMAND;
  
  ## Increment UPORT for next user
  UPORT=`echo $UPORT | awk '{s=$1+1; print s}'`;
 done
```

## 2.3 Link Directories
From within cloud9 terminal (*Note: 3rd command is currently commented. When you have a drive to mount, put it there*):

```
ln -s /workspace/home/tfuser/ /home/
mkdir -p /mnt/
#ln -s /workspace/mnt/$MOUNT_DIR/ /mnt
mkdir ~/.ssh/
ln -s /workspace/home/tfuser/creds/ssh_config ~/.ssh/config
```

Now, what is this doing?
For simplicity, I will append c9 to any path on the cloud9 instance and ubuntu for the machine hosting the cloud9 instance.
*Note:* You may want to put `~/.c9/user.settings` in a permanent path like `c9:/workspace/home/USER/home/.9/user.settings`.
The same goes for `~/.bashrc ~/.profile ~/.vimrc`, as these will be wiped after each restart of the service.

### 2.3.1 Mapping shared user space
The first line of code will soft link `c9:/home -> c9:/workspace/home/tfuser`.
However, remember from our VOLUME map `c9:/workspace/home == ubuntu:/home`.

Thus, this first line is equivalent to the following:
```
ln -s ubuntu:/home/tfuser c9:/home/
```

The consequence is `c9:/home -> ubuntu:/home/tfuser`.


## 2.3.2 Mounting a mount
This will create a directory `c9:/mnt` and mount `c9:/mnt -> ubuntu:/home/mnt/$MOUNT_DIR`.

## 2.3.3 Copying .ssh
The `tfuser` .ssh config has a lot of valuable info we want replicate so we copy it into c9:~/.ssh


