
# 1.概述

## 1.99 版本管理工具 (uv, poetry, PDM, pip, pip3)

```
原始的样子：
1.创建虚拟环境
python -m venv .venv
2.激活虚拟环境
source .venv/bin/activate
3.编辑依赖配置文件
edit pyproject.toml
4.安装依赖
pip install -e .
```

### 1.99.1 uv (热度较高)
https://docs.astral.sh/uv/
```
1.windows 上安装 uv
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
一般安装在 
C:\Users\{your username}\.local\bin
2.Upgrading uv
uv self update
3.Uninstallation
3.1 Clean up stored data (optional):
uv cache clean
rm -r "$(uv python dir)"
rm -r "$(uv tool dir)"
3.2 Remove the uv and uvx binaries:
rm $HOME\.local\bin\uv.exe
rm $HOME\.local\bin\uvx.exe
```

#### 1.99.1.1 拿到一个基于 uv 创建的工程，该如何创建环境呢？
```
1.进入项目目录下，执行下述命令即可
uv sync
2.运行虚拟环境中的主程序，执行下述命令即可
uv run main.py
(传统模式，需要先激活环境：source .venv/bin/activate, 然后运行程序：python main.py)
```

#### 1.99.1.2 使用 uv 创建一个工程
https://github.com/modelcontextprotocol/python-sdk
```
1.安装指定版本的 python
 uv python install 3.13 
 或者
 uv python install 3.13 --directory D:\software\python\3.13\python
2.切换到工程目录
CD D:\0000_AI\MCP\MCP_servers\zx_mcp_server_1
3.初始化环境
uv init . -p 3.13
4.安装 mcp 的 sdk 安装上 (uv add 会安装依赖，并检查创建虚拟环境)
uv add "mcp[cli]"
5.使用 vscode/pycharm 打开工程目录
---------------------------------------------
```

方案1，写一个基于 stdio 协议的 mcp server--------------------------------------------------------------------
```
1.main.py
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

2.mcp 配置，打开 cline 插件，配置：
{
  "mcpServers": {
    "zx_mcp_server_1": {
      "disabled": false,
      "timeout": 60,
      "type": "stdio",
      "registryUrl": "",
      "command": "uv",
      "args": [
        "--directory",
        "D:\\0000_AI\\MCP\\MCP_servers\\zx_mcp_server_1",
        "run",
        "main.py"
      ]
    }
  }
}

3.重启 VSCode 即可
4.输入指令，例如：将可以在对话框中看到使用了我们的自定义 mcp server
计算 25+65的值
```
--------------------------------------------------------------------

方案2，写一个基于 sse 协议的 mcp server--------------------------------------------------------------------
```
1.需要将上面 main.py 脚本的 main 函数改成
if __name__ == "__main__":
    # 写一个 stdio 协议的 mcp server，本地调用
    mcp.run(transport='sse')
2.启动 main.py
VSCode 右上角的启动按钮点击一下即可
3.复制启动后监听的地址
http://127.0.0.1:8000
4.添加 mcp server
{
  "mcpServers": {
    "zx_mcp_server_2": {
      "url": "http://127.0.0.1:8000/sse",
      "type": "sse",
      "disabled": false
    }
  }
}
5.输入指令，例如：将可以在对话框中看到使用了我们的自定义 mcp server
计算 25+65 的值
```

方案3，写一个基于 streamable http 协议的 mcp server--------------------------------------------------------------------
```
1.需要将上面 main.py 脚本的 main 函数改成
if __name__ == "__main__":
    # 写一个 streamable http 协议的 mcp server，本地调用
    mcp.run(transport='streamable-http')
2.启动 main.py
VSCode 右上角的启动按钮点击一下即可
3.复制启动后监听的地址
http://127.0.0.1:8000
4.添加 mcp server
{
  "mcpServers": {
    "zx_mcp_server_3": {
      "url": "http://127.0.0.1:8000/mcp",
      "type": "streamableHttp",
      "disabled": false
    }
  }
}
5.输入指令，例如：将可以在对话框中看到使用了我们的自定义 mcp server
计算 25+65 的值
```
#### 1.99.1.3 打包运行一个工程
```
1.在 project.toml 中添加

[project.scripts]
zx = "my_mcp:main"

2.然后执行 uv build 就会生成一个 whl 文件，该文件上传到 python 的软件仓库 pypi，其他人就可以使用了
D:\0000_AI\MCP\MCP_servers\zx_mcp_server_1\dist\zx_mcp_server_1-0.1.0-py3-none-any.whl

3.也可以本地使用一下试试
uv tool install D:\0000_AI\MCP\MCP_servers\zx_mcp_server_1\dist\zx_mcp_server_1-0.1.0-py3-none-any.whl
```

# 2.想要运行一个 python 程序，通常要解决 2 个问题
## 2.1 确定 python 版本
### 2.1.1 假定使用 uv 管理依赖
```
1.使用 uv python list 打印 uv 支持的所有 python 版本
2.使用 uv 安装特定版本的 python
uv python install cpython-3.12
3. 使用指定版本的 python 运行一个程序
uv run -p 3.12 ai.py
4.使用交互界面 运行一个程序
uv run -p 3.12 python --> 然后 python ai.py

```

## 2.2 解决 python 依赖