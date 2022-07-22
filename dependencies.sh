#! /bin/bash

# Simple installations to bootstrap host
# Write commands to install pre-required dependencies here
dependencies=( sshpass ) # Pass in your dependencies into this array

for i in ${dependencies[@]}
do
    sudo apt install $i 
done
