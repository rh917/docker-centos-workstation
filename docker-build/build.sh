#!/bin/bash

# grab global variables
IMAGE_NAME=rhambacher/centos-workstation
DOCKER=$(which docker)

BASE="$( cd "../" && pwd )"
cd "$BASE"

# build image
$DOCKER build --pull --tag ${IMAGE_NAME} .