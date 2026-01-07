@echo off
REM ========================================================================
REM Windows 服务器核心启动脚本
REM ========================================================================
REM 
REM 此脚本包含实际的服务器启动逻辑，配合 localServer_launcher.vbs 使用
REM 也可以独立运行（会显示命令行窗口）
REM 
REM ========================================================================

REM 设置 Java 环境变量
set javabin=.\etc\jdk8\bin
set JRE_HOME=.\etc\jdk8\bin
SET CLASSPATH=.;.\etc\jdk8\lib\jrt-fs.jar;start.jar

REM 启用命令回显
@echo on 

REM 关闭旧的 hkjava 进程
taskkill /f /fi "imagename eq hkjava.exe" 2>nul

REM 关闭旧的 localServer.bat 命令行窗口
taskkill /FI "WINDOWTITLE eq localServer.bat" /IM cmd.exe /F 2>nul

REM 设置当前窗口标题
title localServer.bat

REM UTF-8 编码支持（如需要，取消注释）
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

REM 保持脚本运行
pause
