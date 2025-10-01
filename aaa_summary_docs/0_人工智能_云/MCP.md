# 1.什么是MCP
```
MCP概念
MCP（Model Context Protocol，模型上下文协议）是由 Anthropic 提出并于 2024 年 11 月开源的一种通信协议，旨在解决大型语言模型（LLM）与外部数据源及工具之间无缝集成的需求。

它通过标准化 AI 系统与数据源的交互方式，帮助模型获取更丰富的上下文信息，从而生成更准确、更相关的响应。
```
https://modelcontextprotocol.io/introduction

# 2.使用现有 MCP Servers
```
GitHub：在 GitHub 上查找 MCP servers：

https://github.com/modelcontextprotocol/servers
https://github.com/punkpeye/awesome-mcp-servers

网站：通过下面的网站查找 MCP servers：


https://smithery.ai/
https://mcpservers.org
https://mcp.so
https://glama.ai/mcp/servers
https://www.pulsemcp.com/
UI自动化相关的 MCP servers

playwright: https://github.com/executeautomation/mcp-playwright
browserbase: https://github.com/browserbase/mcp-server-browserbase
puppeteer https://github.com/modelcontextprotocol/servers/tree/HEAD/src/puppeteer
```

# 2.1 browser-tools-mcp
https://github.com/AgentDeskAI/browser-tools-mcp

```
{
  "mcpServers": {
    "browser-tools-mcp":{
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "@agentdeskai/browser-tools-mcp@latest",
        "D:\\0000_AI\\MCP\\MCP_servers\\browser-tools-mcp"
      ]
    }
  }
}
```

# 3.写个 mcp server 并发布到公网
## 3.1 写一个基于 stdio 协议的 mcp server，并发布到 pypi 上
### 3.1.1 创建一个 mcp server
``` 创建工程 ```
```
1.安装指定版本的 python
 uv python install 3.13
2.切换到工程目录
CD D:\0000_AI\MCP\MCP_servers\zx_mcp_server_1
3.初始化环境
uv init . -p 3.13
4.安装 mcp 的 sdk 安装上
uv add "mcp[cli]"
5.使用 vscode/pycharm 打开工程目录
```

``` main.py 文件 ```
```
# server.py
from mcp.server.fastmcp import FastMCP

# Create an MCP server
mcp = FastMCP("Demo")


# Add an addition tool
@mcp.tool()
def sum(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b


# Add a dynamic greeting resource，，类似于GET 方法，只读数据
@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    """Get a personalized greeting"""
    return f"Hello, {name}!"

if __name__ == "__main__":
    # 写一个 stdio 协议的 mcp server，本地调用
    mcp.run(transport='stdio')
```

### 3.1.2 注册 pypi 账号
https://pypi.org/

https://www.cnblogs.com/fnng/p/18744210


# 4.常用的 MCP
```
chrome mcp

```