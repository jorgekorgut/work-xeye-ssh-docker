FROM ubuntu:latest

RUN apt-get update && apt-get install -y x11-apps iputils-ping iproute2

RUN apt-get install -y x11-xserver-utils xauth

CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]