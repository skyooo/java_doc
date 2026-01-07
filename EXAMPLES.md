# 使用示例

> 实际使用场景和代码示例

---

## 📖 目录

1. [基础使用](#基础使用)
2. [高级使用](#高级使用)
3. [调试和故障排查](#调试和故障排查)
4. [批量部署](#批量部署)
5. [自定义配置](#自定义配置)

---

## 基础使用

### 示例 1：首次使用

```cmd
# 1. 测试系统兼容性
双击运行：test_compatibility.bat

# 2. 根据推荐选择脚本（通常是 localServer_improved.bat）
双击运行：localServer_improved.bat

# 完成！服务器已在后台启动
```

**预期结果：**
- 命令行窗口会短暂出现后自动隐藏
- Java 服务器在后台运行
- 可在任务管理器中看到 `java.exe` 进程

---

### 示例 2：快速启动（推荐方案）

```cmd
# 直接运行推荐脚本
双击运行：localServer_improved.bat
```

**说明：**
- 脚本会自动检测系统环境
- 优先使用 PowerShell，降级使用 VBScript
- 窗口自动隐藏

---

### 示例 3：使用 PowerShell 方案

```cmd
# 如果确定系统有 PowerShell
双击运行：localServer_powershell.bat
```

**适用场景：**
- Windows 7 SP1 及以上系统
- 企业环境部署
- 追求代码简洁

---

### 示例 4：使用 VBScript 方案

```cmd
# 最大兼容性方案
双击运行：localServer_launcher.vbs
```

**适用场景：**
- 精简版 Windows 系统
- 不支持 PowerShell 的环境
- 需要最大兼容性

---

## 高级使用

### 示例 5：启用日志记录

```cmd
# 使用高级版脚本
双击运行：localServer_advanced.bat

# 查看日志文件
cd logs
dir
notepad server_startup_*.log
```

**日志内容示例：**
```
========================================================================
Java Server Startup Log
========================================================================
Start Time: 2025-01-07 14:30:25.12
Script Path: C:\MyProject\localServer_advanced.bat
Working Directory: C:\MyProject
User: Administrator
Computer: DESKTOP-ABC123
========================================================================

[14:30:25.15] Environment Variables Set
  javabin=.\etc\jdk8\bin
  JRE_HOME=.\etc\jdk8\bin
  CLASSPATH=.;.\etc\jdk8\lib\jrt-fs.jar;start.jar

[14:30:25.18] Java Found: .\etc\jdk8\bin\java.exe
java version "1.8.0_291"
Java(TM) SE Runtime Environment (build 1.8.0_291-b10)

[14:30:25.20] start.jar Found

[14:30:25.22] Attempting to kill old hkjava.exe processes...
INFO: No tasks found that match the specified criteria.

[14:30:25.25] Attempting to kill old localServer.bat windows...
INFO: No tasks found that match the specified criteria.

[14:30:25.28] Processes cleaned up

[14:30:25.30] Stopping Java server...

[14:30:25.35] Waiting 4 seconds for server to stop...

[14:30:29.40] Starting Java server...
  Command: ".\etc\jdk8\bin\java"
  Parameters:
    -Xmx512m
    -Xms40M
    -XX:MinHeapFreeRatio=10
    -XX:MaxHeapFreeRatio=20
    -Xss2m
    -XX:MaxMetaspaceSize=256m
    -Dfile.encoding=utf-8
    -Dhttps.protocols=TLSv1.2
    -DSTOP.PORT=7439
    -DSTOP.KEY=secret
    -jar start.jar

[14:30:29.50] Java server started

[14:30:29.55] Current Java processes:
java.exe                     12345 Console                    1    256,789 K

[14:30:29.60] Checking port 7439...
  TCP    0.0.0.0:7439           0.0.0.0:0              LISTENING       12345

========================================================================
Startup script completed
End Time: 2025-01-07 14:30:29.65
========================================================================
```

---

### 示例 6：显示窗口模式（调试）

```cmd
# 运行核心脚本（显示窗口）
双击运行：localServer_core.bat
```

**用途：**
- 查看详细的启动过程
- 排查启动失败问题
- 查看 Java 输出信息
- 调试脚本

---

### 示例 7：命令行参数使用

```cmd
# 隐藏窗口启动
localServer_improved.bat

# 显示窗口启动（调试模式）
localServer_improved.bat hide
```

**说明：**
- 不带参数：自动检测并隐藏窗口
- 带 `hide` 参数：直接跳转到主程序入口

---

## 调试和故障排查

### 示例 8：检查系统兼容性

```cmd
# 运行兼容性测试
test_compatibility.bat
```

**输出示例：**
```
========================================================================
Windows 隐藏窗口方案兼容性测试
========================================================================

[1/5] 检测 Windows 版本...
Microsoft Windows [Version 10.0.22621.2506]

[2/5] 检测 PowerShell...
[✓] PowerShell 可用
Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      22621  2506

[3/5] 检测 VBScript (cscript)...
[✓] VBScript (cscript) 可用

[4/5] 检测 VBScript (wscript)...
[✓] VBScript (wscript) 可用

[5/5] 检测 mshta（仅供参考）...
[✗] mshta 不可用或已被禁用

========================================================================
推荐方案
========================================================================

[推荐] 使用 localServer_improved.bat 或 localServer_powershell.bat
[原因] 您的系统支持 PowerShell，这是最稳定的方案

========================================================================
测试完成
========================================================================
```

---

### 示例 9：排查 Java 启动失败

```cmd
# 1. 使用显示窗口模式
localServer_core.bat

# 2. 检查 Java 版本
.\etc\jdk8\bin\java -version

# 3. 检查文件是否存在
dir start.jar
dir .\etc\jdk8\bin\java.exe

# 4. 检查端口占用
netstat -ano | findstr 7439

# 5. 如果端口被占用，查找进程
tasklist | findstr <PID>

# 6. 关闭占用端口的进程
taskkill /PID <PID> /F
```

---

### 示例 10：查看详细错误信息

修改脚本，重定向输出到文件：

```batch
# 在 localServer_core.bat 中，修改 Java 启动命令：
start /b "" "%javabin%\java" ^
  -Xmx512m ^
  ... ^
  -jar start.jar > output.log 2>&1

# 然后查看日志
notepad output.log
```

---

### 示例 11：手动调试 PowerShell 方案

```powershell
# 1. 检查 PowerShell 版本
$PSVersionTable.PSVersion

# 2. 测试 Start-Process 命令
Start-Process -FilePath cmd.exe -ArgumentList '/c','echo Hello' -WindowStyle Hidden

# 3. 检查执行策略
Get-ExecutionPolicy

# 4. 临时修改执行策略（如果需要）
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### 示例 12：手动调试 VBScript 方案

创建测试 VBS 文件：

```vbscript
' test.vbs
Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd.exe /c echo Hello && pause", 1, True
```

运行测试：
```cmd
cscript //nologo test.vbs
```

---

## 批量部署

### 示例 13：企业环境批量部署

```cmd
REM deploy.bat
@echo off

REM 复制脚本到目标目录
xcopy /Y localServer_improved.bat \\server\share\app\
xcopy /Y .\etc \\server\share\app\etc\ /E /I

REM 或使用 PowerShell 版本（推荐）
xcopy /Y localServer_powershell.bat \\server\share\app\

echo 部署完成！
pause
```

---

### 示例 14：创建桌面快捷方式

```cmd
# 手动创建快捷方式：
# 1. 右键点击 localServer_improved.bat
# 2. 选择"创建快捷方式"
# 3. 将快捷方式拖到桌面或开始菜单

# 或使用 PowerShell 创建：
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\启动服务器.lnk")
$Shortcut.TargetPath = "C:\MyProject\localServer_improved.bat"
$Shortcut.WorkingDirectory = "C:\MyProject"
$Shortcut.Save()
```

---

### 示例 15：添加到启动项

**方法 1：复制到启动文件夹**
```cmd
# Windows 10/11
copy localServer_improved.bat "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"

# 或创建快捷方式到启动文件夹
```

**方法 2：使用任务计划程序**
```cmd
# 创建开机自启任务
schtasks /create /tn "MyServer" /tr "C:\MyProject\localServer_improved.bat" /sc onlogon /rl highest
```

---

## 自定义配置

### 示例 16：修改 JVM 参数

```batch
# 在脚本中找到 Java 启动命令部分，修改参数：

# 增加最大内存到 1GB
-Xmx1024m

# 增加初始内存到 128MB
-Xms128M

# 修改栈大小
-Xss4m

# 添加 GC 日志
-Xloggc:gc.log
-XX:+PrintGCDetails
-XX:+PrintGCDateStamps
```

---

### 示例 17：自定义 Java 路径

```batch
# 修改 Java 路径变量
set javabin=C:\Program Files\Java\jdk-11\bin
set JRE_HOME=C:\Program Files\Java\jdk-11\bin

# 或使用系统 Java
set javabin=%JAVA_HOME%\bin
set JRE_HOME=%JAVA_HOME%\bin
```

---

### 示例 18：自定义停止端口

```batch
# 修改 STOP.PORT 参数
-DSTOP.PORT=8888

# 注意：停止命令也要使用相同端口
"%javabin%\hkjava" -DSTOP.PORT=8888 -DSTOP.KEY=secret -jar start.jar --stop
```

---

### 示例 19：添加环境变量

```batch
# 在脚本中添加环境变量
set MY_APP_ENV=production
set MY_APP_CONFIG=config.xml

# 然后在 Java 启动参数中使用
-Dapp.env=%MY_APP_ENV%
-Dapp.config=%MY_APP_CONFIG%
```

---

### 示例 20：输出重定向

```batch
# 重定向标准输出和错误到不同文件
start /b "" "%javabin%\java" ^
  ... ^
  -jar start.jar > stdout.log 2> stderr.log

# 或合并到一个文件
start /b "" "%javabin%\java" ^
  ... ^
  -jar start.jar > server.log 2>&1

# 或追加模式（不覆盖）
start /b "" "%javabin%\java" ^
  ... ^
  -jar start.jar >> server.log 2>&1
```

---

## 实用技巧

### 技巧 1：快速停止服务器

```cmd
# 方法 1：使用 taskkill
taskkill /F /IM java.exe

# 方法 2：使用停止端口
.\etc\jdk8\bin\hkjava -DSTOP.PORT=7439 -DSTOP.KEY=secret -jar start.jar --stop

# 方法 3：使用任务管理器
# Ctrl+Shift+Esc -> 找到 java.exe -> 结束任务
```

---

### 技巧 2：查看服务器状态

```cmd
# 检查 Java 进程
tasklist | findstr java.exe

# 检查端口监听
netstat -ano | findstr :7439

# 查看 Java 进程详细信息
wmic process where "name='java.exe'" get ProcessId,CommandLine
```

---

### 技巧 3：多实例运行

```batch
# 修改端口避免冲突
# 实例 1 - 端口 7439
-DSTOP.PORT=7439

# 实例 2 - 端口 7440
-DSTOP.PORT=7440

# 注意：还需修改应用端口（start.jar 的配置）
```

---

### 技巧 4：性能监控

```cmd
# 使用 Windows 性能监视器
perfmon

# 或使用 Java JConsole
.\etc\jdk8\bin\jconsole.exe

# 或使用 JVisualVM
.\etc\jdk8\bin\jvisualvm.exe
```

---

### 技巧 5：创建停止脚本

```batch
REM stop_server.bat
@echo off
echo Stopping Java Server...

REM 使用停止端口
.\etc\jdk8\bin\hkjava -DSTOP.PORT=7439 -DSTOP.KEY=secret -jar start.jar --stop

REM 等待 5 秒
timeout /t 5

REM 强制关闭（如果还在运行）
taskkill /F /FI "WINDOWTITLE eq localServer.bat" /IM cmd.exe 2>nul
taskkill /F /IM java.exe 2>nul

echo Server stopped.
pause
```

---

## 常见场景

### 场景 1：开发环境

```cmd
# 使用显示窗口模式，方便查看输出
localServer_core.bat
```

### 场景 2：生产环境

```cmd
# 使用隐藏窗口 + 日志记录
localServer_advanced.bat

# 定期检查日志
dir logs\
```

### 场景 3：测试环境

```cmd
# 频繁启动停止，使用简单版本
localServer_powershell.bat

# 快速停止
taskkill /F /IM java.exe
```

### 场景 4：演示环境

```cmd
# 使用自动检测版本，确保兼容性
localServer_improved.bat

# 窗口自动隐藏，界面简洁
```

---

## 集成示例

### 与其他工具集成

**集成到 Git Hooks：**
```bash
# .git/hooks/post-merge
#!/bin/sh
cd /c/MyProject
./localServer_improved.bat
```

**集成到 IDE：**
- IntelliJ IDEA: Run -> Edit Configurations -> Add Shell Script
- Eclipse: External Tools -> New -> Configure
- VS Code: tasks.json 配置

---

## 总结

### 推荐使用流程

1. **首次使用：**
   ```
   test_compatibility.bat → localServer_improved.bat
   ```

2. **日常开发：**
   ```
   localServer_core.bat（显示窗口）
   ```

3. **生产部署：**
   ```
   localServer_advanced.bat（日志记录）
   ```

4. **故障排查：**
   ```
   localServer_core.bat + 日志文件
   ```

---

## 相关文档

- [快速开始指南](./QUICK_START.md)
- [完整技术文档](./BAT_SCRIPT_GUIDE.md)
- [故障排查](./BAT_SCRIPT_GUIDE.md#故障排查)
- [索引导航](./INDEX.md)

---

**最后更新：** 2025年  
**版本：** 1.0
