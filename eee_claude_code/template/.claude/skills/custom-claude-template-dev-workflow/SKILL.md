---
name: custom-claude-template-dev-workflow
description: |
  全自动研发工作流编排器。当用户描述任何开发需求时，自动连续执行完整五步流程：
  propose规格文档 → apply代码实现 → test-browser端到端测试 → archive归档 → commit-push-pr提交PR。

  触发条件（凡满足其一即触发）：
  - 用户描述一个新功能："开发X"、"实现Y"、"新增Z"、"做一个..."
  - 用户提出优化："优化..."、"改进..."、"重构..."
  - 用户报告 Bug："修复..."、"fix..."、"有个问题..."
  - 用户说"新需求："或给出 PRD/需求描述

  重要：用户描述需求后立即触发，不等待用户逐步调用每个子命令。如果无法确定是否为开发需求，默认触发。
---

<!-- ============================================================
  ⚠️【模板适配 · 必须处理】本文件来自 custom-claude-template 项目模板。

  使用前请检查以下外部依赖，按你的环境替换：
  1. `opsx:*` 命令与 `openspec-*` skill
     → 依赖 openspec CLI + 本模板 .claude/commands/opsx/ 目录（已包含，直接拷贝即可）
  2. `compound-engineering:*`（test-browser / ce:compound）
     → 外部 skill 包，若你的环境没有，替换为你的浏览器测试方案
  3. `commit-commands:commit-push-pr`
     → 外部 skill 包，若没有，按步骤 5 里的手动 git 命令替代
  4. `agent-browser --headed`（截图/录屏工具）
     → 外部工具，若没有，替换为你的截图方案或只用文字断言
  5. 步骤 3 的"测试 URL 推断"依赖 CLAUDE.md 里的端口/路由信息
     → 确认你的 CLAUDE.md 已正确填写

  替换完成后删除本注释块。
  ============================================================ -->

# 全自动研发工作流

用户描述需求后，你的唯一任务是**不中断地顺序执行以下五个步骤**，直到 PR 创建完成。
每一步通过 Skill 工具调用对应子 Skill，上一步的产物作为下一步的上下文。

---

## 步骤 1：生成规格文档

**调用：** `Skill("opsx:propose", args="<需求描述>")`

