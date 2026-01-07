@echo off
REM ========================================================================
REM Windows 服务器启动脚本 - 高级版（带日志功能）
REM ========================================================================
REM 
REM 功能增强：
REM   1. 自动检测并使用最佳隐藏窗口方案
REM   2. 详细的日志记录（启动时间、进程信息等）
REM   3. 错误处理和诊断信息
REM   4. 自动创建日志目录
REM 
REM ========================================================================

REM 设置日志目录和文件
set LOG_DIR=.\logs
set LOG_FILE=%LOG_DIR%\server_startup_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOG_FILE=%LOG_FILE: =0%

REM 检查是否已经在隐藏模式下运行
if "%1"=="hide" goto CmdBegin

REM ========================================================================
REM 自动选择最佳隐藏窗口方案
REM ========================================================================

REM 优先使用 PowerShell 方案
where powershell.exe >nul 2>&1
if %errorlevel% equ 0 goto UsePowerShell

REM 备选方案：使用 VBScript
goto UseVBScript

:UsePowerShell
powershell.exe -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList 'hide' -WindowStyle Hidden"
exit

:UseVBScript
set vbs=%temp%\hidecmd_%random%.vbs
echo Set objShell = CreateObject("WScript.Shell") > "%vbs%"
echo objShell.Run """%~f0"" hide", 0, False >> "%vbs%"
cscript //nologo "%vbs%"
del "%vbs%"
exit

REM ========================================================================
REM 主程序入口（带日志记录）
REM ========================================================================
:CmdBegin

REM 创建日志目录
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM 开始记录日志
echo ======================================================================== > "%LOG_FILE%"
echo Java Server Startup Log >> "%LOG_FILE%"
echo ======================================================================== >> "%LOG_FILE%"
echo Start Time: %date% %time% >> "%LOG_FILE%"
echo Script Path: %~f0 >> "%LOG_FILE%"
echo Working Directory: %CD% >> "%LOG_FILE%"
echo User: %USERNAME% >> "%LOG_FILE%"
echo Computer: %COMPUTERNAME% >> "%LOG_FILE%"
echo ======================================================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM 设置 Java 环境变量
set javabin=.\etc\jdk8\bin
set JRE_HOME=.\etc\jdk8\bin
SET CLASSPATH=.;.\etc\jdk8\lib\jrt-fs.jar;start.jar

echo [%time%] Environment Variables Set >> "%LOG_FILE%"
echo   javabin=%javabin% >> "%LOG_FILE%"
echo   JRE_HOME=%JRE_HOME% >> "%LOG_FILE%"
echo   CLASSPATH=%CLASSPATH% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM 检查 Java 是否存在
if exist "%javabin%\java.exe" (
    echo [%time%] Java Found: %javabin%\java.exe >> "%LOG_FILE%"
    "%javabin%\java.exe" -version >> "%LOG_FILE%" 2>&1
) else (
    echo [%time%] ERROR: Java not found at %javabin%\java.exe >> "%LOG_FILE%"
)
echo. >> "%LOG_FILE%"

REM 检查 start.jar 是否存在
if exist "start.jar" (
    echo [%time%] start.jar Found >> "%LOG_FILE%"
) else (
    echo [%time%] ERROR: start.jar not found >> "%LOG_FILE%"
)
echo. >> "%LOG_FILE%"

REM 启用命令回显
@echo on 

REM 关闭旧的 hkjava 进程
echo [%time%] Attempting to kill old hkjava.exe processes... >> "%LOG_FILE%" 2>&1
taskkill /f /fi "imagename eq hkjava.exe" >> "%LOG_FILE%" 2>&1

REM 关闭旧的 localServer.bat 命令行窗口
echo [%time%] Attempting to kill old localServer.bat windows... >> "%LOG_FILE%" 2>&1
taskkill /FI "WINDOWTITLE eq localServer.bat" /IM cmd.exe /F >> "%LOG_FILE%" 2>&1

REM 设置当前窗口标题
title localServer.bat

@echo off
echo [%time%] Processes cleaned up >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM 执行 Java 停止命令
echo [%time%] Stopping Java server... >> "%LOG_FILE%"
"%javabin%\hkjava" -DSTOP.PORT=7439 -DSTOP.KEY=secret -jar start.jar --stop >> "%LOG_FILE%" 2>&1

REM 等待 4 秒，确保服务完全停止
echo [%time%] Waiting 4 seconds for server to stop... >> "%LOG_FILE%"
timeout /nobreak /t 4 >nul

echo [%time%] Starting Java server... >> "%LOG_FILE%"
echo   Command: "%javabin%\java" >> "%LOG_FILE%"
echo   Parameters: >> "%LOG_FILE%"
echo     -Xmx512m >> "%LOG_FILE%"
echo     -Xms40M >> "%LOG_FILE%"
echo     -XX:MinHeapFreeRatio=10 >> "%LOG_FILE%"
echo     -XX:MaxHeapFreeRatio=20 >> "%LOG_FILE%"
echo     -Xss2m >> "%LOG_FILE%"
echo     -XX:MaxMetaspaceSize=256m >> "%LOG_FILE%"
echo     -Dfile.encoding=utf-8 >> "%LOG_FILE%"
echo     -Dhttps.protocols=TLSv1.2 >> "%LOG_FILE%"
echo     -DSTOP.PORT=7439 >> "%LOG_FILE%"
echo     -DSTOP.KEY=secret >> "%LOG_FILE%"
echo     -jar start.jar >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM 启动 Java 服务器（后台运行，输出重定向到日志）
start /b "" "%javabin%\java" ^
  -Xmx512m ^
  -Xms40M ^
  -XX:MinHeapFreeRatio=10 ^
  -XX:MaxHeapFreeRatio=20 ^
  -Xss2m ^
  -XX:MaxMetaspaceSize=256m ^
  -classpath %CLASSPATH% ^
  -Dfile.encoding=utf-8 ^
  -Dhttps.protocols=TLSv1.2 ^
  -DSTOP.PORT=7439 ^
  -DSTOP.KEY=secret ^
  -jar start.jar >> "%LOG_FILE%" 2>&1

echo [%time%] Java server started >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM 显示进程信息
echo [%time%] Current Java processes: >> "%LOG_FILE%"
tasklist /FI "IMAGENAME eq java.exe" >> "%LOG_FILE%" 2>&1
echo. >> "%LOG_FILE%"

REM 显示端口监听状态
echo [%time%] Checking port 7439... >> "%LOG_FILE%"
netstat -ano | findstr ":7439" >> "%LOG_FILE%" 2>&1
echo. >> "%LOG_FILE%"

echo ======================================================================== >> "%LOG_FILE%"
echo Startup script completed >> "%LOG_FILE%"
echo End Time: %date% %time% >> "%LOG_FILE%"
echo ======================================================================== >> "%LOG_FILE%"

REM 显示日志位置
echo.
echo Server started successfully!
echo Log file: %LOG_FILE%
echo.

REM 保持脚本运行
pause

REM ========================================================================
REM 说明：
REM ========================================================================
REM 
REM 日志文件位置：
REM   .\logs\server_startup_YYYYMMDD_HHMMSS.log
REM 
REM 日志内容包括：
REM   - 启动时间和系统信息
REM   - 环境变量配置
REM   - Java 版本信息
REM   - 进程清理日志
REM   - 服务器启动参数
REM   - 当前运行的 Java 进程
REM   - 端口监听状态
REM 
REM 如何查看日志：
REM   1. 打开 .\logs\ 目录
REM   2. 找到最新的日志文件
REM   3. 使用文本编辑器打开
REM 
REM ========================================================================
