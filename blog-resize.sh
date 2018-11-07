#!/bin/bash

cd terraform/wordpress/
/sbin/terraform init
/sbin/terraform plan
/sbin/terraform apply

/bin/sh  deploy.sh
