#!/bin/bash -x


sudo apt update -y
sudo apt upgrade -y
#sudo yum install epel-release -y

sudo apt install nginx -y
sudo apt install ansible

#sudo service nginx restart
