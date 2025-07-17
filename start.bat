@echo off
setlocal EnableDelayedExpansion

:: Define brands
set brands=MSI GIGABYTE ASROCK ASUS BIOSTAR

:: Pick random brand
set /a randBrand=%random% %% 5
for %%B in (%brands%) do (
    if !randBrand! == 0 set "brand=%%B"
    set /a randBrand-=1
)

:: Random date between 2022 and 2024
set /a year=2022 + (%random% %% 3)
set /a month=1 + (%random% %% 12)
if %month% LSS 10 set "month=0%month%"
set /a day=1 + (%random% %% 28)
if %day% LSS 10 set "day=0%day%"
set "rdate=%month%/%day%/%year%"

:: Generate random serials/UUIDs
set "uuid=%random%%random%-%random%-%random%-%random%-%random%%random%"
set /a sn1=%random%%random%
set /a sn2=%random%%random%
set /a sn3=%random%%random%
set /a sn4=%random%%random%

:: Use random short strings for serial-like stuff
set "SSN=T%random%%random%"
set "BSN=Z%random%%random%"
set "CSN=TU%random%%random%"
set "PSN=%random%%random%%random%"

:: Random CPU model: Intel i5/i7/i9 from 10th to 14th gen
set cpus=i5 i7 i9
set /a randCpu=%random% %% 3
for %%C in (%cpus%) do (
    if !randCpu! == 0 set "cpuSeries=%%C"
    set /a randCpu-=1
)
set /a cpuGen=10 + (%random% %% 5)
set /a cpuModel=900 + (%random% %% 100)
set "cpuFinal=INTEL-%cpuSeries%-%cpuGen%%cpuModel%K"

:: Final output
AMIDEWINx64.EXE /IVN "%brand%"
AMIDEWINx64.EXE /IV "2.05 Rev.C"
AMIDEWINx64.EXE /ID "%rdate%"
AMIDEWINx64.EXE /SM "%brand% TECHNOLOGY CO., LTD."
AMIDEWINx64.EXE /SP "%brand% Z790 ELITE"
AMIDEWINx64.EXE /SV "C.01, Rev 4.3, %rdate%"
AMIDEWINx64.EXE /SS "%SSN%"
AMIDEWINx64.EXE /SU AUTO
AMIDEWINx64.EXE /SK "SKU-%sn1%-%brand%-Z790E"
AMIDEWINx64.EXE /SF "%brand% Elite Series"
AMIDEWINx64.EXE /BM "%brand% TECHNOLOGY CO., LTD."
AMIDEWINx64.EXE /BP "%brand% Z790 ELITE"
AMIDEWINx64.EXE /BV "Rev 4.3"
AMIDEWINx64.EXE /BS "%BSN%"
AMIDEWINx64.EXE /BT "AT-GZ790E%sn2%"
AMIDEWINx64.EXE /CM "%brand% TECHNOLOGY CO., LTD."
AMIDEWINx64.EXE /CT "0Ah"
AMIDEWINx64.EXE /CV "Rev. H"
AMIDEWINx64.EXE /CS "%CSN%"
AMIDEWINx64.EXE /CA "%brand%-Z790E"
AMIDEWINx64.EXE /CO "00000014h"
AMIDEWINx64.EXE /PSN "%PSN%"
AMIDEWINx64.EXE /PAT "CPU-Z790E-ELITE-05"
AMIDEWINx64.EXE /PPN "%cpuFinal%"

pause
