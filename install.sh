#!/bin/bash

port=10032 # HTTP代理端口

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

mitmdump -s ./fcm.py --ssl-insecure -p $port --no-http2 -q
EOF

chmod +x start.sh
echo "安装完成, 输入 ./start.sh 启动"
