@echo off
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin
cd /d "%~dp0"
color 0a
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
set version=V1.5
echo ==============================================
echo             �Ǹ���MC һ�������ű�
echo ==============================================
echo.
echo ��������������������������������������������������������������������������������������������������������������������������������������
echo ��                          Author Info                            ��
echo ��������������������������������������������������������������������������������������������������������������������������������������
echo �� Author     : ����Сվ                                      	  ��
echo �� Github     : https://github.com/dreamstation625/AutoMCServerBat ��
echo �� Bilibili   : https://space.bilibili.com/178030275               ��
echo �� Sponsor    : �Ǹ��� https://www.tanggaoyun.com               	  ��
echo ��������������������������������������������������������������������������������������������������������������������������������������
echo.

echo.
::======���и�̧���֣���Ҫ������ҳȥ�ˡ�����ȥ����======

title �Ǹ���MCһ�������ű� %version%
::�������˿����޸ĵı���
::�������ģ��Ⱥź���Ķ��㣬����ע�ⲻҪ��Ӷ���ķ��š��ո��
set serverjar=server.jar
::-Xmsֵ����λMB������������������С�����ڴ棬���Ƽ���
set minram=512
::�������������������-XX:UseG1GC����ӵĻ���ע����ǰ�����Ҫ�ӿո�
set extra=
::Ϊϵͳ���Ᵽ���ڴ棨��������ϵͳռ��100mb���˴���100�Ļ�������mcȫ��������ϵͳ������ռ��100��
::���ѡ��û�²�Ҫ��
set sysram=768
::����javaĿ¼��Ĭ��ʹ��ϵͳ����������java��ʹ�ô˽ű���java��װ�ű������Զ�����ϵͳ��������
::�������£�ע��Ҫ��Ӣ�ĵ�""!!!�����У�\bin\java.exeһ�㶼�ǹ̶��ġ�
::set useJava="C:\Program Files\Java\jdk-11.0.12\bin\java.exe"
set useJava=java

::�Ȼ�ȡjava�汾����ӡ�����java���������򿪷�
call :ColorText 07 "===[ ���ڼ�� Java ���� ]===" && echo.
ping 127.1 -n 5 >nul 2>nul
echo ===[ Java���������� ]===
%useJava% -version
echo ===[ Java���������� ]===
echo.
if not %errorlevel% == 0 (
	call :ColorText 4e "Java���������ڣ��밴��ʾ���ذ�װ��" && echo.
	call :ColorText 07 "PS��Java����Ҳ�����Լ����ã��Ƽ��Լ����ã�ʵ�ڲ������ʹ�ô˽ű���װ����" && echo.
	echo.
	goto selectjava
)
::�˽ű�Ϊ�Զ�����win�������������ڴ�-%sysram%MB�������ű�
::��Ҫָ���ڴ�ģ���ʹ�������ű�
::��ȡϵͳ�ڴ�

:: ��ʼ��ʧ�ܱ�־
set getmem=fail
:: ========== ����ʹ�� wmic ==========
echo ===[ ����ʹ��wmic��ȡϵͳ���� ]===
for /f "delims=" %%a in ('wmic os get TotalVisibleMemorySize /value 2^>nul ^| find "="') do (
    set %%a
)
for /f "delims=" %%b in ('wmic os get FreePhysicalMemory /value 2^>nul ^| find "="') do (
    set %%b
)
:: ����Ƿ�ɹ���ȡֵ
if defined TotalVisibleMemorySize if defined FreePhysicalMemory (
    set /a ram=%TotalVisibleMemorySize% / 1024
    set /a freeram=%FreePhysicalMemory% / 1024
    set getmem=ok
)
:: ========== ��� wmic ʧ�ܣ����� PowerShell ==========
if "%getmem%"=="fail" (
	echo ===[ wmic��ȡʧ�ܣ�����ʹ��power shell��ȡ ]===
    :: ��ȡ���ڴ�
	for /f "delims=" %%i in ('powershell -Command "(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize" 2^>nul') do (
		set "TotalVisibleMemorySize=%%i"
	)

	:: ��ȡ�����ڴ�
	for /f "delims=" %%j in ('powershell -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory" 2^>nul') do (
		set "FreePhysicalMemory=%%j"
	)

	:: ���� MB ��λ���ڴ�
	set /a ram=!TotalVisibleMemorySize! / 1024
	set /a freeram=!FreePhysicalMemory! / 1024
)

call :ColorText 07 "-----------------------------------------------------------" && echo.
call :ColorText 07 "[ ϵͳ����ڴ�Ϊ��%ram% MB��ʣ������ڴ�Ϊ��%freeram% MB ]" && echo.
::useramΪ-Xmx��ֵ����λMB�����������������������ڴ�
set /a useram=%freeram%-%sysram%
call :ColorText 07 "[ ���ο������������ %useram% MB ]" && echo.
call :ColorText 07 "-----------------------------------------------------------" && echo.
echo ���������ļ�Ϊ %serverjar% �������Ҫ�Զ��壬��༭���ű��ĵ�33�б���
echo �����Ķ������ %extra% �������Ҫ�Զ��壬��༭���ű��ĵ�37�б���
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "����������" && echo %useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar% && echo.
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "PS�������޸ĵ�44�б���ָ��java�汾·��" && echo.
echo. -----------------------------------------------------------------
echo.
echo.                    ��������������,��ȴ�����  
echo.
call :ColorText 0c "           ע�⣺�رշ�����ǰ���ں�̨����stop�����������" && echo.
call :ColorText 0c "                      ������ܻ���ֻص����" && echo.
echo.                
echo. -----------------------------------------------------------------
echo.
call :ColorText 07 "�����������������������" && echo.
pause>nul
::����
cls
color 07
echo. ----------------------------------------------------------------- 
echo. 
echo. 
echo.                   ����������������,���Եȡ���
echo. 
echo.
echo. -----------------------------------------------------------------
%useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar%
echo. ----------------------------------------------------------------- 
echo.                   �������ѹر�,��������˳�                                
echo. -----------------------------------------------------------------
pause>nul
:batexit
exit

:selectjava
	echo ��ǰjdkһ�������ѱ��Ƴ�����ǰ��Oracle�����ֶ����ذ�װ��Ԥ���¸��汾������ȫ�µ�jdk��װģʽ��
	
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1	





::���ߣ�����Сվ
::Github��ҳ��https://github.com/dreamstation625/AutoMCServerBat
::Bվ��ҳ��https://space.bilibili.com/178030275