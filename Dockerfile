FROM ubuntu:latest

RUN apt-get update && apt-get install -y x11-apps

CMD ["/bin/bash", "-c", "while true; do sleep 3600; done"]