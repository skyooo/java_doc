# 快速开始指南

## 🚀 5 秒钟选择方案

### 方案选择流程图

```
开始
  │
  ├─ 你的系统是 Windows 7 SP1 及以上吗？
  │   ├─ 是 → 使用 localServer_improved.bat ✅ [推荐]
  │   └─ 否 → 使用 localServer_launcher.vbs
  │
  └─ 确定有 PowerShell 吗？
      ├─ 是 → 使用 localServer_powershell.bat
      └─ 不确定 → 使用 localServer_improved.bat ✅ [推荐]
```

---

## 📁 文件清单

| 文件名 | 用途 | 推荐度 |
|--------|------|--------|
| `localServer_improved.bat` | 自动检测版本（单文件） | ⭐⭐⭐⭐⭐ |
| `localServer_powershell.bat` | 纯 PowerShell 版本 | ⭐⭐⭐⭐ |
| `localServer_launcher.vbs` | VBScript 启动器 | ⭐⭐⭐ |
| `localServer_core.bat` | 核心逻辑（配合 VBS 使用） | ⭐⭐⭐ |
| `BAT_SCRIPT_GUIDE.md` | 完整技术文档 | 📖 |
| `QUICK_START.md` | 快速开始指南 | 📖 |

---

## ⚡ 使用方法

### 方案1：自动检测（推荐）
```cmd
双击运行：localServer_improved.bat
```

### 方案2：PowerShell
```cmd
双击运行：localServer_powershell.bat
```

### 方案3：VBScript
```cmd
双击运行：localServer_launcher.vbs
```

---

## 🆚 原始脚本 vs 改进脚本

| 特性 | 原始脚本 | 改进脚本 |
|------|---------|---------|
| 隐藏窗口方法 | mshta | PowerShell / VBScript |
| Win7 支持 | ✅ | ✅ |
| Win10 支持 | ✅ | ✅ |
| Win11 支持 | ❌ 不稳定 | ✅ 完全支持 |
| 自动降级 | ❌ | ✅ |
| 错误处理 | ❌ | ✅ |
| 代码注释 | 少量 | 详细 |

---

## ❓ 常见问题

### Q1: 我应该使用哪个脚本？
**A:** 大多数情况下，使用 `localServer_improved.bat` 即可。

### Q2: 如何查看服务器运行状态？
**A:** 使用任务管理器查找 `java.exe` 进程。

### Q3: 如何停止服务器？
**A:** 使用任务管理器结束 `java.exe` 进程。

### Q4: 窗口没有隐藏怎么办？
**A:** 检查 PowerShell 是否可用：
```cmd
where powershell.exe
```

### Q5: 如何调试脚本？
**A:** 运行 `localServer_core.bat`（显示窗口模式）。

---

## 🔧 快速修复

### 问题：服务启动失败

**检查清单：**
```cmd
# 1. 检查 Java 是否存在
dir .\etc\jdk8\bin\java.exe

# 2. 检查 start.jar 是否存在
dir start.jar

# 3. 检查端口是否被占用
netstat -ano | findstr 7439

# 4. 手动启动测试
.\etc\jdk8\bin\java -version
```

### 问题：PowerShell 被禁用

**解决方法：**
```cmd
# 使用 VBScript 方案
双击运行：localServer_launcher.vbs
```

---

## 📖 更多信息

详细技术文档请参考：`BAT_SCRIPT_GUIDE.md`

---

**提示：** 首次使用建议阅读 `BAT_SCRIPT_GUIDE.md` 了解详细原理。
