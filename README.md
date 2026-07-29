# AutoMCServerBat

一个面向 Windows 的 Minecraft Java 版服务端一键启动脚本。脚本会检查 Java 环境、读取系统可用内存、自动计算服务端最大内存，并使用整理过的彩色控制台界面启动服务器。

推荐使用最新版：[MC一键启动 V1.6.bat](./MC一键启动%20V1.6.bat)。

## 主要功能

- 自动请求管理员权限，并检查 Java 运行环境。
- 自动读取可用内存并计算服务端最大分配内存。
- 支持自定义服务端核心、Java 路径和额外启动参数。
- 提供分阶段的彩色中文提示、安全停服提醒和退出代码。
- 兼容新版 Windows，并保留传统中文命令提示符支持。

## 使用方法

1. 下载 `MC一键启动 V1.6.bat`，放到 Minecraft 服务端目录。
2. 将服务端核心命名为 `server.jar`，或者修改脚本中的 `serverjar` 变量。
3. 双击运行脚本，并在 Windows UAC 窗口中允许管理员权限。
4. 确认脚本显示的 Java、内存和启动参数，按任意键启动服务器。
5. 第一次启动后，根据 Minecraft 服务端提示阅读并接受 EULA。
6. 需要关闭服务器时，在服务端控制台输入 `stop`，不要直接关闭窗口。

## 可配置变量

在 V1.6 脚本顶部可以修改以下变量：

| 变量 | 默认值 | 作用 |
| --- | --- | --- |
| `serverjar` | `server.jar` | Minecraft 服务端核心文件名 |
| `minram` | `512` | Java 最小堆内存，即 `-Xms`，单位 MB |
| `extra` | 空 | 额外的 JVM 或服务端启动参数 |
| `sysram` | `768` | 为 Windows 和其他程序保留的内存，单位 MB |
| `useJava` | `java` | Java 命令或 `java.exe` 的完整路径 |

自定义 Java 路径示例：

```bat
set useJava="C:\Program Files\Java\jdk-21\bin\java.exe"
```

添加额外 JVM 参数示例：

```bat
set extra=-XX:+UseG1GC
```

实际启动命令形式如下：

```text
java -Xms<最小内存>M -Xmx<自动计算的最大内存>M <额外参数> -jar <服务端核心>
```

## 运行要求

- Windows 10、Windows 11 或 Windows Server。
- 与服务端核心版本匹配的 Java。现代 Minecraft 服务端通常需要较新的 Java，请以对应服务端核心的说明为准。
- 足够的可用内存。脚本计算方式为：

```text
最大分配内存 = 当前可用内存 - 系统保留内存
```

如果计算出的最大内存不足，请关闭其他程序、增加物理内存，或者调整 `sysram`；不要把系统保留内存设置得过低。

## 服务器服务商

如果需要部署长期运行的 Minecraft 服务器，可以了解糖糕云：

<p>
  <a href="https://www.tanggaoyun.com/aff/dream">
    <img src="https://www.tanggaoyun.com/themes/web/candycake/assets/img/logo.png" alt="糖糕云 Logo" height="48">
  </a>
  &nbsp;&nbsp;
  <a href="https://www.tanggaoyun.com/aff/dream"><strong>糖糕云</strong></a>
</p>

[前往糖糕云](https://www.tanggaoyun.com/aff/dream)

> 以上链接为推广链接，通过该链接访问或购买可能会为项目作者带来推广收益。

## 常见问题

### 双击脚本后出现 UAC 窗口

这是脚本请求管理员权限的正常行为。V1.6 已使用 PowerShell 提权，避免旧版 `mshta` 方案在新版 Windows 上失败。

### 提示找不到 Java

请先安装服务端核心要求的 Java 版本，并确认 `java -version` 可以在命令提示符中执行；也可以通过 `useJava` 变量直接指定 `java.exe`。

### WMIC 不可用

新版 Windows 可能不再默认安装 WMIC。脚本会自动改用 PowerShell 的 `Get-CimInstance` 获取内存信息。

### 如何安全关闭服务器

在控制台输入：

```text
stop
```

等待服务端完成世界和玩家数据保存后再关闭窗口。

## 历史版本

仓库中保留了 V1.1 至 V1.5 等历史脚本，主要用于版本对比和兼容性参考。新部署建议使用 V1.6。

