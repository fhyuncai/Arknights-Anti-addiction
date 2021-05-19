#!/bin/bash

echo "请在安装前切换为含有管理员权限的用户, 或使用 'sudo' 执行此脚本"
if [ ! $sysPack ]; then
    read -p "请输入系统包管理器 (apt/yum): " sysPack
fi
if [ "$sysPack" == "apt" ]; then
    apt-get install -y mitmproxy
elif [ "$sysPack" == "yum" ]; then
    yum install -y mitmproxy
else
    echo "输入的包管理器错误"
    exit 1
fi

cat > start.sh << EOF
#!/bin/sh

proxy_port=10032
proxy_ip=\$(ip addr | grep inet | grep -v inet6 | grep -v '127.0.0.1' | grep -v docker | awk '{print \$2}' | awk -F "/" '{print \$1}')
[ ! \$proxy_ip ] && proxy_ip=此设备局域网IP
echo 主机名：\$proxy_ip
echo 端口：\$proxy_port
mitmdump -s ./fcm.py --ssl-insecure -p \$proxy_port --no-http2 -q
EOF

chmod +x start.sh
echo "安装完成, 输入 ./start.sh 启动"
