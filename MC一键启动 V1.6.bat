@echo off
net session >nul 2>&1
if not errorlevel 1 goto :Admin

rem 检查管理员权限；Server 服务禁用时 net session 可能误判，因此使用 fltmc 再次检查。
fltmc >nul 2>&1
if not errorlevel 1 goto :Admin

set "AMSB_ELEVATE_FILE=%~f0"
set "AMSB_ELEVATE_DIR=%~dp0"
powershell.exe -NoProfile -Command "try { Start-Process -FilePath $env:AMSB_ELEVATE_FILE -ArgumentList 'Admin' -WorkingDirectory $env:AMSB_ELEVATE_DIR -Verb RunAs -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 (
    echo UAC 提权已取消或失败。
    pause
)
exit /b
:Admin
cd /d "%~dp0"
color 07
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
set version=V1.6
title 糖糕云 MC 一键启动脚本 %version%
cls
echo.
call :ColorText 0b "╔══════════════════════════════════════════════════════════╗" && echo.
call :ColorText 0e "        ★  糖糕云 MC 一键启动脚本 %version%  ★" && echo.
call :ColorText 0b "╚══════════════════════════════════════════════════════════╝" && echo.
echo.
call :ColorText 0a "  ◆ 作者" && echo   梦想小站
call :ColorText 0a "  ◆ 项目" && echo   https://github.com/dreamstation625/AutoMCServerBat
call :ColorText 0a "  ◆ 主页" && echo   https://space.bilibili.com/178030275
call :ColorText 0a "  ◆ 赞助" && echo   糖糕云  https://www.tanggaoyun.com/aff/dream
echo.
call :ColorText 08 "  ────────────────────────────────────────────────────────" && echo.
echo.
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

::检查 Java 环境并显示版本信息
call :ColorText 0b "[步骤一] 正在检查 Java 环境……" && echo.
%useJava% -version
if errorlevel 1 (
	echo.
	call :ColorText 4e "[失败] 未找到可用的 Java 环境。" && echo.
	call :ColorText 07 "请安装 Java，或修改 useJava 变量指定 java.exe 的路径。" && echo.
	goto :selectjava
)
call :ColorText 0a "[成功] Java 环境检查通过。" && echo.
echo.
::此脚本为自动分配win服务器最大可用内存-%sysram%MB的启动脚本
::需要指定内存的，请使用其它脚本
::获取系统内存

:: 初始化失败标志
set getmem=fail
::优先使用 WMIC 获取内存信息
timeout /t 1 /nobreak >nul 2>&1
call :ColorText 0b "[步骤二] 正在读取系统内存信息……" && echo.
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
::WMIC 不可用时改用 PowerShell
if "%getmem%"=="fail" (
	echo       WMIC 不可用，正在改用 PowerShell……
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

::useram 为 -Xmx 的值（单位 MB）
set /a useram=%freeram%-%sysram%
echo [成功] 内存信息读取完成。
echo.
timeout /t 1 /nobreak >nul 2>&1
call :ColorText 0b "[步骤三] 启动配置" && echo.
echo ------------------------------------------------------------
echo 服务端核心：%serverjar%
echo Java 命令：%useJava%
echo 最小内存：%minram% MB
echo 最大内存：%useram% MB
echo 系统内存：总计 %ram% MB，可用 %freeram% MB，保留 %sysram% MB
if defined extra (
	echo 额外参数：%extra%
) else (
	echo 额外参数：无
)
echo 启动命令：%useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar%
echo ------------------------------------------------------------
call :ColorText 0c "提示：关闭服务器前请在控制台输入 stop，避免数据丢失或回档。" && echo.
echo.
echo 按任意键启动服务器，按 Ctrl+C 取消。
pause >nul
::启动服务器
cls
color 07
title 糖糕云 MC 一键启动脚本 %version% - 服务器运行中
echo.
call :ColorText 0b "╔══════════════════════════════════════════════════════════╗" && echo.
call :ColorText 0a "        ◆  服务器正在启动，请稍候……" && echo.
call :ColorText 0e "        ■  安全停服请在控制台输入 stop" && echo.
call :ColorText 0c "        ※  请勿直接关闭窗口，避免数据丢失或回档" && echo.
call :ColorText 0b "╚══════════════════════════════════════════════════════════╝" && echo.
echo.
%useJava% -Xms%minram%M -Xmx%useram%M %extra% -jar %serverjar%
set "serverExitCode=%errorlevel%"
echo.
call :ColorText 0b "╔══════════════════════════════════════════════════════════╗" && echo.
if "%serverExitCode%"=="0" (
	call :ColorText 0a "        √  服务器已正常停止" && echo.
) else (
	call :ColorText 0c "        ×  服务器异常退出" && echo.
)
call :ColorText 0e "        ◆  进程退出代码：%serverExitCode%" && echo.
call :ColorText 07 "        按任意键关闭窗口……" && echo.
call :ColorText 0b "╚══════════════════════════════════════════════════════════╝" && echo.
pause >nul
:batexit
exit

:selectjava
	echo.
	echo 当前版本不提供 Java 自动安装，请安装后重新运行本脚本。
	pause
	goto :batexit

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1	





::作者：梦想小站
::Github主页：https://github.com/dreamstation625/AutoMCServerBat
::B站主页：https://space.bilibili.com/178030275