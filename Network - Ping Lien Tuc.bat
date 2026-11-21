@echo off
title Auto Ping 15 Phut

set TARGET_IP=" gdbhyt.baohiemxahoi.gov.vn"
set DURATION_MINUTES=15

echo Dang thuc hien Ping toi %TARGET_IP% trong %DURATION_MINUTES% phut...
echo Cua so se tu dong dong sau khi hoan thanh.

powershell -Command "$stopTime = (Get-Date).AddMinutes(%DURATION_MINUTES%); while ((Get-Date) -lt $stopTime) { ping%TARGET_IP% -n 1; Start-Sleep -Seconds 1 }"

echo Da het thoi gian Ping. Dang dong cửa so...
timeout /t 2 >nul
exit