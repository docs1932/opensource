
# 官网以及各种资源
https://code.claude.com/docs/zh-CN/quickstart
https://platform.claude.com/docs/zh-CN/home
https://anthropic.skilljar.com/ (官方课程)

# 1.安装下载
## 1.1 安装下载 Claude Code 客户端
```
# 1.macOS, linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# 2.Windows PowerShell:
irm https://claude.ai/install.ps1 | iex

# 3.npm 方式
npm install -g @anthropic-ai/claude-code@latest
```

## 1.2 配置 claude code: C:\Users\{current user name}\.claude\settings.json
```"hasCompletedOnboarding": true是用于绕过校验的```

```
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api/v1",
    "ANTHROPIC_AUTH_TOKEN": "xxx",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
    "DISABLE_TELEMETRY": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
	"API_TIMEOUT_MS": "60000",
	"ANTHROPIC_MODEL": "qwen/qwen3.6-plus:free"
  },
  "permissions": {
    "allow": [
      "mcp__pencil"
    ]
  },
  "hasCompletedOnboarding": true
}
```

## 1.3 启动 claude
```
如果 启动 claude code 失败, 确定配置没问题之后, 可以尝试先安装下文所述的 ccr, 使用 ccr 首次进入 claude 后, 后续可以使用 claude 了
```

# 2. 安装下载 ccr
### 5.1.1 使用 Claude Code Router 的通用步骤:
```
# 1.安装 Claude Code
确保 claude code 已经安装成功

# 2.安装使用 Claude Code Router（灵活切换模型）
npm install -g @musistudio/claude-code-router

# 3.在你的用户主目录（如 C:\Users\你的用户名）下创建名为 .claude-code-router 的文件夹，并在其中创建 config.json 文件
{
  "Providers": [
    {
      "name": "zhipu",
      "api_base_url": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
      "api_key": "你的API_Key",
      "models": ["glm-4.5-flash"],
      "transformer": {
        "use": ["openrouter"]
      }
    }
  ],
  "Router": {
    "default": "zhipu,glm-4.5-flash"
  }
}

# 4.启动
启动：配置完成后，在终端中通过命令 ccr code 来启动Claude Code

# 5.启动与验证
打开终端，进入你的项目目录。
输入 claude 命令启动（如果使用Router则输入 ccr code 或者 ccr start）。
首次启动可能会让你确认是否使用配置的API Key，选择 Yes 即可。
成功启动后，你可以输入 /status 命令来查看当前连接的模型，确认是否为 glm-4.6。

# 6.如果修改了模型，则需要重启
输入 ccr restart 重启
```

# 3.使用技巧
最佳实践：
https://code.claude.com/docs/zh-CN/best-practices
## 3.1 常用概念
### 3.1.1 claude code 的几种模式
```
使用快捷键 shift + tab 键切换模式：

？for shortcuts --〉 修改前一定询问用户
accept edits on 自动修改文件
plan mode on --》只讨论，不修改文件
```