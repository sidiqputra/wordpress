#!/bin/bash

if [ -z $1 ];then
echo 'ERROR : example : ./blog-resize.sh <instance number>'
exit 1
fi

cd terraform/wordpress/
/sbin/terraform init
/sbin/terraform plan
/sbin/terraform apply

/bin/sh  deploy.sh
