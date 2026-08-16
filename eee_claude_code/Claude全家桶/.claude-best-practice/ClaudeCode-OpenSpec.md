# OpenSpec
https://github.com/Fission-AI/OpenSpec (轻量级)
https://zhuanlan.zhihu.com/p/2019708946743608658
https://github.com/ForceInjection/OpenSpec-practise/blob/main/docs/openspec-user-manual.md

# 使用示例
https://cloud.tencent.com/developer/article/2669086



# 1.安装
```
# 1.安装/更新 OpenSpec
npm install -g @fission-ai/openspec@latest

# 2.更新 OpenSpec
openspec update

cd your-project
openspec init
```

## 1.1 默认模式
```
/opsx:propose ──► /opsx:apply ──► /opsx:sync ──► /opsx:archive
```

## 1.2 扩展模式
```
openspec config profile
openspec update
```

# 2.常用命令
```
1.init
cd your-project
openspec init

2.刷新代理指令
在每个项目中运行此命令，以重新生成 AI 指导并确保最新的斜杠命令处于活动状态：
openspec update


```

https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md