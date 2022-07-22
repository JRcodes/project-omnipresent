#! /bin/bash

# Simple installations to update a server
# Write commands to apply any changes that you require to run on your server
dependencies=( mysql-server ) # Pass in your dependencies into this array

for i in ${dependencies[@]}
do
    sudo apt install -y $i || exit
done

