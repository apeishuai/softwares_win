@ECHO OFF&(CD /D "%~DP0")&(FLTMC>NUL)||(mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%~snx0"," %*","","runas",1^)^(window.close^)&&exit /b)

taskkill /f /im BaiduNetdisk* >NUL 2>NUL
taskkill /f /im YunDetectSer* >NUL 2>NUL

rd /s /q "%TEMP%\baidu" 2>NUL
rd /s /q "%TEMP%\bdyunguanjiaskinres" 2>NUL
rd /s /q "%AppData%\BaiduYunKernel" 2>NUL
rd /s /q "%AppData%\BaiduYunGuanjia" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduNetdisk" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduYunKernel" 2>NUL

:: ����˵�����İٶ����̿�ݷ�ʽ�����ӹ�����
reg delete "HKLM\SOFTWARE\Classes\Baiduyunguanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKCR\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
for /f "delims=" %%a in ('wmic userAccount where "Name='%userName%'" get SID /value') do call set "%%a" >NUL
reg delete "HKU\%SID%\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL

::��ֹ��̨�ϴ�
if exist "%~dp0Autoupdate" (attrib +r +a +s +h +x "%~dp0Autoupdate" >NUL 2>NUL)
if exist "%~dp0kernel.dll" (attrib +r +a +s +h +x "%~dp0kernel.dll" >NUL 2>NUL)
if exist "%~dp0kernelbasis.dll" (attrib +r +a +s +h +x "%~dp0Kernelbasis.dll" >NUL 2>NUL)
if exist "%~dp0kernelpromote.dll" (attrib +r +a +s +h +x "%~dp0kernelpromote.dll" >NUL 2>NUL)
if exist "%~dp0kernelUpdate.exe" (attrib +r +a +s +h +x "%~dp0kernelUpdate.exe" >NUL 2>NUL)
if exist "%~dp0module\KernelCom" (attrib +r +a +s +h +x "%~dp0module\KernelCom" >NUL 2>NUL)
if exist BaiduNetdiskHost.exe (ren BaiduNetdiskHost.exe BaiduNetdiskHost.bak)
if exist YunDetectService.exe (ren YunDetectService.exe YunDetectService.bak)

::�������λ��+Office���ߴ�֧��
reg add "HKCU\Software\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunOfficeAddin.dll
reg add "HKLM\SOFTWARE\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
) else (
regsvr32 /s YunOfficeAddin64.dll
reg add "HKLM\SOFTWARE\Wow6432Node\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
)

mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\�ٶ�����.lnk""):b.TargetPath=""%~dp0BaiduNetdisk.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")

:Menu
Echo.&Echo  �Ѿ���ɣ����°���ѡ��
Echo.&Echo  1�����ýӹ���������ض��̵����� (��ѡ)
Echo.&Echo  2��������Ƶ���ż����������ĳ��� (��ѡ)
Echo.&Echo  3�������Դ�������Ҽ��ϴ������� (��ѡ)
ECHO.
set /p choice=���������ûس�����
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" Goto AddMenuExt
if /i "%choice%"=="2" Goto AddHostEXE
if /i "%choice%"=="3" Goto AddShellExt
ECHO ������Ч &PAUSE>NUL&CLS&GOTO MENU

:AddMenuExt
regsvr32 /s npYunWebDetect.dll
if exist YunDetectService.bak ren YunDetectService.bak YunDetectService.exe
if exist YunDetectService.exe start /wait YunDetectService.exe -uninstall
if exist YunDetectService.exe start /wait YunDetectService.exe reg
start YunDetectService.exe
ECHO.&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU

:AddHostEXE
if exist BaiduNetdiskHost.bak ren BaiduNetdiskHost.bak BaiduNetdiskHost.exe
ECHO:&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU

:AddShellExt
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunShellExt.dll
) else (
regsvr32 /s YunShellExt64.dll
)
ECHO.&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU