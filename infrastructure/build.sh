#!/bin/bash -xe

IMAGE_PATH=$1

terraform init
terraform apply -auto-approve -var "image=$IMAGE_PATH"
