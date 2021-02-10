#!/bin/bash

sudo yum update -y
sudo yum install nginx -y
echo 'Hi isto é um teste' > /var/www/html/index.html
service nginx start