# How to setup ssh to forward a display that is launched inside a docker

docker <- sshed machine  <- local machine

inside ```/etc/ssh/sshd_config```

Set the following variables
```
X11Forwarding yes
X11UseLocalHost no
``` 
*Important* : After changing this file you need to ```sudo systectl restart ssh.service``` and reconnect to the sshed machine


Execute the script ```docker-x11-forward.sh``` without root in the machine that connects via ssh (local machine)

