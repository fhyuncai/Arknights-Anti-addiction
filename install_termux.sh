#!/data/data/com.termux/files/usr/bin/bash

echo "开始安装子系统 Debian"

echo "替换安装源为清华"
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
apt update -y && apt upgrade -y

echo "安装依赖"
pkg install wget openssl-tool proot -y && hash -r

# https://github.com/EXALAB/Anlinux-Resources/blob/master/Scripts/Installer/Debian/debian.sh
folder=debian-fs
if [ -d "$folder" ]; then
    first=1
    echo "跳过下载"
fi
tarball="debian-rootfs.tar.xz"
if [ "$first" != 1 ];then
    if [ ! -f $tarball ]; then
        echo "Download Rootfs, this may take a while base on your internet speed."
        case `dpkg --print-architecture` in
        aarch64)
            archurl="arm64" ;;
        arm)
            archurl="armhf" ;;
        amd64)
            archurl="amd64" ;;
        x86_64)
            archurl="amd64" ;;    
        i*86)
            archurl="i386" ;;
        x86)
            archurl="i386" ;;
        *)
            echo "unknown architecture"; exit 1 ;;
        esac
        #wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Rootfs/Debian/${archurl}/debian-rootfs-${archurl}.tar.xz" -O $tarball
        wget "https://raw.githubusercontents.com/EXALAB/AnLinux-Resources/master/Rootfs/Debian/${archurl}/debian-rootfs-${archurl}.tar.xz" -O $tarball
        if [ ! -f $tarball ]; then
            echo "文件下载失败"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p "$folder"
    cd "$folder"
    echo "Decompressing Rootfs, please be patient."
    proot --link2symlink tar -xJf ${cur}/${tarball}||:
    cd "$cur"
fi
mkdir -p debian-binds
bin=start-debian.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A debian-binds)" ]; then
    for f in debian-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b debian-fs/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
#command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
echo "removing image for some space"
rm $tarball
echo "安装子系统 Debian 完成"

echo "配置子系统 Debian"
sed -i 's@^\(deb http.*\)$@#\1\ndeb http://mirrors.aliyun.com/debian buster main contrib non-free@' debian-fs/etc/apt/sources.list
sed -i 's@^\(deb-src http.*\)$@#\1\ndeb-src http://mirrors.aliyun.com/debian buster main contrib non-free@' debian-fs/etc/apt/sources.list

echo "开始下载项目文件并移至子系统 Debian"
mkdir debian-fs/root/Arknights
cd debian-fs/root/Arknights
wget -i https://raw.githubusercontents.com/fhyuncai/Arknights-Anti-addiction/main/install_linux_dl.txt
chmod +x install.sh
cd ../../..
echo "文件已下载完成, 需要手动执行剩余命令:"
echo "================================"
echo "./${bin}"
echo "apt-get update && cd Arknights && ./install.sh"
echo "apt"
echo "================================"
echo "以上命令只需执行一次, 执行完成后方可正常使用, 立即启动请输入 ./start.sh , 以后每次进入 Termux 后执行以下命令使用:"
echo "================================"
echo "./${bin}"
echo "cd Arknights && ./start.sh"
echo "================================"
