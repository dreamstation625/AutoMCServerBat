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
set version=V1.4
echo ==============================================
echo             �Ǹ���MC һ�������ű�
echo ==============================================
echo ���ߣ�����Сվ
echo Github��ҳ��https://github.com/dreamstation625/AutoMCServerBat
echo Bվ��ҳ��https://space.bilibili.com/178030275
echo ����֧�֣��Ǹ��� https://cloud.candycake.cloud
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
call :ColorText 07 "���Java����" && echo.
ping 127.1 -n 4 >nul 2>nul
echo ======Java����������======
%useJava% -version
echo ======Java����������======
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
for /f "delims=" %%a in ('wmic os get TotalVisibleMemorySize /value^|find "="') do set %%a
set /a t1=%TotalVisibleMemorySize%,t2=1024
set /a ram=%t1%/%t2%
for /f "delims=" %%b in ('wmic os get FreePhysicalMemory /value^|find "="') do set %%b
set /a t3=%FreePhysicalMemory%
set /a freeram=%t3%/%t2%
call :ColorText 07 "-----------------------------------------------------------" && echo.
call :ColorText 07 "ϵͳ����ڴ�Ϊ��%ram% MB��ʣ������ڴ�Ϊ��%freeram% MB" && echo.
::useramΪ-Xmx��ֵ����λMB�����������������������ڴ�
set /a useram=%freeram%-%sysram%
call :ColorText 07 "���ο������������ %useram% MB" && echo.
call :ColorText 07 "-----------------------------------------------------------" && echo.
echo ���������ļ�Ϊ %serverjar% �������Ҫ�Զ��壬��༭���ű��ĵ�26�б���
echo �����Ķ������ %extra% �������Ҫ�Զ��壬��༭���ű��ĵ�30�б���
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "����������" && echo %useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar% && echo.
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "PS�������޸ĵ�37�б���ָ��java�汾·��" && echo.
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
	echo =========Java�汾ѡ��=========
	echo 1��Java8    2��Java11    3��Java16
	echo 4��Java17   5��Java18
	echo ==============================
	echo "��װĿ¼ΪC:\Program Files\Java\"
	call :ColorText 07 "PS�������޸ĵ�37�б���ָ��java�汾·��" && echo.
	set /p selectjava="������ѡ�"
	if %selectjava%==1 (
		echo ======����Java8����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java8.zip" (
			echo Java8��װ�ű������ء�
		) else (
			bitsadmin /transfer Java8���� /download http://java8.mxxz.work/java8.zip c:\java8.zip
			echo =============
			if exist "c:\java8.zip" (echo �������) else (echo ����ʧ��)
		)
		echo ======����unzip.exe����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe�����ء�
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo �������) else (echo ����ʧ��)
		)	
		echo �������������װJava8
		pause>nul
		c:\unzip.exe -o c:\java8.zip
		echo.
		echo �ڵ����Ľ��氲װjava��������װ��Ϻ��������б��ű�
		echo �������������װ������jdk
		pause>nul
		java8������װ�ű�.bat
		goto batexit
	) else if %selectjava%==2 (
		echo ======����Java11����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java11.zip" (
			echo Java11��װ�ű������ء�
		) else (
			bitsadmin /transfer Java11���� /download http://java11.mxxz.work/java11.zip c:\java11.zip
			echo =============
			if exist "c:\java11.zip" (echo �������) else (echo ����ʧ��)
		)
		echo ======����unzip.exe����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe�����ء�
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo �������) else (echo ����ʧ��)
		)	
		echo �������������װJava11
		pause>nul
		c:\unzip.exe -o c:\java11.zip
		echo.
		echo �ڵ����Ľ��氲װjava��������װ��Ϻ��������б��ű�
		echo �������������װ������jdk
		pause>nul
		java11������װ�ű�.bat
		goto batexit
	) else if %selectjava%==3 (
		echo ======����Java16����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java16.zip" (
			echo Java16��װ�ű������ء�
		) else (
			bitsadmin /transfer Java16���� /download http://java16.mxxz.work/java16.zip c:\java16.zip
			echo =============
			if exist "c:\java16.zip" (echo �������) else (echo ����ʧ��)
		)
		echo ======����unzip.exe����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe�����ء�
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo �������) else (echo ����ʧ��)
		)	
		echo �������������װJava16
		pause>nul
		c:\unzip.exe -o c:\java16.zip
		echo.
		echo �ڵ����Ľ��氲װjava��������װ��Ϻ��������б��ű�
		echo �������������װ������jdk
		pause>nul
		java16������װ�ű�.bat
		goto batexit
	) else if %selectjava%==4 (
		echo ======����Java17����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java17.zip" (
			echo Java17��װ�ű������ء�
		) else (
			bitsadmin /transfer Java17���� /download http://java17.mxxz.work/java17.zip c:\java17.zip
			echo =============
			if exist "c:\java17.zip" (echo �������) else (echo ����ʧ��)
		)
		echo ======����unzip.exe����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe�����ء�
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo �������) else (echo ����ʧ��)
		)	
		echo �������������װJava17
		pause>nul
		c:\unzip.exe -o c:\java17.zip
		echo.
		echo �ڵ����Ľ��氲װjava��������װ��Ϻ��������б��ű�
		echo �������������װ������jdk
		pause>nul
		java17������װ�ű�.bat
		goto batexit
	) else if %selectjava%==5 (
		echo ======����Java18����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java18.zip" (
			echo Java18��װ�ű������ء�
		) else (
			bitsadmin /transfer Java18���� /download http://java18.mxxz.work/java18.zip c:\java18.zip
			echo =============
			if exist "c:\java18.zip" (echo �������) else (echo ����ʧ��)
		)
		echo ======����unzip.exe����5���ʼ����======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe�����ء�
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo �������) else (echo ����ʧ��)
		)	
		echo �������������װJava18
		pause>nul
		c:\unzip.exe -o c:\java18.zip
		echo.
		echo �ڵ����Ľ��氲װjava��������װ��Ϻ��������б��ű�
		echo �������������װ������jdk
		pause>nul
		java18������װ�ű�.bat
		goto batexit	
	) else (
		echo �������������ѡ��
		echo.
		goto selectjava
	)
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1	

::���ߣ�����Сվ
::Github��ҳ��https://github.com/dreamstation625/AutoMCServerBat
::Bվ��ҳ��https://space.bilibili.com/178030275