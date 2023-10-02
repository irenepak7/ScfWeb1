#!/bin/bash

service firewalld start
firewall-cmd --zone=public --add-port=1935/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports | grep 1935
sleep 10
service nginx resatrt
