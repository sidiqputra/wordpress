#!/bin/bash

instaceip=`cat hosts/inventory | grep ansible_host | awk '{print$2}' | cut -d"=" -f2`

echo 'Setting up the engineering blog...'

cd terraform/wordpress/
/sbin/terraform init
/sbin/terraform plan
/sbin/terraform apply

/bin/sh  deploy.sh

echo "Done! The blog can be accessed at http://$instaceip/"
