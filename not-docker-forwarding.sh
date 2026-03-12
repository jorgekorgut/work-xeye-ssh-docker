#!/bin/bash

trap 'kill $(jobs -p)' EXIT

XAUTH=.docker.xauth
echo > $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
TCPPORT=`expr 6000 + $X11PORT`
socat TCP-LISTEN:$TCPPORT,fork,bind=172.17.0.1 TCP:127.0.0.1:$TCPPORT &

DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`

