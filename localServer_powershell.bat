@echo off
REM ========================================================================
REM Windows 服务器启动脚本 - PowerShell 纯净版（Win7+）
REM ========================================================================
REM 
REM 此版本专为 PowerShell 优化，提供最佳兼容性
REM 推荐用于 Windows 7 SP1 及以上系统
REM 
REM ========================================================================

REM 检查 PowerShell 是否可用
where powershell.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 PowerShell，请使用 localServer_improved.bat
    pause
    exit /b 1
)

REM 如果已经在隐藏模式，跳转到主程序
if "%1"=="hide" goto CmdBegin

REM 使用 PowerShell 隐藏窗口启动
powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command ^
"Start-Process -FilePath cmd.exe -ArgumentList '/c','\"%~f0\" hide' -WindowStyle Hidden -WorkingDirectory '%CD%'"
exit

REM ========================================================================
REM 主程序入口
REM ========================================================================
:CmdBegin

set javabin=.\etc\jdk8\bin
set JRE_HOME=.\etc\jdk8\bin
SET CLASSPATH=.;.\etc\jdk8\lib\jrt-fs.jar;start.jar

@echo on 
taskkill /f /fi "imagename eq hkjava.exe" 2>nul
taskkill /FI "WINDOWTITLE eq localServer.bat" /IM cmd.exe /F 2>nul
title localServer.bat

"%javabin%\hkjava" -DSTOP.PORT=7439 -DSTOP.KEY=secret -jar start.jar --stop 2>nul
timeout /nobreak /t 4 >nul

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
  -jar start.jar

pause
