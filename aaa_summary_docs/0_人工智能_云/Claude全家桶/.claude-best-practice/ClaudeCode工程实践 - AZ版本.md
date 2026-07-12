# 1.资源
https://github.com/shanraisshan/claude-code-best-practice#how-to-use
https://code.claude.com/docs/zh-CN/best-practices
https://code.claude.com/docs/zh-CN/permission-modes
https://code.claude.com/docs/zh-CN/permissions
https://code.claude.com/docs/zh-CN/sandboxing
https://code.claude.com/docs/zh-CN/features-overview#match-features-to-your-goal

# 2.最佳实践
## 2.1 安全先行
### 2.1.1 开启全局 sandbox 模式，并配置权限 
### (注意如果使用 cc switch 切换后，可能被覆盖，需要重新配置)
参考 aaa_summary_docs/0_人工智能_云/Claude全家桶/.claude/settings.json

## 2.2 使用非 claude 模型时，配置联网搜索功能

## 2.3 写好 CLAUDE.md 文件

## 2.4 安装 skills
```
> find-skills

> skill-creator

> summarize
 
> tmux: 终端环境持续控制
 
> testing/e2e
 
> docs/readme
 
> refactor/review
 
> git-workflow

> Context7

> docker-expert

> postgresql/spring-boot/minio 等等

```

## 2.5 配置 mcp
```
如：连接 github, 连接 jira, 操作浏览器
连接本地/远程数据库等
```

## 2.6 配置 cli

## 2.7 配置 subagents

## 2.8 关注额度

## 2.9 配置各种语言
### 2.9.1 配置强制使用 uv 来管理 python 命令
https://pydevtools.com/handbook/how-to/how-to-configure-claude-code-to-use-uv/
参考下述文件，这里可以放到用户目录下，全局生效：
aaa_summary_docs/0_人工智能_云/Claude全家桶/.claude/CLAUDE.md


# 49. Spec 驱动编程
Claude code 的 dynamic workflow
https://github.com/Fission-AI/OpenSpec (轻量级)
https://github.com/github/spec-kit (工程级)


# 50.配置 claude code 使用 uv
https://pydevtools.com/handbook/how-to/how-to-configure-claude-code-to-use-uv/