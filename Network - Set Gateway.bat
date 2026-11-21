<# :
@echo off
chcp 65001 >nul
title Thay doi Default Gateway & Restart Card Mang
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Get-Content -LiteralPath '%~f0' -Raw)"
pause
exit /b
#>

# =========================================================
# LÕI POWERSHELL (Chức năng đổi Gateway & Restart Adapter)
# =========================================================

# 1. Khai báo Tham số (Sửa IP Gateway mặc định tại đây hoặc truyền qua CLI)
param (
    [string]$Gateway = "192.168.1.2"
)

$ErrorActionPreference = 'Stop'

# =========================================================
# 2. KHỐI IN BANNER THÔNG TIN BẢN QUYỀN
# =========================================================
Write-Host "=========================================================================================" -ForegroundColor Cyan
Write-Host "  Copyright (c) 2026 Trung Nguyen (82429801+trungtdv4@users.noreply.github.com). All rights reserved.  " -ForegroundColor DarkGray
Write-Host "=========================================================================================" -ForegroundColor Cyan
Write-Host ""

try {
    # 3. Lấy danh sách card mạng vật lý đang kết nối (Up)
    $adapters = @(Get-NetAdapter -Physical | Where-Object Status -eq 'Up')

    if ($adapters.Count -eq 0) {
        Write-Host "[!] Khong tim thay Card mang vat ly nao dang hoat dong!" -ForegroundColor Red
    } else {
        foreach ($adapter in $adapters) {
            # Xóa các Default Gateway cũ đang tồn tại trên Card mạng
            Remove-NetRoute -InterfaceIndex $adapter.ifIndex -DestinationPrefix "0.0.0.0/0" -Confirm:$false -ErrorAction SilentlyContinue

            # Thêm Default Gateway mới theo tham số chỉ định
            New-NetRoute -InterfaceIndex $adapter.ifIndex -DestinationPrefix "0.0.0.0/0" -NextHop $Gateway | Out-Null
            
            Write-Host " [+] Da cap nhat Default Gateway moi ($Gateway) cho: $($adapter.Name)" -ForegroundColor Green

            # 4. Restart Card mạng để áp dụng ngay lập tức
            Write-Host " [*] Dang khoi dong lai Card mang ($($adapter.Name)) de ap dung cau hinh..." -ForegroundColor Yellow
            Restart-NetAdapter -Name $adapter.Name -Confirm:$false
        }

        # Clear DNS Cache để đồng bộ mạng mới
        Clear-DnsClientCache

        Write-Host ""
        Write-Host "[OK] DA THAY DOI DEFAULT GATEWAY VA LAM MOI CARD MANG THANH CONG!" -ForegroundColor Green
        Write-Host "  - Default Gateway moi: $Gateway" -ForegroundColor Gray
    }
}
catch {
    Write-Host ""
    Write-Host "[ERROR] $_" -ForegroundColor Red
    Write-Host "Luu y: Vui long chuot phai vao file va chon 'Run as administrator'!" -ForegroundColor Yellow
}