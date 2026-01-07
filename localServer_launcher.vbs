' ========================================================================
' Windows 服务器启动脚本 - VBScript 启动器
' ========================================================================
' 
' 功能：隐藏窗口启动 localServer_core.bat
' 兼容：Windows 7 - Windows 11 全系统
' 优点：不依赖 mshta 和 PowerShell，最大兼容性
' 
' 使用方法：
'   双击此 .vbs 文件，或使用命令行：
'   wscript localServer_launcher.vbs
'   cscript //nologo localServer_launcher.vbs
' 
' ========================================================================

Option Explicit

Dim objShell, scriptPath, batPath
Set objShell = CreateObject("WScript.Shell")

' 获取当前脚本所在目录
scriptPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

' 构建 BAT 文件路径
batPath = scriptPath & "\localServer_core.bat"

' 检查 BAT 文件是否存在
If Not CreateObject("Scripting.FileSystemObject").FileExists(batPath) Then
    MsgBox "错误：未找到 localServer_core.bat" & vbCrLf & _
           "路径：" & batPath, vbCritical, "启动失败"
    WScript.Quit 1
End If

' 隐藏窗口启动 BAT 脚本
' 参数说明：
'   - 第1个参数：要执行的命令
'   - 第2个参数：窗口样式（0 = 隐藏）
'   - 第3个参数：是否等待执行完成（False = 不等待）
objShell.Run """" & batPath & """", 0, False

' 提示用户服务器正在启动（可选，可注释掉）
' MsgBox "服务器正在后台启动中...", vbInformation, "提示"

Set objShell = Nothing
