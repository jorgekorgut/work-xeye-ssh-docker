#!/bin/bash

export XSOCK=/tmp/.X11-unix
export XAUTH=/tmp/.docker.xauth

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
sudo chmod 777 $XAUTH
X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
TCPPORT=`expr 6000 + $X11PORT`
sudo ufw allow from 172.20.0.0/16 to any port $TCPPORT proto tcp 
export DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.20.0.1\1/'`

docker compose up -d
