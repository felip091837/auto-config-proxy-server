#!/bin/bash

#felipesi - 2017
#tested on ubuntu 20.04 LTS aws

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

echo "UPDATING SYSTEM, WAIT..."
apt update -y &>/dev/null
apt upgrade -y &>/dev/null
echo -e "UPDATE SYSTEM - [OK]\n"

echo "INSTALLING SERVER PROXY SQUID..."
apt install squid -y &>/dev/null
echo -e "INSTALL SQUID - [OK]\n"

echo "INSTALLING CURL..."
apt install curl -y &>/dev/null
echo -e "INSTALL CURL - [OK]\n"

ip=$(curl -s icanhazip.com) &>/dev/null

echo "SETTING UP SQUID..."

cat <<EOT > /etc/squid/squid.conf
http_port 8080
acl net dstdomain
acl REQUEST method GET
acl REQUEST method POST
acl REQUEST method OPTIONS
acl REQUEST method HEAD
acl REQUEST method CONNECT
http_access allow net
http_access allow REQUEST
http_access deny all
acl liberado url_regex -i
EOT

echo -e "SETTING UP SQUID - [OK]\n"

echo "RESTARTING SERVICES..."
systemctl restart squid.service
echo -e "RESTART SERVICES - [OK]\n"

echo "YOUR PROXY SERVER IS READY - IP: $ip PORT: 8080"
