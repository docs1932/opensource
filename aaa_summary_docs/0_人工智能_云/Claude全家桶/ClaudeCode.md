
# 官网以及各种资源
https://github.com/luongnv89/claude-howto/blob/main/zh/README.md (推荐，已 fork)
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

# 2. 安装下载其他组件
## 2.1 ccr
### 2.1.1 使用 Claude Code Router 的通用步骤:
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

## 2.2 cc switch
https://github.com/farion1231/cc-switch


# 3.使用技巧
最佳实践：
https://code.claude.com/docs/zh-CN/best-practices
## 3.1 常用概念
# 3.1.1 关键命令
```
1.裸奔启动，跳过权限确认，启动参数：
claude --dangerously-skip-permissions

2.恢复历史绘画继续操作
/resume

99.快捷键 Shift + Tab：切换模式，见下文
```

### 3.1.2 claude code 的几种模式
```
1.裸奔启动，跳过权限确认，启动参数：
claude --dangerously-skip-permissions

2.使用快捷键 shift + tab 键切换模式：

？for shortcuts --〉 修改前一定询问用户
accept edits on 自动修改文件
plan mode on --》只讨论，不修改文件
```

## 3.2 skills

## 3.3 subagents

## 3.4 cli
https://github.com/topics/cli

## 3.5 mcp

## 3.6 hooks



# 4.各种推荐

## 4.0 权威推荐
### 4.0.1 MinMax AI skills
https://github.com/MiniMax-AI/skills 

> easy-vibe
https://github.com/datawhalechina/easy-vibe/blob/main/docs-readme/zh-CN/README.md


> 生成视频
https://github.com/heygen-com/hyperframes

> 多 agent 并行
https://github.com/unohee/OpenSwarm

# 4.1  skills 推荐
> 优化 Claude code
https://github.com/forrestchang/andrej-karpathy-skills/blob/main/README.zh.md

> 小而美 ｜ 一人公司 skills https://gumroad.com/
https://github.com/slavingia/skills

> ai 工程团队｜生产力翻倍
https://github.com/garrytan/gstack

> superpowers: agent skills 框架
 

> everything claude code:  claude code 终极优化套件，提升编程效率
https://github.com/affaan-m/everything-claude-code/blob/main/README.zh-CN.md

> deer-flow：超级智能体调度
> 牛马 skills https://github.com/ffanglaili/awesome-niuma-skills

# 4.2 爬虫｜数据采集｜浏览器自动化相关
> 爬虫：firecrawl
Claude code 进入后 --> /plugin --> 选择 firecrawl 即可

> browser-use
https://github.com/browser-use/browser-use

> bb-browser
https://github.com/epiral/bb-browser

> chrome-mcp
https://github.com/ChromeDevTools/chrome-devtools-mcp

> agent-browser
 
> find-skills
 
> skill-creator
 
> summarize
 
> tmux: 终端环境持续控制
 
> testing/e2e
 
> docs/readme
 
> refactor/review
 
> git-workflow