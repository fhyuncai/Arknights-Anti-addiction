@echo off
set port=10032

for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
    set ip=%%a
)
echo ��������%ip%
echo �˿ڣ�%port%
.\mitmdump.exe -s .\fcm.py --ssl-insecure -p %port% --no-http2 -q
