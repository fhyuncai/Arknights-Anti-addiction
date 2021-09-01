# Arknights-Anti-addiction (明日方舟防沉迷屏蔽)

基于 mitmproxy 实现，使用 python 编写

原代码: [Arknights_Anti-addiction_Cheater](https://github.com/Tao0Lu/Arknights_Anti-addiction_Cheater)

在原代码基础优化并支持手机启用服务

本项目仅供学习使用，使用本项目所造成的任何后果均与开发者无关

## 效果

- 不受防沉迷时间和时段限制

## 要求

- 若为 Android 7+ 需要 Root

## 食用方法

### 服务端搭建

#### Android

1. 安装 Termux
2. 输入 `curl https://raw.githubusercontents.com/fhyuncai/Arknights-Anti-addiction/main/install_termux.sh | bash` 根据提示安装和使用

#### Windows

1. [点击这里](https://github.com/fhyuncai/Arknights-Anti-addiction/archive/refs/heads/main.zip) 下载压缩包
2. 将压缩包解压
3. 双击 start.bat 启动服务

#### Linux

1. 下载压缩包或克隆库
2. 进入项目文件夹
3. `bash start.sh` 启用服务 (若无法使用，请执行 `bash install.sh` )

### 客户端连接

请确保客户端设备与服务端设备在同一局域网下 (同一 WiFi)

#### Android (含模拟器)

##### 第一种方法

1. 进入 WiFi 设置页面
2. 点击 / 长按 当前连接的 WiFi
3. 修改网络 - 高级选项 - 代理 - 手动
4. 主机名设置为服务端 IP ，端口设置为服务端端口，保存

##### 第二种方法

1. 安装 HTTP Proxy Client
2. 输入框内输入 `服务端 IP:服务端端口` ，如 `192.168.1.101:10032`
3. 点击 START 启动

##### 第三种方法 （Root)

1. 安装 ProxyDroid
2. Host 设置为服务端 IP ，Port 设置为服务端端口
3. 点击 Proxy Switch 启动

##### Android 7+ 额外步骤

由于 Android 7+ 策略修改，APP 默认不信任用户证书，只信任系统证书，所以需要把 Mitmproxy 证书安装到系统里才能使用

证书文件位置在 /system/etc/security/cacerts 里，必须为 PEM 格式，且文件命名必须符合系统证书规范

Windows 的 Mitmproxy 证书位置在 C:\Users\用户名\.mitmproxy 文件夹内，Linux 在 ~/.mitmproxy (需要运行一次 Mitmproxy 才会生成)

`openssl x509 -inform PEM -subject_hash_old -in mitmproxy-ca-cert.pem -noout # 获取证书 Hash`

返回值为 c8750f0d

使用 adb 操作

```shell
adb root # 重启 adb 并作为root启动
adb shell "mount -o rw,remount /system" # 重新挂载系统目录为可写
adb push C:\Users\用户名\.mitmproxy\c8750f0d.0 /system/etc/security/cacerts # 将证书推送至系统证书目录（注意修改用户名路径）
adb shell "chmod 644 /system/etc/security/cacerts/c8750f0d.0" # 修改证书权限
```

#### iOS (感谢 [Shelton786](https://github.com/Shelton786) 提供教程)

1. 进入 无线局域网详细信息

2. HTTP代理 - 配置代理，将服务器和端口设置为服务器端口和 IP ，保存

3. 进入网站 http://mitm.it 下载证书（iOS为描述文件）并安装

4. 设置 - 通用 - 关于本机 - 证书信任设置 - mitmproxy - 打开
