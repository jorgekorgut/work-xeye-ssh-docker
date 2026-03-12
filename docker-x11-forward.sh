#!/bin/bash

# Ref : https://stackoverflow.com/questions/48235040/run-x-application-in-a-docker-container-reliably-on-a-server-connected-via-ssh-w

# IMPORTANT, set the following variables and restart the ssh server `sudo systectl restart ssh.service``
# /etc/ssh/sshd_config
# X11Forwarding yes
# X11UseLocalHost no

# Host IP as seen from containers on the default Docker bridge network
DOCKER_HOST_IP=$(docker network inspect bridge --format '{{(index .IPAM.Config 0).Gateway}}')
SUBNET_CIDR=$(docker network inspect bridge --format '{{(index .IPAM.Config 0).Subnet}}')

# Add authorization to container for communication through XServer
export XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
sudo chmod 777 $XAUTH # Todo: The permissions could be reduced

# Open firewall TCP Port for allowing docker access. (Communication is done with TCP)
X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
TCPPORT=`expr 6000 + $X11PORT`
sudo ufw allow from "$SUBNET_CIDR" to any port "$TCPPORT" proto tcp

# Set the display address inside the container. (if we use a different network_mode than host, localhost does not point to the host machine)
DISPLAY=$(echo "$DISPLAY" | sed "s/^[^:]*\(.*\)/$DOCKER_HOST_IP\1/")

docker compose up -d
