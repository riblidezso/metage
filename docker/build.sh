#!/bin/bash
set -e

docker="nvidia-docker"
sudo $docker build -t metage .
sudo $docker run -ti \
	-p 9042:8888 \
	-h localhost \
	-v /home/ribli/metage:/root/metage \
	metage
