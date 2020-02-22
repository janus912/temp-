@echo off
set myYear=%date:~10,4%
set myMonth=%date:~4,2%
set myDay=%date:~7,2%
set mydate=%date%
set mytime=%time%
echo .
echo Starting Time is %mydate%:%mytime%
echo .
REM To check whether the targeted foler existed or not, if it doesn't then create that folder
if not exist %myYear%%myMonth%%myDay% (
 echo .
 echo To Build Daily Folder to each day
 mkdir %myYear%%myMonth%%myDay%
 echo .
) else (
 echo .
 echo To delete the contents of folder
 del /Q .\%myYear%%myMonth%%myDay%\*.*
 echo .
)
if exist *.ff (
 echo delete *.ff
 del /Q *.ff
)

REM To check SDN.FTP foler existed or not, if it doesn't then it doesn't start the FTP processes
if not exist sdn.ftp (echo SDN.FTP missed.) else (ftp -i -n -s:sdn.ftp)
REM To check all six files download properly.
set myflag=0
dir sdn.ff
if errorlevel 1 (
 echo SDN.FF file not download
 set myflag=1
)
dir alt.ff
if errorlevel 1 (
 echo ALT.FF file not download
 set myflag=1
)
dir add.ff
if errorlevel 1 (
 echo ADD.FF file not download
 set myflag=1
)
dir cons_prim.ff
if errorlevel 1 (
 echo CONS_PRIM.FF file not download
 set myflag=1
)
dir cons_alt.ff
if errorlevel 1 (
 echo CONS_ALT.FF file not download
 set myflag=1
)
dir cons_add.ff
if errorlevel 1 (
 echo CONS_ADD.FF file not download
 set myflag=1
)
REM If SDN and Consolidated List download not properly, then stop the IWL generated process.
REM If everything goes well, then move the lists(*.ff) and XML to another folder to keep.
if %myflag%==1 (
 echo There is something wrong within SDN Download Process
) else (
 "C:\Program Files\Microsoft Office\root\Office16\excel.exe" "C:\Users\009374\Desktop\OFAC#1B\OFAC#1B.xlsm"  
 dir OFAC#1B.XML
 if errorlevel 1 (
  echo There is something WRONG during Generate XML process.
 ) else (
  move *.ff .\%myYear%%myMonth%%myDay%
  move OFAC#1B.XML .\%myYear%%myMonth%%myDay%\%myYear%%myMonth%%myDay%.XML
 )
)
set mydate=%date%
set mytime=%time%
echo .
echo Ending Time is %mydate%:%mytime%
echo .
@echo on