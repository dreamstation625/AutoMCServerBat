@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
color 0a
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
set version=V1.3
echo ==============================================
echo             糖糕云 一键启动脚本
echo ==============================================
echo 作者：梦想小站
echo Github主页：https://github.com/dreamstation625/AutoMCServerBat
echo B站主页：https://space.bilibili.com/178030275
echo 友情支持：糖糕云www.xlhost.cn
echo.
::======大佬高抬贵手，不要把我主页去了。可以去友链======
::======大佬高抬贵手，不要把我主页去了。可以去友链======
title 糖糕云MC一键启动脚本 %version%
::这里存放了可以修改的变量
::开服核心，等号后面的都算，所以注意不要添加多余的符号、空格等
set serverjar=server.jar
::-Xms值（单位MB），即启动参数的最小分配内存，不推荐改
set minram=256
::额外的启动参数，比如-XX:UseG1GC。添加的话，注意最前和最后不要加空格
set extra=
::为系统额外保留内存（就是现在系统占用100mb，此处填100的话，假设mc全部吃满，系统还能再占用100）
::这个选项没事不要改
set sysram=768
::设置java目录，默认使用系统环境变量的java，使用此脚本的java安装脚本将会自动配置系统环境变量
::例如以下：注意要加英文的""!!!，其中，\bin\java.exe一般都是固定的。
::set useJava="C:\Program Files\Java\jdk-11.0.12\bin\java.exe"
set useJava=java

::先获取java版本并打印，如果java环境存在则开服
call :ColorText 07 "检测Java环境" && echo.
ping 127.1 -n 4 >nul 2>nul
echo ======Java环境检测输出======
%useJava% -version
echo ======Java环境检测完毕======
echo.
if not %errorlevel% == 0 (
	call :ColorText 4e "Java环境不存在，请按提示下载安装。" && echo.
	call :ColorText 07 "PS：Java环境也可以自己配置，推荐自己配置，实在不会可以使用此脚本安装配置" && echo.
	echo.
	goto selectjava
)
::此脚本为自动分配win服务器最大可用内存-%sysram%MB的启动脚本
::需要指定内存的，请使用其它脚本
::获取系统内存
for /f "delims=" %%a in ('wmic os get TotalVisibleMemorySize /value^|find "="') do set %%a
set /a t1=%TotalVisibleMemorySize%,t2=1024
set /a ram=%t1%/%t2%
for /f "delims=" %%b in ('wmic os get FreePhysicalMemory /value^|find "="') do set %%b
set /a t3=%FreePhysicalMemory%
set /a freeram=%t3%/%t2%
call :ColorText 07 "-----------------------------------------------------------" && echo.
call :ColorText 07 "系统最大内存为：%ram% MB，剩余可用内存为：%freeram% MB" && echo.
::useram为-Xmx的值（单位MB），即启动参数的最大分配内存
set /a useram=%freeram%-%sysram%
call :ColorText 07 "本次开服将分配最大 %useram% MB" && echo.
call :ColorText 07 "-----------------------------------------------------------" && echo.
echo 开服核心文件为 %serverjar% ，如果需要自定义，请编辑本脚本的第23行变量
echo 开服的额外参数 %extra% ，如果需要自定义，请编辑本脚本的第27行变量
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "开服参数：" && echo %useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar%
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "PS：可以修改第34行变量指定java版本路径" && echo.
echo. -----------------------------------------------------------------
echo.
echo.                    服务器即将开启,请等待……  
echo.
call :ColorText 0c "           注意：关闭服务器前请在后台输入stop保存玩家数据" && echo.
call :ColorText 0c "                      否则可能会出现回档情况" && echo.
echo.                
echo. -----------------------------------------------------------------
echo.
call :ColorText 07 "按下任意键来启动服务器！" && echo.
pause>nul
::启动
cls
color 07
echo. ----------------------------------------------------------------- 
echo. 
echo. 
echo.                   服务器正在启动中,请稍等……
echo. 
echo.
echo. -----------------------------------------------------------------
%useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar%
echo. ----------------------------------------------------------------- 
echo.                   服务器已关闭,按任意键退出                                
echo. -----------------------------------------------------------------
pause>nul
:batexit
exit

