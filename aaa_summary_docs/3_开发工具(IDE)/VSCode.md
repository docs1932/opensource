
# 1. 下载安装

# 2. 快捷键 (windows)
```
进入到某个文件的源码中：F12
全局搜索代码：CTRL + SHIFT + F
打开右侧侧边栏：CTRL + SHIFT + I
打开控制台: CTRL + ` (位于键盘左上角的波浪号那里) 
搜索文件: CTRL + P  （此时可以输入文件名搜索文件）
折叠所有代码: CTRL + 0 
快速移动光标到某一行：CTRL + G (然后输入对应的行号即可) (这个等价于 CTRL + P 然后手动输入冒号 : )
光标回到上一步:  ALT +  左箭头 或者 CTRL + PgUp ( + Fn)
光标回到下一步:  ALT +  右箭头 或者 CTRL + PgDn ( + Fn)
选中所有符合条件的单词：光标先选中某个单词，然后 CTRL + F2
选中某个符合条件的单词：CTRL + D
格式化代码： Shift + ALT + F

debug 相关：
    继续(F5)
    单步跳过(F10)
    单步调试(F11)
    单步跳出(Shift + F11)
    重启(Ctrl + Shift + F5 )
    停止/结束(Shift + F5)
```

# 3.插件
## 3.1 AI related
### 3.1.1 cline
https://github.com/cline/cline/blob/main/locales/zh-cn/README.md
```
cline 安装后默认在侧边栏的左右，可以选中 cline 按钮然后拖动到右侧的侧边栏.

免费模型：
即使是免费模型，也可能会设置使用限额，比如每分钟请求次数限制等。
```

#### 3.1.1.0 cline 支持收费模型：DeepSeek

#### 3.1.1.1 cline 支持免费模型：OpenRouter
```
在 cline 上，点击 --> 设置按钮：
API Configuration -->
API Provider --> 选择 OpenRouter (首次进行会需要填写 API Key) 
Model --> 选择 deepseek/deepseek-chat:free (可以搜索 free)
```
https://openrouter.ai/

#### 3.1.1.2 cline 支持免费模型：Gemini 
```
有额度限制
```
#### 3.1.1.3 cline 支持免费模型：Hugging Face
```
在 Hugging Face 的 models 专栏选择在提供服务状态的模型即可
```
https://huggingface.co/models

#### 3.1.1.3 cline 支持免费模型：Ollama
#### 3.1.1.4 cline 支持免费模型：Claude
#### 3.1.1.5 cline 支持免费模型：Cline

## 3.2 python related 
```可以在右下角选择 python 版本号来调整 python 环境```

### 3.2.1 python
### 3.2.2 pylance
### 3.2.3 jupyter
### 3.2.4 ruff (代码检查)

## 3.3 java related

## 3.4 通用
### 3.4.1 Error Lens (代码错误显示)

### 3.4.2 Code Runner
```
安装之后，在源码文件右键 --> Run Code 即可
```

## 3.5 主题 (theme 相关)
```
GitHub Theme
vscode icons
```

## 3.6 scss/sass 插件
```
选择：
Live Sass Compiler (Glenn Marks)

设置：
https://github.com/glenn2223/vscode-live-sass-compiler/blob/HEAD/docs/settings.md
```

# 4.设置：左下角齿轮图标 -->
## 4.1 settings (user 表示全局设置，workspace 表示当前工作区设置)
```
用户设置（User Settings）
    ‌适用范围‌：所有工作区和项目
    ‌存储位置‌：用户目录下（如Windows系统通常位于%USERPROFILE%\AppData\Local\Programs\Microsoft VS Code\User Settings）
    ‌特点‌：用于配置编辑器主题、字体大小、格式化程序等全局偏好设置，适用于所有打开的项目。

工作区设置（Workspace Settings）
    ‌适用范围‌：仅当前工作区/项目
    ‌存储位置‌：项目目录下的.vscode/settings.json文件
    ‌特点‌：用于定制特定项目的编译配置、代码格式规则等设置，可覆盖全局设置。例如，不同项目可能使用不同版本的编译器或格式化工具。
```

### 4.1.1 设置打开文件过多时，分行展示
```
Workbench > Editor > Wrap Tabs: 打钩即可
```

### 4.1.2 设置字体大小
```
搜索 font size: 设置即可
```

### 4.1.3 左侧 tab 字体大小
```
ctrl+shift+p > Preferences: Open User Settings (JSON) > 

"editor.fontSize": 18,
"window.zoomLevel": 1.8,
```

# 5.debug
## 5.1 前端代码 debug
```
1.开启源代码模式
如果是 ts 代码，则可以在 ts.config 中将 sourceMap 配置成 true
如果是 angular 代码，则可以在 angular.json 中将 sourceMap 配置成 true (默认就是 true)
2.然后发布到浏览器，F12 --> sources --> 找到对应的源码文件 --> 加断点即可
```