@ECHO OFF&(CD /D "%~DP0")&(FLTMC>NUL)||(mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%~snx0"," %*","","runas",1^)^(window.close^)&&exit /b)

taskkill /f /im BaiduNetdisk* >NUL 2>NUL
taskkill /f /im YunDetectSer* >NUL 2>NUL

rd /s /q "%TEMP%\baidu" 2>NUL
rd /s /q "%TEMP%\bdyunguanjiaskinres" 2>NUL
rd /s /q "%AppData%\BaiduYunKernel" 2>NUL
rd /s /q "%AppData%\BaiduYunGuanjia" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduNetdisk" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduYunKernel" 2>NUL

:: 清理此电脑里的百度网盘快捷方式及种子关联项
reg delete "HKLM\SOFTWARE\Classes\Baiduyunguanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKCR\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
for /f "delims=" %%a in ('wmic userAccount where "Name='%userName%'" get SID /value') do call set "%%a" >NUL
reg delete "HKU\%SID%\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL

::阻止后台上传
if exist "%~dp0Autoupdate" (attrib +r +a +s +h +x "%~dp0Autoupdate" >NUL 2>NUL)
if exist "%~dp0kernel.dll" (attrib +r +a +s +h +x "%~dp0kernel.dll" >NUL 2>NUL)
if exist "%~dp0kernelbasis.dll" (attrib +r +a +s +h +x "%~dp0Kernelbasis.dll" >NUL 2>NUL)
if exist "%~dp0kernelpromote.dll" (attrib +r +a +s +h +x "%~dp0kernelpromote.dll" >NUL 2>NUL)
if exist "%~dp0kernelUpdate.exe" (attrib +r +a +s +h +x "%~dp0kernelUpdate.exe" >NUL 2>NUL)
if exist "%~dp0module\KernelCom" (attrib +r +a +s +h +x "%~dp0module\KernelCom" >NUL 2>NUL)
if exist BaiduNetdiskHost.exe (ren BaiduNetdiskHost.exe BaiduNetdiskHost.bak)
if exist YunDetectService.exe (ren YunDetectService.exe YunDetectService.bak)

::定义软件位置+Office在线打开支持
reg add "HKCU\Software\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunOfficeAddin.dll
reg add "HKLM\SOFTWARE\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
) else (
regsvr32 /s YunOfficeAddin64.dll
reg add "HKLM\SOFTWARE\Wow6432Node\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
)

mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\百度网盘.lnk""):b.TargetPath=""%~dp0BaiduNetdisk.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")

:Menu
Echo.&Echo  已经完成，以下按需选择：
Echo.&Echo  1、启用接管浏览器下载度盘的连接 (自选)
Echo.&Echo  2、启用视频播放监听服务器的程序 (自选)
Echo.&Echo  3、添加资源管理器右键上传度盘项 (自选)
ECHO.
set /p choice=输入数字敲回车键：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" Goto AddMenuExt
if /i "%choice%"=="2" Goto AddHostEXE
if /i "%choice%"=="3" Goto AddShellExt
ECHO 输入无效 &PAUSE>NUL&CLS&GOTO MENU

:AddMenuExt
regsvr32 /s npYunWebDetect.dll
if exist YunDetectService.bak ren YunDetectService.bak YunDetectService.exe
if exist YunDetectService.exe start /wait YunDetectService.exe -uninstall
if exist YunDetectService.exe start /wait YunDetectService.exe reg
start YunDetectService.exe
ECHO.&ECHO 完成，任意键返回! &PAUSE>NUL&CLS&GOTO MENU

:AddHostEXE
if exist BaiduNetdiskHost.bak ren BaiduNetdiskHost.bak BaiduNetdiskHost.exe
ECHO:&ECHO 完成，任意键返回! &PAUSE>NUL&CLS&GOTO MENU

:AddShellExt
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunShellExt.dll
) else (
regsvr32 /s YunShellExt64.dll
)
ECHO.&ECHO 完成，任意键返回! &PAUSE>NUL&CLS&GOTO MENU