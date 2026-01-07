@echo off
REM ========================================================================
REM Windows 兼容性测试脚本
REM ========================================================================
REM 
REM 功能：测试 PowerShell 和 VBScript 的可用性
REM 用途：帮助用户选择最合适的启动脚本方案
REM 
REM ========================================================================

echo ========================================================================
echo Windows 隐藏窗口方案兼容性测试
echo ========================================================================
echo.

REM 获取 Windows 版本
echo [1/5] 检测 Windows 版本...
ver
echo.

REM 检查 PowerShell
echo [2/5] 检测 PowerShell...
where powershell.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] PowerShell 可用
    powershell -Command "$PSVersionTable.PSVersion" 2>nul
) else (
    echo [✗] PowerShell 不可用
)
echo.

REM 检查 VBScript (cscript)
echo [3/5] 检测 VBScript (cscript)...
where cscript.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] VBScript (cscript) 可用
    cscript //nologo //h:version 2>nul
) else (
    echo [✗] VBScript (cscript) 不可用
)
echo.

REM 检查 VBScript (wscript)
echo [4/5] 检测 VBScript (wscript)...
where wscript.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] VBScript (wscript) 可用
) else (
    echo [✗] VBScript (wscript) 不可用
)
echo.

REM 检查 mshta（仅供参考）
echo [5/5] 检测 mshta（仅供参考）...
where mshta.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] mshta 可用（但不推荐使用）
) else (
    echo [✗] mshta 不可用或已被禁用
)
echo.

REM 推荐方案
echo ========================================================================
echo 推荐方案
echo ========================================================================
echo.

where powershell.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [推荐] 使用 localServer_improved.bat 或 localServer_powershell.bat
    echo [原因] 您的系统支持 PowerShell，这是最稳定的方案
) else (
    where cscript.exe >nul 2>&1
    if %errorlevel% equ 0 (
        echo [推荐] 使用 localServer_launcher.vbs + localServer_core.bat
        echo [原因] 您的系统不支持 PowerShell，但支持 VBScript
    ) else (
        echo [警告] 您的系统可能不支持任何隐藏窗口方案
        echo [建议] 直接运行 localServer_core.bat（会显示窗口）
    )
)
echo.

echo ========================================================================
echo 测试完成
echo ========================================================================
pause
