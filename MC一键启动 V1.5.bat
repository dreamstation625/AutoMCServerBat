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
echo             糖糕云MC 一键启动脚本
echo ==============================================
echo.
echo ┌─────────────────────────────────────────────────────────────────┐
echo │                          Author Info                            │
echo ├─────────────────────────────────────────────────────────────────┤
echo │ Author     : 梦想小站                                      	  │
echo │ Github     : https://github.com/dreamstation625/AutoMCServerBat │
echo │ Bilibili   : https://space.bilibili.com/178030275               │
echo │ Sponsor    : 糖糕云 https://www.tanggaoyun.com               	  │
echo └─────────────────────────────────────────────────────────────────┘
echo.

echo.
::======大佬高抬贵手，不要把我主页去了。可以去友链======

title 糖糕云MC一键启动脚本 %version%
::这里存放了可以修改的变量
::开服核心，等号后面的都算，所以注意不要添加多余的符号、空格等
set serverjar=server.jar
::-Xms值（单位MB），即启动参数的最小分配内存，不推荐改
set minram=512
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
call :ColorText 07 "===[ 正在检测 Java 环境 ]===" && echo.
ping 127.1 -n 5 >nul 2>nul
echo ===[ Java环境检测输出 ]===
%useJava% -version
echo ===[ Java环境检测完毕 ]===
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

:: 初始化失败标志
set getmem=fail
:: ========== 尝试使用 wmic ==========
echo ===[ 尝试使用wmic获取系统参数 ]===
for /f "delims=" %%a in ('wmic os get TotalVisibleMemorySize /value 2^>nul ^| find "="') do (
    set %%a
)
for /f "delims=" %%b in ('wmic os get FreePhysicalMemory /value 2^>nul ^| find "="') do (
    set %%b
)
:: 检查是否成功获取值
if defined TotalVisibleMemorySize if defined FreePhysicalMemory (
    set /a ram=%TotalVisibleMemorySize% / 1024
    set /a freeram=%FreePhysicalMemory% / 1024
    set getmem=ok
)
:: ========== 如果 wmic 失败，尝试 PowerShell ==========
if "%getmem%"=="fail" (
	echo ===[ wmic获取失败，尝试使用power shell获取 ]===
    :: 获取总内存
	for /f "delims=" %%i in ('powershell -Command "(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize" 2^>nul') do (
		set "TotalVisibleMemorySize=%%i"
	)

	:: 获取空闲内存
	for /f "delims=" %%j in ('powershell -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory" 2^>nul') do (
		set "FreePhysicalMemory=%%j"
	)

	:: 计算 MB 单位的内存
	set /a ram=!TotalVisibleMemorySize! / 1024
	set /a freeram=!FreePhysicalMemory! / 1024
)

call :ColorText 07 "-----------------------------------------------------------" && echo.
call :ColorText 07 "[ 系统最大内存为：%ram% MB，剩余可用内存为：%freeram% MB ]" && echo.
::useram为-Xmx的值（单位MB），即启动参数的最大分配内存
set /a useram=%freeram%-%sysram%
call :ColorText 07 "[ 本次开服将分配最大 %useram% MB ]" && echo.
call :ColorText 07 "-----------------------------------------------------------" && echo.
echo 开服核心文件为 %serverjar% ，如果需要自定义，请编辑本脚本的第33行变量
echo 开服的额外参数 %extra% ，如果需要自定义，请编辑本脚本的第37行变量
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "开服参数：" && echo %useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar% && echo.
call :ColorText 07 "===========================================================" && echo.
call :ColorText 07 "PS：可以修改第44行变量指定java版本路径" && echo.
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
	echo 当前jdk一键部署已被移除，请前往Oracle官网手动下载安装，预计下个版本会增加全新的jdk安装模式。
	
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1	





::作者：梦想小站
::Github主页：https://github.com/dreamstation625/AutoMCServerBat
::B站主页：https://space.bilibili.com/178030275