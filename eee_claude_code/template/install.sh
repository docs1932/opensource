#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# Claude Code 交付流水线模板 · 一键拷贝脚本
#
# 用法：
#   cd 你的新工程根目录
#   bash /path/to/eee_claude_code/template/install.sh
#
# 作用：把"复制即用"的通用部分拷进当前工程；
#       需要手动改的部分，脚本末尾会给出提示。
# ═══════════════════════════════════════════════════════════
set -e

TPL="$(cd "$(dirname "$0")" && pwd)"          # 模板根目录
DEST="$(pwd)"                                   # 目标工程（当前目录）

echo "模板目录: $TPL"
echo "目标工程: $DEST"

mkdir -p "$DEST"/.claude/commands "$DEST"/.claude/skills \
         "$DEST"/.github/prompts "$DEST"/.github/skills "$DEST"/.github/workflows \
         "$DEST"/openspec/changes/archive "$DEST"/openspec/specs

cp -r "$TPL"/.claude/commands/opsx              "$DEST"/.claude/commands/
cp -r "$TPL"/.claude/skills/openspec-*          "$DEST"/.claude/skills/
cp -r "$TPL"/.claude/skills/doc-verify          "$DEST"/.claude/skills/
cp -r "$TPL"/.claude/skills/custom-claude-template-dev-workflow     "$DEST"/.claude/skills/
cp -r "$TPL"/.claude/skills/custom-claude-template-prod-workflow   "$DEST"/.claude/skills/
cp     "$TPL"/.claude/settings.json             "$DEST"/.claude/settings.json
cp     "$TPL"/.github/prompts/*.md              "$DEST"/.github/prompts/
cp -r  "$TPL"/.github/skills/openspec-*         "$DEST"/.github/skills/
cp     "$TPL"/.github/workflows/*.yml           "$DEST"/.github/workflows/
cp     "$TPL"/openspec/config.yaml              "$DEST"/openspec/

echo ""
echo "✅ 已拷贝通用部分："
echo "   .claude/commands/opsx/        (9 个 /opsx 命令)"
echo "   .claude/skills/openspec-*/    (9 个 openspec skill)"
echo "   .claude/skills/doc-verify/    (设计门禁，8 Agent 核验)"
echo "   .claude/skills/custom-claude-template-dev-workflow/  (5 步交付流水线)"
echo "   .claude/skills/custom-claude-template-prod-workflow/ (10 步 + 双门禁流水线)"
echo "   .claude/settings.json         (纯净版，开箱即用)"
echo "   .github/prompts/  .github/skills/  .github/workflows/  openspec/config.yaml"
echo ""
echo "⚠️ 以下需要手动处理（每个文件内都有【模板适配】注释）："
echo "   1. cp '$TPL/CLAUDE.md.example' '$DEST/CLAUDE.md'"
echo "      → 搜索替换所有 {{XXX}} 占位符（项目名/命令/端口/技术铁律）"
echo "   2. 需要 hooks 遥测？→ cp '$TPL/.claude/settings.json.example' '$DEST/.claude/settings.json'"
echo "      → example 已是完整 entire 配置，直接可用（前提：装好 entire CLI；不需要则保持纯净版 settings.json 即可）"
echo "   3. 想要 OS 沙箱兜底（完全放权也不怕 rm -rf）？→ cp '$TPL/.claude/settings.sandbox.json.example' '$DEST/.claude/settings.local.json'"
echo "      → 沙箱内命令自动放行不打断，写操作锁死工作目录，敏感路径（~/.ssh 等）内核级拦截；详见 readme 09 章节"
echo "   4. 检查 custom-claude-template-dev-workflow / custom-claude-template-prod-workflow 头部列出的外部依赖"
echo "      （compound-engineering / commit-commands / agent-browser）"
echo "   5. 在 GitHub 仓库 Settings → Secrets 加 FEISHU_WEBHOOK"
echo "      （不用飞书则改写 .github/workflows/pr-notify-feishu.yml）"
echo "   6. 领域示例参考：.claude/skills/custom-claude-template-payment/（支付接入流程示例，仿照它写你自己的领域流程）"
echo "   7. （可选）技术栈专家 skill 属源工程自有资产，未随模板提供，按需自备"
echo ""
echo "完成后，在工程根目录启动 Claude Code，说一句『开发一个XXX』验证触发。"
