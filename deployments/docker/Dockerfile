
## Building the docker container based on python2
FROM python:2

MAINTAINER  First Last 

## Copy from localhost to docker contianer all files 
ADD . /server

# Running the server
CMD [ "/usr/local/bin/python", "/server/server.py"]
