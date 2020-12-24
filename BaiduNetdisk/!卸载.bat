@ECHO OFF&(CD /D "%~DP0")&(FLTMC>NUL)||(mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%~snx0"," %*","","runas",1^)^(window.close^)&&exit /b)

taskkill /f /im BaiduNetdisk* >NUL 2>NUL
taskkill /f /im YunDetectSer* >NUL 2>NUL

regsvr32 /s /u npYunWebDetect.dll
regsvr32 /s /u YunShellExt.dll
regsvr32 /s /u YunShellExt64.dll
regsvr32 /s /u YunOfficeAddin.dll
regsvr32 /s /u YunOfficeAddin64.dll
if exist HelpUtility.exe start /wait HelpUtility.exe -cmd import_removablediskfile -uninstall
if exist YunDetectService.exe start /wait YunDetectService.exe unreg
if exist BaiduNetdiskHost.exe ren BaiduNetdiskHost.exe  BaiduNetdiskHost.bak
if exist YunDetectService.exe ren YunDetectService.exe  YunDetectService.bak

del AppProperty.xml >NUL 2>NUL
del AppSettingApp.dat >NUL 2>NUL
rd /s /q "%TEMP%\baidu" 2>NUL
rd /s /q "%TEMP%\baiduyunguanjia" 2>NUL
rd /s /q "%TEMP%\bdyunguanjiaskinres" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduNetdisk" 2>NUL
rd /s /q "%AppData%\BaiduYunGuanjia" 2>NUL
rd /s /q "%AppData%\BaiduYunKernel" 2>NUL
del "%UserProfile%\桌面\百度网盘.lnk" >NUL 2>NUL
del "%UserProfile%\Desktop\百度网盘.lnk" >NUL 2>NUL

reg delete "HKCR\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKCU\Software\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\Baiduyunguanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Wow6432Node\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL

reg delete "HKCR\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
for /f "delims=" %%a in ('wmic userAccount where "Name='%userName%'" get SID /value') do call set "%%a" >nul
reg delete "HKU\%SID%\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL

ver|findstr "5\.[0-9]\.[0-9][0-9]*" > nul && (goto WinXP)
ver|findstr "\<6\.[0-9]\.[0-9][0-9]*\> \<10\.[0-9]\.[0-9][0-9]*\>" > nul && (goto Win7+)


:WinXP
taskkill /f /im explorer.exe && start explorer.exe
ECHO.&ECHO 完成！ &PAUSE>NUL&EXIT

:Win7+
Call :_RestartExplorer
goto :eof
:_RestartExplorer
(
  echo Dim arrURL^(^), strURL, oShell, oWin, n
  echo n = -1
  echo Set oShell = CreateObject^("Shell.Application"^)
  echo For Each oWin In oShell.Windows
  echo   If Instr^(1, oWin.FullName, "\explorer.exe", vbTextCompare^) Then
  echo     n = n + 1
  echo     ReDim Preserve arrURL^(n^)
  echo     arrURL^(n^) = oWin.LocationURL
  echo   End If
  echo Next
  echo CreateObject^("WScript.Shell"^).run "tskill explorer", 0, True
  echo For Each strURL In arrURL
  echo   oShell.Explore strURL
  echo Next
)>"%temp%\RestartExplorer.vbs"
  CScript //NoLogo "%temp%\RestartExplorer.vbs"
  del /q /f "%temp%\RestartExplorer.vbs"
  goto :eof