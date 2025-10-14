
# 0.项目开发
## 0.1 大纲
```
1.调研分析

2. 开发项目前
2.1 如何写一个需求文档?
2.2 如何编写原型图?
2.3 技术准备
2.4 总结

3. 开发项目中
3.1 前端开发
3.1.1 使用 UI 框架
3.1.2 使用Mock JSON数据
3.2 后端开发
3.2.1 永远先开发登陆功能
3.2.2 基础技术测试 (重要! )
3.2.3 生成 主 CLAUDE.md
3.2.4 单个功能点开发 + 测试 (不要抱有妄念)
3.3 使用Git

4. 开发完成项目
4.1 环境区分
4.2 MetaData
4.3 数据埋点
```

# 1.VSCode 插件
## 1.1 cline
## 1.2 Roo Code

# 2.Calude Code
https://github.com/LichAmnesia/GPT-Prompt-Hub (Prompt 提示词配置在这里)
```
项目分析
创建工程
增加功能
修改功能
性能优化
```

## 2.1 下载安装配置

## 2.2 常用命令
### 2.2.1 交互模式下，输入 claude (ccr code) 启动交互模式：
```
1./resume
可以找回之前的对话。

2.ESC 键 (或者 Ctrl + C)：
中断执行

3./exit: 
退出

4./clear:
如果需要清空当前会话，请输入 clear 命令。
最好在开启新项目之前，执行该命令，以免错误运行。

5./init:
如果是已有项目，则在下载完项目之后，直接在项目目录下执行 init 命令，可以生成项目的说明。

6./help:
显示所有可用命令。

7./compact[instructions]
压缩对话内容，并以摘要作为新的对话的开场上下文。
instructions 参数允许你指定压缩时的侧重点，例如：
/compact"保留尚未解决的问题"会让 claude 在总结时侧重未解决的问题。
使用场景：
当会话长度接近模型上下文长度限制时，请考虑使用 /compact 命令。

8./memory:
编辑会话记忆文件。

9./status:
显示当前 claude 的运行状态。

10.加大 AI 思考的长度：
/think
/think hard
/think harder
/ultrathink

11.在 claude 窗口中输入 ! 可以执行一些临时命令，例如： npm install xxx

12.在 claude 窗口中输入 # 将进入记忆模式，可以选择项目的记忆位置，是项目级别或者用户级别

13./ide
在 vscode 中安装 Claude Code 插件，然后在 claude code 中输入 /ide 可以将 vscode 和 claude code 关联起来。
>> 此时如果在 vscode 中选中部分代码，claude code 是可以感知到的。
>> 如果 claude code 修改了代码，在 vscode 中会弹出一个页面，弹出修改前后的差异。


99.自然语言：
请读取当前项目下文件，并分析项目结构，并给出项目结构图。

```

### 2.2.2 非交互模式
```
claude (ccr code) -p "今天几号了"
```

### 2.2.3 安装使用 MCP
```

```

### 2.2.4 几种模式
```
Claude Code 主要有以下几种模式：

1.Chat 模式（默认模式）
用于一般对话和问答
直接输入消息即可

2.Plan 模式
用于规划和设计复杂任务
Claude 会先制定详细计划,征得你同意后再执行

3.Code 模式
直接编码模式
快速编写和修改代码
======================================================
进入 Plan 模式的方法
有几种方式可以进入 Plan 模式：
方法 1：使用命令
claude code plan
方法 2：在对话中切换
在任何时候输入：
/plan
方法 3：启动时指定
claude code --mode plan
方法 4：在消息中明确请求
直接告诉 Claude 你想要一个计划，例如：
请为我制定一个构建 XXX 功能的计划

模式特点
Plan 模式特别适合：
大型项目重构
复杂功能实现
需要多步骤的任务
希望先审查方案再执行

在 Plan 模式下，Claude 会：
分析你的需求
制定详细的步骤计划
等待你确认
逐步执行计划

```



# 3.Codex

# 4.Kiro

# 5.智谱清言 (GLM)
## 5.1 在 claude 中使用 GLM
### 5.1.1 使用 Claude Code Router 的通用步骤:
```
# 1.安装 Claude Code
npm install -g @anthropic-ai/claude-code

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

### 5.1.2 使用技巧与注意事项
```
解决网络工具问题：
Claude Code原生的网页搜索和抓取工具在国内可能无法使用。
你可以通过配置MCP（Model Context Protocol）服务器来使用智谱提供的替代工具，
如 web-search-prime 和 chrome-devtools，以恢复联网检索和网页内容获取能力。

