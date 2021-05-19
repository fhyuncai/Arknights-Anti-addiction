#!/bin/sh

proxy_port=10032
proxy_ip=$(ip addr | grep inet | grep -v inet6 | grep -v '127.0.0.1' | grep -v docker | awk '{print $2}' | awk -F "/" '{print $1}')
echo 主机名：$local_ip
echo 端口：$proxy_port
./mitmdump -s ./fcm.py --ssl-insecure -p $proxy_port --no-http2 -q
