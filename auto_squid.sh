#!/bin/bash

#felipesi - 2017

echo "UPDATING SYSTEM, WAIT..."
apt-get update -y > /dev/null
apt-get upgrade -y > /dev/null
echo -e "UPDATE SYSTEM - [OK]\n"

echo "INSTALLING SERVER PROXY SQUID..."
apt-get install squid3 -y > /dev/null
echo -e "INSTALL SQUID - [OK]\n"

echo "INSTALLING CURL..."
apt-get install curl -y > /dev/null
echo -e "INSTALL CURL - [OK]\n"

cd /etc/squid3

ip=$(curl -s icanhazip.com) > /dev/null

echo "SETTING UP SQUID..."

echo "http_port 8080" > squid.conf
echo "acl net dstdomain $ip" >> squid.conf
echo "acl REQUEST method GET" >> squid.conf
echo "acl REQUEST method POST" >> squid.conf
echo "acl REQUEST method OPTIONS" >> squid.conf
echo "acl REQUEST method HEAD" >> squid.conf
echo "acl REQUEST method CONNECT" >> squid.conf
echo "http_access allow net" >> squid.conf
echo "http_access allow REQUEST" >> squid.conf
echo "http_access deny all" >> squid.conf
echo "acl liberado url_regex -i" >> squid.conf

echo -e "SETTING UP SQUID - [OK]\n"

echo "RESTARTING SERVICES..."
service squid3 restart
echo -e "RESTART SERVICES - [OK]\n"

echo "YOUR PROXY SERVER IS READY - IP: $ip PORT: 8080"