常用命令：
/init：让AI了解整个项目结构，非常有用。
/clear：清除当前对话上下文。
按 Alt + M 可以切换任务模式，如在需要人工确认的默认模式和自动执行的accept edits模式间切换。

故障排除：
端口占用：
Claude Code默认使用3456端口，如果冲突，可以通过修改 ~/.claude/settings.json 文件中的 CLAUDE_CODE_PORT 配置来更改端口。

服务启动失败：
如果遇到服务启动问题，可以尝试先执行 ccr start，再执行 ccr code。
```


### 5.1.3 模型切换 glm-4.6
```
{
  "Providers": [
    {
      "name": "zhipu",
      "api_base_url": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
      "api_key": "你的API_Key",
      "models": ["glm-4.6"],
      "transformer": {
        "use": ["openrouter"]
      }
    }
  ],
  "Router": {
    "default": "zhipu,glm-4.6"
  }
}
```

### 5.1.4 配置 claude code
```
1.在项目工程目录下创建文件夹 .claude，并创建 config.json 文件，可以添加以下内容：
{
  "model": "claude-3-5-sonnet-20241022",
  "max_tokens": 4000,
  "temperature": 0.7,
  "auto_approve": false,
  "git_integration": true,
  "excluded_files": [
    "node_modules/**",
    ".git/**",
    "*.log",
    "dist/**"
  ],
  "language_preferences": {
    "documentation": "zh-CN",
    "code_comments": "zh-CN"
  }
}
```


# 5.qwen-code (阿里)
https://platform.iflow.cn/cli/quickstart (心流)



https://qwenlm.github.io/qwen-code-docs/zh/
https://qoder.com/ (先不要用这个)

# 100.spec kit (vibe coding 已拜拜)
## 100.1 github spec kit
https://github.com/github/spec-kit
```
1.  掌握什么是 **SDD (规范文档驱动开发)** ？
2.  **spec-kit** 开发的流程和相关命令
3.  **spec-kit** 的优势和劣势是什么？
4.  基于 **Echarts + Qwen3 Max Preview** 这个模型，使用 **spec-kit** 的开发流程，开发一个 **AI 图表生成工具**

spec-kit
/constitution : 生成宪章 constitution.md
/specify : 生成规范文档 spec.md
/plan: 生成技术相关的文档
/tasks : 生成本次要执行的一系列任务 task.md
/implement: 执行刚才的任务


总结一下: 
对于大型的复杂项目，我们通常会按照以下步骤进行开发(2-5步会循环往复的执行).
优点：用一套框架对齐需求，减少遗漏
缺点：对于 spec 的要求很高，很慢

/constitution : 立规矩，定原则。

# 第一次提需求，会生成对应的分支1
/specify : 写规范，讲清楚做什么。
/clarify: AI 主动问 5 个关键问题 (可选)
/plan : 出技术方案，设计怎么做，可以指出技术栈等。
/tasks : 拆任务，形成可执行步骤。
/analyze : 检查一致性。(如果有不一致的地方，可以让 AI 修复) (可选)
/clear : 由于上述步骤产生了非常多的上下文，此处可以 clear 掉 (可选)
/implement : 动手术，让代码落地。

# 第2次提需求，会生成对应的分支2
/specify : 写规范，讲清楚做什么。
/clarify: AI 主动问 5 个关键问题 (可选)
/plan : 出技术方案，设计怎么做，可以指出技术栈等。
/tasks : 拆任务，形成可执行步骤。
/analyze : 检查一致性。(如果有不一致的地方，可以让 AI 修复) (可选)
/clear : 由于上述步骤产生了非常多的上下文，此处可以 clear 掉 (可选)
/implement : 动手术，让代码落地。

# 第3次提需求，会生成对应的分支3
/specify : 写规范，讲清楚做什么。
/clarify: AI 主动问 5 个关键问题 (可选)
/plan : 出技术方案，设计怎么做，可以指出技术栈等。
/tasks : 拆任务，形成可执行步骤。
/analyze : 检查一致性。(如果有不一致的地方，可以让 AI 修复) (可选)
/clear : 由于上述步骤产生了非常多的上下文，此处可以 clear 掉 (可选)
/implement : 动手术，让代码落地。
```

# 999.其他: trae, cursor, windsurf