:selectjava
	echo =========Java版本选择=========
	echo 1、Java8  2、Java11  3、Java16
	echo 4、Java17
	echo ==============================
	echo "安装目录为C:\Program Files\Java\"
	call :ColorText 07 "PS：可以修改第34行变量指定java版本路径" && echo.
	set /p selectjava="请输入选项："
	if %selectjava%==1 (
		echo ======下载Java8——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java8.zip" (
			echo Java8安装脚本已下载。
		) else (
			bitsadmin /transfer Java8下载 /download http://java8.mxxz.work/java8.zip c:\java8.zip
			echo =============
			if exist "c:\java8.zip" (echo 下载完成) else (echo 下载失败)
		)
		echo ======下载unzip.exe——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe已下载。
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo 下载完成) else (echo 下载失败)
		)	
		echo 按任意键继续安装Java8
		pause>nul
		c:\unzip.exe -o c:\java8.zip
		echo.
		echo 在弹出的界面安装java环境，安装完毕后重新运行本脚本
		echo 按任意键继续安装并配置jdk
		pause>nul
		java8环境安装脚本.bat
		goto batexit
	) else if %selectjava%==2 (
		echo ======下载Java11——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java11.zip" (
			echo Java11安装脚本已下载。
		) else (
			bitsadmin /transfer Java11下载 /download http://java11.mxxz.work/java11.zip c:\java11.zip
			echo =============
			if exist "c:\java11.zip" (echo 下载完成) else (echo 下载失败)
		)
		echo ======下载unzip.exe——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe已下载。
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo 下载完成) else (echo 下载失败)
		)	
		echo 按任意键继续安装Java11
		pause>nul
		c:\unzip.exe -o c:\java11.zip
		echo.
		echo 在弹出的界面安装java环境，安装完毕后重新运行本脚本
		echo 按任意键继续安装并配置jdk
		pause>nul
		java11环境安装脚本.bat
		goto batexit
	) else if %selectjava%==3 (
		echo ======下载Java16——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java16.zip" (
			echo Java16安装脚本已下载。
		) else (
			bitsadmin /transfer Java16下载 /download http://java16.mxxz.work/java16.zip c:\java16.zip
			echo =============
			if exist "c:\java16.zip" (echo 下载完成) else (echo 下载失败)
		)
		echo ======下载unzip.exe——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe已下载。
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo 下载完成) else (echo 下载失败)
		)	
		echo 按任意键继续安装Java16
		pause>nul
		c:\unzip.exe -o c:\java16.zip
		echo.
		echo 在弹出的界面安装java环境，安装完毕后重新运行本脚本
		echo 按任意键继续安装并配置jdk
		pause>nul
		java16环境安装脚本.bat
		goto batexit
	) else if %selectjava%==4 (
		echo ======下载Java17——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\java17.zip" (
			echo Java17安装脚本已下载。
		) else (
			bitsadmin /transfer Java17下载 /download http://java17.mxxz.work/java17.zip c:\java17.zip
			echo =============
			if exist "c:\java17.zip" (echo 下载完成) else (echo 下载失败)
		)
		echo ======下载unzip.exe——5秒后开始下载======
		ping 127.1 -n 6 >nul 2>nul
		if exist "c:\unzip.exe" (
			echo unzip.exe已下载。
		) else (
			bitsadmin /transfer unzip /download http://file.mxxz.work/unzip.exe c:\unzip.exe
			echo =============
			if exist "c:\unzip.exe" (echo 下载完成) else (echo 下载失败)
		)	
		echo 按任意键继续安装Java17
		pause>nul
		c:\unzip.exe -o c:\java17.zip
		echo.
		echo 在弹出的界面安装java环境，安装完毕后重新运行本脚本
		echo 按任意键继续安装并配置jdk
		pause>nul
		java17环境安装脚本.bat
		goto batexit
	) else (
		echo 输入错误，请重新选择
		echo.
		goto selectjava
	)
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1	

::作者：梦想小站
::Github主页：https://github.com/dreamstation625/AutoMCServerBat
::B站主页：https://space.bilibili.com/178030275