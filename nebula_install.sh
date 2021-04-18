#!/bin/bash

# variable dependencies

declare -a Dependencies=("wget" "git")

# resolving dependenicies
function getreq {
dpkg-query --show  "$1"

if [ "$?" = "0" ];
then
    echo "$1" found
else
    echo "$1" not found. Installing.....
    sudo apt-get -y install "$1"
    if [ "$?" = "0" ];
    then echo "$1" installed successfully.
    fi
fi
}

for val in ${Dependencies[@]}; do
   getreq "$val"
done

# create enviroment

if [[ $1 == *.crt ]];
then
  host_crt=$1;
  echo $host_crt
fi
if [[ $1 == *.key ]];
then
  host_key=$1;
  echo $host_key
fi
if [[ $2 == *.key ]];
then
  host_key=$2;
  echo $host_key
fi
if [[ $2 == *.crt ]];
then
  host_crt=$2;
  echo $host_crt
fi

if [ ! -d /etc/nebula ]; then
    sudo mkdir /etc/nebula
fi
if [ ! -d /home/cluster/metis_resources ]; then
    mkdir /home/cluster/metis_resources
fi
if [ -d /home/cluster/metis_resources ]; then
    git clone https://github.com/ddominet/METIS-cluster /home/cluster/metis_resources
fi
if [ ! -f /etc/nebula/nebula ]; then
    sudo cp /home/cluster/metis_resources/nebula /etc/nebula/
fi
if [ ! -f /etc/nebula/config.yaml ]; then
    sudo cp /home/cluster/metis_resources/config.yaml /etc/nebula/
fi
if [ ! -f /etc/nebula/ca.crt ]; then
    sudo cp /home/cluster/metis_resources/ca.crt /etc/nebula/
fi
if [ ! -f /etc/nebula/host.crt ]; then
    sudo mv $host_crt /etc/nebula/host.crt
fi
if [ ! -f /etc/nebula/host.key ]; then
    sudo mv $host_key /etc/nebula/host.key
fi

# run as service

if [ ! -f /etc/nebula/nebula-start.sh ]; then
    sudo cp /home/cluster/metis_resources/nebula-start.sh /etc/nebula
    sudo chmod +x /etc/nebula/nebula-start.sh
fi
if [ ! -f /etc/systemd/system/nebula-start.service ]; then
    sudo cp /home/cluster/metis_resources/nebula-start.service /etc/systemd/system/
    sudo chmod 644 /etc/systemd/system/nebula-start.service
    sudo systemctl daemon-reload
    sudo systemctl enable nebula-start.service
    sudo systemctl start nebula-start.service
fi




