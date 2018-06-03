#!/bin/sh

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
  if [[ ! -z "$DOCKER_VERBOSE" ]]; then
    echo "Running docker run command for $USER on $UPORT:";
    echo "  docker run -d $USER_ARGS $DOCKER_ARGS
  fi
  
  ## Run command
  docker run -d $USER_ARGS $DOCKER_ARGS
  
  ## Increment UPORT
  UPORT=`echo $UPORT | awk '{s=$1+1; print s}'`;
 done
