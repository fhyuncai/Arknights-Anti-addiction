@echo off
set port=10032

for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
    set ip=%%a
)
echo 主机名：%ip%
echo 端口：%port%
.\mitmdump.exe -s .\fcm.py --ssl-insecure -p %port% --no-http2 -q
