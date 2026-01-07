@echo off
REM ========================================================================
REM Windows 通用服务器启动脚本（支持 Win7/Win10/Win11）
REM ========================================================================
REM 
REM 功能说明：
REM   1. 隐藏命令行窗口启动 Java 服务器
REM   2. 自动检测系统版本，选择最佳隐藏窗口方案
REM   3. 关闭旧进程并重启服务器
REM 
REM 隐藏窗口方案优先级：
REM   方案1: PowerShell Start-Process -WindowStyle Hidden （Win7+ 推荐）
REM   方案2: VBScript CreateObject WScript.Shell.Run （Win7-Win11 通用）
REM   方案3: mshta + VBScript （Win7-Win10 可用，Win11 部分不兼容）
REM 
REM ========================================================================

REM 检查是否已经在隐藏模式下运行
if "%1"=="hide" goto CmdBegin

REM ========================================================================
REM 方案选择：自动检测并使用最合适的隐藏窗口方法
REM ========================================================================

REM 优先使用 PowerShell 方案（Win7+ 通用，最稳定）
where powershell.exe >nul 2>&1
if %errorlevel% equ 0 goto UsePowerShell

REM 备选方案：使用 VBScript（不依赖 mshta）
goto UseVBScript

REM ========================================================================
REM 方案1: PowerShell 隐藏窗口方案（推荐）
REM ========================================================================
REM 优点：
REM   - Windows 7 及以上系统内置
REM   - 稳定性好，兼容性强
REM   - 不依赖 mshta，避免 Win11 兼容性问题
REM ========================================================================
:UsePowerShell
powershell.exe -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList 'hide' -WindowStyle Hidden"
exit

REM ========================================================================
REM 方案2: VBScript 隐藏窗口方案（备选）
REM ========================================================================
REM 优点：
REM   - Windows 7-11 全系统支持
REM   - 不依赖 mshta，直接使用 wscript/cscript 运行
REM   - 轻量级，无额外依赖
REM ========================================================================
:UseVBScript
REM 创建临时 VBScript 文件
set vbs=%temp%\hidecmd_%random%.vbs
echo Set objShell = CreateObject("WScript.Shell") > "%vbs%"
echo objShell.Run """%~f0"" hide", 0, False >> "%vbs%"
cscript //nologo "%vbs%"
del "%vbs%"
exit

REM ========================================================================
REM 主程序入口：执行 Java 服务器启动逻辑
REM ========================================================================
:CmdBegin

REM 设置 Java 环境变量
set javabin=.\etc\jdk8\bin
set JRE_HOME=.\etc\jdk8\bin
SET CLASSPATH=.;.\etc\jdk8\lib\jrt-fs.jar;start.jar

REM 启用命令回显（用于调试）
@echo on 

REM 关闭旧的 hkjava 进程
taskkill /f /fi "imagename eq hkjava.exe" 2>nul

REM 关闭旧的 localServer.bat 命令行窗口
taskkill /FI "WINDOWTITLE eq localServer.bat" /IM cmd.exe /F 2>nul

REM 设置当前窗口标题（方便进程识别）
title localServer.bat

REM 如果需要 UTF-8 编码，取消下面注释
REM chcp 65001

REM 执行 Java 停止命令
"%javabin%\hkjava" -DSTOP.PORT=7439 -DSTOP.KEY=secret -jar start.jar --stop 2>nul

REM 等待 4 秒，确保服务完全停止
timeout /nobreak /t 4 >nul

REM 启动 Java 服务器（后台运行）
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

REM 服务器启动成功，保持脚本运行（可以选择性注释掉 pause）
REM 注释掉 pause 可让脚本完全在后台运行
pause

REM ========================================================================
REM 说明：
REM ========================================================================
REM 
REM 如何使用：
REM   1. 双击运行脚本，窗口会自动隐藏
REM   2. Java 服务器在后台启动
REM   3. 如需查看日志，可将输出重定向到文件
REM 
REM 故障排查：
REM   - 如果窗口没有隐藏：检查 PowerShell 是否可用
REM   - 如果服务启动失败：检查 Java 路径和 start.jar 是否存在
REM   - 如需调试：注释掉隐藏窗口部分，直接运行 :CmdBegin 段
REM 
REM 兼容性测试：
REM   - Windows 7：PowerShell 2.0+ 支持
REM   - Windows 10：完全支持
REM   - Windows 11：完全支持，不依赖 mshta
REM 
REM ========================================================================
