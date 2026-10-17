#! /bin/bash

# Simple installations to bootstrap host
# Write commands to install pre-required dependencies here
dependencies=( openssh-client curl ) # Pass in your dependencies into this array

sudo apt-get update || exit
for i in "${dependencies[@]}"
do
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$i" || exit
done
