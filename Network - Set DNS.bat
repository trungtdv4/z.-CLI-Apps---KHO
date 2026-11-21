<# :
@echo off
chcp 65001 >nul
title Cau hinh DNS
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Get-Content -LiteralPath '%~f0' -Raw)"
pause
exit /b
#>

# =========================================================
# LÕI POWERSHELL (Chỉ giữ Tham số & Logic đổi DNS)
# =========================================================

# 1. Khai báo Tham số (Sửa IP DNS trực tiếp tại đây)
param (
    [string]$DNS1 = "208.67.222.222",
    [string]$DNS2 = "208.67.220.220"
)

$ErrorActionPreference = 'Stop'


Write-Host "=======================================================================================================" -ForegroundColor Cyan
Write-Host "  Copyright (c) 2026 Trung Nguyen (82429801+trungtdv4@users.noreply.github.com). All rights reserved.  " -ForegroundColor DarkGray
Write-Host "=======================================================================================================" -ForegroundColor Cyan
Write-Host ""

try {
    # 2. Lấy danh sách card mạng vật lý đang kết nối
    $adapters = @(Get-NetAdapter -Physical | Where-Object Status -eq 'Up')

    if ($adapters.Count -eq 0) {
        Write-Host "[!] Khong tim thay Card mang vat ly nao dang hoat dong!" -ForegroundColor Red
    } else {
        # 3. Đổi DNS (Chú ý khoảng trắng chuẩn giữa 'in' và '$adapters')
        foreach ($adapter in $adapters) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses @($DNS1, $DNS2)
            Write-Host " [+] Da cap nhat DNS cho: $($adapter.Name)" -ForegroundColor Green
        }

        # 4. Flush Cache DNS
        Clear-DnsClientCache
        Write-Host ""
        Write-Host "[OK] CAU HINH DNS THANH CONG!" -ForegroundColor Green
        Write-Host "  - DNS 1: $DNS1" -ForegroundColor Gray
        Write-Host "  - DNS 2: $DNS2" -ForegroundColor Gray
    }
}
catch {
    Write-Host ""
    Write-Host "[LOI] $_" -ForegroundColor Red
    Write-Host "Luu y: Vui long chuot phai vao file va chon 'Run as administrator'!" -ForegroundColor Yellow
}