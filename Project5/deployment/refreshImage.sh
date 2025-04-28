#!/bin/bash

sudo docker kill horror
sudo docker pull mjzimmer121999/zimmer-ceg3120
sudo docker run -d -p 80:4200 --name horror --restart=always mjzimmer121999/zimmer-ceg3120:latest