将用户的原始需求描述作为 args 传入。opsx:propose 会自动创建 change 并生成全套规格文档（proposal.md + design.md + specs/*.md + tasks.md）。

**衔接：** propose 完成后，从输出或 `openspec/changes/` 目录中确认 change 名称（kebab-case），记录到上下文供后续步骤使用。

---

## 步骤 2：实现代码

**调用：** `Skill("opsx:apply")`

无需传额外参数，opsx:apply 会从当前 openspec 状态自动识别待实现的 change。
逐条完成 tasks.md 中的任务，每条完成后打 `[x]`，直到所有任务完成。

**衔接：** apply 完成后，记录本次改动涉及的文件路径（用于步骤 3 推断测试 URL）。

---

## 步骤 3：端到端测试

### 第一步：锁定项目根目录（必须在其他操作之前执行）

工作流在执行过程中可能切换到子目录运行构建命令，若用相对路径保存截图会落到错误位置。因此**必须先用 git 获取根目录的绝对路径，后续所有文件操作都用此绝对路径**：

```bash
# 无论当前在哪个子目录，都能正确获取项目根目录
PROJECT_ROOT=$(git rev-parse --show-toplevel)
# 截图前缀：分支名 + 日期（YYMMDDHH），确保文件名全局唯一
BRANCH_NAME=$(git branch --show-current | sed 's/[^a-zA-Z0-9_-]/-/g')
DATE_PREFIX=$(date +%y%m%d%H)
SCREENSHOT_PREFIX="${BRANCH_NAME}_${DATE_PREFIX}"
TEST_RESULTS="$PROJECT_ROOT/test-results"
mkdir -p "$TEST_RESULTS"
echo "测试证据目录：$TEST_RESULTS"
echo "截图前缀：$SCREENSHOT_PREFIX"
```

将 `$PROJECT_ROOT`、`$TEST_RESULTS` 和 `$SCREENSHOT_PREFIX` 记录到上下文，后续所有截图、录屏命令都使用这些变量（不要使用裸相对路径）。

**调用：** `Skill("compound-engineering:test-browser", args="测试 <change名称> 实现的功能，在页面：<推断的测试URL>。使用 headed 模式。截图和录屏必须保存到绝对路径 <$TEST_RESULTS>，不要使用相对路径，避免因工作目录切换而存错位置。")`

**测试模式：** 始终使用 Headed 模式（可视化），不要询问用户。

### 截图与录屏规范

**截图：** 使用 `$TEST_RESULTS` 绝对路径，文件名格式 `{SCREENSHOT_PREFIX}_NN-描述.png`：
```bash
agent-browser --headed screenshot "$TEST_RESULTS/${SCREENSHOT_PREFIX}_01-initial-state.png"
agent-browser --headed screenshot "$TEST_RESULTS/${SCREENSHOT_PREFIX}_02-after-action.png"
```
> 前缀由分支名 + 日期（YYMMDDHH）组成，例如 `feature-login-page_26031915_01-initial-state.png`，确保多次测试的截图不会互相覆盖。

**录屏：** 在第一个 `agent-browser open` 之前启动录屏，测试结束后停止：
```bash
# 测试开始前启动录屏（使用绝对路径）
agent-browser --headed record start "$TEST_RESULTS/${SCREENSHOT_PREFIX}_recording.webm" <测试URL>

# 正常执行测试操作（截图、点击、填写等）

# 测试结束后停止录屏
agent-browser --headed record stop
```
> 注意：录屏依赖 ffmpeg avfoundation，macOS 需授予屏幕录制权限。若录屏启动失败，**不阻塞测试**，仅依靠截图作为证据。

### 测试 URL 推断

根据步骤 2 改动的文件路径，结合 `CLAUDE.md` 中的项目结构和端口信息，自动推断最相关的测试页面 URL。

- 若改动文件可直接映射到某个前端路由，使用该路由 URL
- 若改动的是后端或通用组件，找到消费它的前端页面作为测试入口
- 若测试 URL 包含动态参数（如详情页 ID），从项目数据库中查询一条有效记录获取
- 若无法推断，使用项目首页或主列表页

**衔接：** test-browser 完成后：
1. 记录测试通过/失败状态
2. 收集测试证据清单（供步骤 6 写入 PR body），使用锁定的绝对路径：
   - 运行 `ls "$TEST_RESULTS"/${SCREENSHOT_PREFIX}_*.png 2>/dev/null` 获取截图文件列表
   - 运行 `ls "$TEST_RESULTS/${SCREENSHOT_PREFIX}_recording.webm" 2>/dev/null` 确认录屏是否存在
3. 若关键测试失败，先修复代码（调用 opsx:apply 继续修复），再重新测试，直到核心功能验证通过

**若本次测试出现过失败并修复（即经历了"发现问题 → 修复 → 重测通过"的循环），则执行步骤 3.5 记录经验教训。**

---

## 步骤 3.5（条件触发）：记录经验教训

**触发条件：** 步骤 3 中发生过测试失败并完成修复。若测试一次通过，跳过此步骤。

**调用：** `Skill("compound-engineering:ce:compound")`

此步骤将把刚才"发现 Bug → 定位根因 → 修复 → 验证通过"的完整过程归档到 `docs/solutions/`，供后续遇到相同问题时快速查阅，避免重复踩坑。

**执行提示：** 调用时无需额外参数，compound 会自动从当前对话上下文提取问题、根因和解决方案。若提示选择模式，**始终选择 Compact-safe（单次执行）** 以节省 context。

**衔接：** compound 完成（或跳过）后，进入步骤 4。

---

## 步骤 4：归档变更

**调用：** `Skill("opsx:archive")`

opsx:archive 会：
1. 检查 artifact 完成状态
2. 检查 delta specs，**始终选择"同步后归档（推荐）"**
3. 将 change 归档到 `openspec/changes/archive/YYYY-MM-DD-<name>/`

无需用户干预，所有确认提示均选推荐选项。

---

## 步骤 5：提交 & PR

**PR 检测：** 在执行前，先检查当前分支是否已有未合并的 PR：
```bash
gh pr list --head "$(git branch --show-current)" --state open --json number,title,url
```
若返回结果非空，说明当前分支已有 open PR，则**跳过创建新 PR**——仅执行 commit + push（代码会自动同步到已有 PR）。跳过 `commit-push-pr` skill，改为手动执行：
```bash
git add -A
# 如有框架自动生成的文件（查看 .gitignore 和项目约定），用 git reset HEAD 排除
git commit -m "<conventional commit message>"
git push
```

**调用前准备：** 先通过 `commit-push-pr` 创建 PR（此时 PR body 中截图部分用文件名占位），然后再上传截图并更新 PR body。

**调用：** `Skill("commit-commands:commit-push-pr")`

commit-push-pr 会自动：
1. 创建分支 `feature/{kebab-desc}`
2. 暂存相关文件（排除自动生成文件）
3. 创建 conventional commit（中文风格）
4. push 并用 `gh pr create` 创建 PR

### 截图上传到 PR 描述

PR 创建后，将测试截图上传到 GitHub 并嵌入 PR body。`test-results/` 目录被 `.gitignore` 忽略，不能直接提交到仓库，需要通过 GitHub Release 临时托管截图文件。

**完整流程：**

**第一步：创建临时 Release**
```bash
git tag temp-screenshots
git push origin temp-screenshots
gh release create temp-screenshots --title "Test Screenshots (temp)" --notes "Temporary release for PR #<PR号> screenshots"
```

**第二步：上传所有截图为 Release Assets**
```bash
for img in "$TEST_RESULTS"/${SCREENSHOT_PREFIX}_*.png; do
  echo "Uploading $(basename "$img")..."
  gh release upload temp-screenshots "$img" --clobber
done
```

> 若网络不稳定导致部分上传失败，检查已上传数量并补传缺失文件：
> ```bash
> gh release view temp-screenshots --json assets --jq '.assets[].name'
> # 对比本地文件列表，补传缺失的
> gh release upload temp-screenshots "$TEST_RESULTS/09-xxx.png" --clobber
> ```

**第三步：验证上传完成**
```bash
gh release view temp-screenshots --json assets --jq '.assets | length'
```
确认数量与本地截图数量一致。

**第四步：构建带图片的 PR body 并更新**

截图的公开下载 URL 格式为：
```
https://github.com/<owner>/<repo>/releases/download/temp-screenshots/<文件名>
```

用 `gh pr edit <PR号> --body-file /tmp/pr-body.md` 更新 PR 描述，将截图以 Markdown 图片语法嵌入：

```markdown
## 测试截图

### 1. 初始状态
| 截图A | 截图B |
|:---:|:---:|
| ![01](https://github.com/<owner>/<repo>/releases/download/temp-screenshots/01-xxx.png) | ![02](https://github.com/<owner>/<repo>/releases/download/temp-screenshots/02-xxx.png) |

### 2. 操作后状态
...
```

> 使用两列表格布局，每行放 2 张截图，按测试步骤分组并加小标题，让 PR 描述清晰易读。

**清理提示（PR 合并后可选）：**
```bash
gh release delete temp-screenshots -y && git push origin :temp-screenshots && git tag -d temp-screenshots
```

> 若录屏成功（`$TEST_RESULTS/recording.webm` 存在），调用 `Skill("compound-engineering:feature-video")` 自动将视频上传并嵌入 PR description。

---

## 执行规范

- **不中断原则：** 所有步骤全部自动执行，不在中间停下来询问用户"是否继续"。
- **异常处理：** 若某步骤失败（如类型检查报错、测试失败），就地修复后继续，不放弃流程。
- **进度播报：** 每步开始时简短说明正在执行哪一步（"▶ 步骤 3/5：端到端测试"），让用户知晓进度。
- **上下文传递：** change 名称、改动文件列表等关键信息需在步骤间显式传递。
- **自动生成文件排除：** 检查项目的 `.gitignore` 和框架约定，排除自动生成的文件（如类型声明、lock 产物等）不纳入 git commit。
- **步骤 3.5 判断：** 严格按条件触发——只要步骤 3 出现过任何测试失败（即使最终修复通过），就必须执行 compound 记录经验；若测试一次通过则跳过，不影响主流程速度。
- **步骤 5 PR 检测：** 执行前用 `gh pr list --head` 检查当前分支是否已有 open PR。若已有 PR，仅 commit + push，不创建新 PR。
- **项目根目录锁定：** 步骤 3 开始时必须先执行 `PROJECT_ROOT=$(git rev-parse --show-toplevel)`，所有截图和录屏操作一律使用绝对路径 `$PROJECT_ROOT/test-results/`，禁止使用裸相对路径（避免在子目录下工作时存到错误位置）。
- **测试证据：** 截图命名格式为 `{SCREENSHOT_PREFIX}_NN-描述.png`（前缀 = 分支名 + 日期YYMMDDHH），保存到 `$PROJECT_ROOT/test-results/`；录屏保存为 `${SCREENSHOT_PREFIX}_recording.webm`。录屏失败不阻塞流程，降级为截图证明。
- **截图上传：** `test-results/` 被 `.gitignore` 忽略，不能直接提交。步骤 6 中通过创建临时 GitHub Release → 上传截图为 Release Assets → 用下载 URL 嵌入 PR body 的方式实现。上传完成后用 `gh pr edit --body-file` 更新 PR 描述。网络中断时检查已上传数量并补传缺失文件。
