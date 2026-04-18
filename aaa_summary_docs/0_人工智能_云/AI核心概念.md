### 大模型核心概念编号与示例（增强版）

#### 🧠 基础概念

**1. LLM 大模型**（Large Language Model）
> 基于海量数据训练、能理解与生成自然语言的深度学习模型
- 📌 **例子**：Qwen3.6（通义千问）、GPT-4o、Claude 3.5 Sonnet、Llama 3.1、Gemini 1.5 Pro

**2. Token**（词元）
> 大模型处理数据的最基本单元，可以是字、词或子词片段
- 📌 **例子**：
    - 中文："人工|智能" → 2个Token；"大|模|型" → 3个Token
    - 英文："un|believ|able" → 3个Tokens；"hello" → 1个Token
    - 代码：`def calculate_sum(` → 可能拆分为4-5个Tokens

**3. Context**（上下文）
> 大模型每次处理任务时接收到的信息总和，包含历史对话+当前输入
- 📌 **例子**：
    - 多轮对话中，之前5轮问答 + 用户最新问题 = 当前Context
    - 上传一份PDF财报后提问，PDF全文内容 + 问题 = Context

**4. Context Window**（上下文窗口）
> 大模型的 Context 最多能够存储的 Token 量，决定"记忆长度"
- 📌 **例子**：
    - Qwen2.5 / Qwen3系列：支持 128K ~ 1M+ tokens（可处理整本小说或长代码库）
    - GPT-4 Turbo：128K tokens
    - 早期模型（如GPT-3）：4K tokens（仅能记住几段对话）

**5. Prompt**（提示词）
> 用户或系统当前给大模型下达的具体指令或问题
- 📌 **例子**：
    - 简单指令："用三句话总结这篇文章"
    - 结构化Prompt："你是一位资深Python工程师，请审查以下代码并指出潜在Bug..."
    - 思维链Prompt："请一步步思考，先列出大纲，再撰写正文..."

---

#### 🛠️ 工具与智能体（知名案例版）

**6. Tool**（工具）
> 大模型用来感知和影响外部环境的函数，扩展模型能力边界
- 📌 **知名具体例子**：
    - **Code Interpreter (Advanced Data Analysis)**: GPT-4 内置工具，能编写并执行 Python 代码，用于数据分析、画图、格式转换。
    - **Wolfram Alpha**: 强大的计算知识引擎，用于解决复杂的微积分、物理公式推导或查询精确的实时数据（如汇率、人口）。
    - **Google Search / Bing Search API**: 让模型具备联网能力，查询最新的新闻、股价或天气。
    - **DALL-E 3 / Stable Diffusion**: 文生图工具，模型生成提示词后调用此工具绘制图像。
    - **Zapier / IFTTT**: 连接数千个SaaS应用（如发送Slack消息、创建Google日历事件）的自动化工具。

**7. MCP**（Model Context Protocol）
> 统一了工具接入格式的标准协议（由 Anthropic 推出），让不同工具能被大模型标准化调用，类似“USB接口”
- 📌 **知名具体例子**：
    - **Filesystem MCP Server**: 允许模型安全地读取、写入本地文件（如读取项目代码库）。
    - **PostgreSQL / SQLite MCP Server**: 让模型直接通过 SQL 查询数据库，获取业务数据。
    - **GitHub MCP Server**: 让模型能读取仓库代码、提交 Issue 或创建 Pull Request。
    - **Slack MCP Server**: 让模型能读取频道消息、发送通知或总结讨论内容。
    - **Brave Search MCP**: 提供隐私保护的联网搜索能力标准接口。

**8. Agent**（智能体）
> 能自主规划和调用工具、直至解决用户问题的程序，具备"感知-规划-行动-反思"循环
- 📌 **知名具体例子**：
    - **Devin (Cognition AI)**: 被称为“首个AI软件工程师”，能自主接收需求、编写代码、运行测试、修复Bug并部署应用。
    - **AutoGPT**: 早期著名的开源 Agent，给定一个目标（如“研究特斯拉股价并写报告”），它能自主拆解任务、联网搜索、保存文件。
    - **Microsoft AutoGen**: 微软推出的多智能体框架，可以让“程序员Agent”和“测试员Agent”互相对话协作完成开发任务。
    - **Manus**: 最近爆火的通用型 Agent，能自主操作浏览器、使用工具完成复杂的跨平台任务（如订票、做调研）。
    - **LangChain Agents**: 最流行的开发框架，允许开发者快速构建能调用各种 API 的 Agent。

**9. Agent Skill**（智能体技能文档）
> 给 Agent 看的说明文档（通常是结构化数据），描述某个工具"能做什么、参数是什么、返回什么"，Agent 据此决定如何调用
- 📌 **知名具体例子**：
    - **OpenAPI Specification (Swagger JSON)**: 业界标准的 API 文档格式。Agent 读取这个 JSON 文件，就能知道如何调用某个 RESTful API（如天气查询接口）。
    - **Function Calling Schema (JSON Schema)**: 在 GPT-4 或 Qwen 中定义的工具描述。
      ```json
      {
        "name": "get_weather",
        "description": "获取指定城市的当前天气",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string", "description": "城市名，如 Beijing"}
          },
          "required": ["location"]
        }
      }
      ```
    - **LangChain Tool Descriptions**: 在代码中定义的字符串描述，例如 `description="Useful for when you need to answer questions about current events."`。
    - **System Prompt / Few-Shot Examples**: 在提示词中明确写出的技能使用说明，例如：“当你需要计算时，请使用格式 `calc(1+1)`”。

---

### 🔄 概念关系图（实战视角）

```
用户输入 Prompt ("帮我分析下这家公司的财报")
       ↓
   [ LLM 大模型 ] (如 Qwen3.6)
       ↓
   读取 Context (用户上传的 PDF 财报内容)
       ↓
   发现需要外部数据？
       ↓
   查阅 Agent Skill (OpenAPI 文档) -> 发现有一个 "Stock_API" 工具
       ↓
   通过 MCP 协议标准化调用 Tool (Stock_API)
       ↓
   Agent 自主规划：先查股价 -> 再对比财报 -> 最后生成总结
       ↓
   返回最终报告给用户
```

> 💡 **总结**：
> *   **LLM** 是大脑。
> *   **Tool/MCP** 是手脚和感官。
> *   **Agent Skill** 是操作手册。
> *   **Agent** 是拥有大脑、手脚并看得懂操作手册的完整“人”。