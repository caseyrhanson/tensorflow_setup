#!/bin/bash

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
