
# 1.概述

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