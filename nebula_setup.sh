#!/bin/sh

# variable dependencies

declare -a Dependencies=("wget" "git")

# resolving dependenicies
function getreq {
dpkg-query --show  "$1"
if [ "$?" = "0" ];
then
    echo "$1" found
else
    echo "$1" not found. Please approve installation.
    sudo apt-get install "$1"
    if [ "$?" = "0" ];
    then echo "$1" installed successfully.
    fi
fi
}

for val in ${Dependencies[@]}; do
   getreq "$val"
done
