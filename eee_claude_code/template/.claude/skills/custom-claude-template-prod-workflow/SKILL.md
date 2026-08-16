---
name: custom-claude-template-prod-workflow
version: "1.0.0"
description: |
  增强版全自动研发工作流。包含质量门禁闭环（simplify + code-review），确保代码质量达标后才进入后续步骤。

  完整流程（10 步 + 双重质量门禁）：
  brainstorm(可选) → propose → doc-verify(设计门禁) → apply → [代码门禁闭环] → 测试(浏览器/API) → 提交前检查 → archive → commit-push-pr

  设计门禁（步骤 2.5）：doc-verify → 核验文档准确性 → 自动修复 → 重核验（≤3次）
  代码门禁（步骤 4-5）：simplify + code-review → P0/P1问题 → 自动修复 → 重新检查（≤3次）

  触发条件：用户通过 /custom-claude-template-prod-workflow 命令调用，或明确指定使用此工作流。
---

<!-- ============================================================
  ⚠️【模板适配 · 必须处理】本文件来自 custom-claude-template 项目模板。

  使用前请检查并替换以下内容：
  1. 步骤 3 / 步骤 7 的编译命令 `{{BUILD_COMMAND}}`
     → 全文件搜索 `{{BUILD_COMMAND}}`，替换为你项目的编译命令（如 go build ./... / npm run build）
  2. 步骤 6 的后端探活地址 `http://localhost:{{API_PORT}}/actuator/health`
     → 替换为你的后端健康检查地址
  3. 外部 skill 依赖（按你的环境替换或删除）：
     - `compound-engineering:ce-brainstorm` / `ce-code-review` / `ce-test-browser` / `ce-compound` / `ce-commit-push-pr`
     - `simplify`
     - 若没有这些 skill 包，保留其"做什么"的逻辑，改为直接手动执行对应操作
  4. `docs/solutions/`、`docs/brainstorms/` 目录约定 → 可保留或改路径

  替换完成后删除本注释块。
  ============================================================ -->

# 增强版全自动研发工作流 (custom-claude-template-prod-workflow)

用户描述需求后，你的唯一任务是**不中断地顺序执行以下步骤**，直到 PR 创建完成。
每一步通过 Skill 工具调用对应子 Skill，上一步的产物作为下一步的上下文。

---

## When to Use

- 用户通过 `/custom-claude-template-prod-workflow` 命令调用，或明确要求使用此增强工作流
- 需要完整质量保障的功能开发（设计门禁 + 代码门禁 + 端到端测试）
- 涉及现有代码修改的中等及以上规模需求（doc-verify 可核验文档一致性）
- 需要自动提交并创建 PR 的场景

**不适用：** 简单 bug 修复、单文件改动、不需要质量门禁的小任务（使用 `custom-claude-template-dev-workflow` 即可）

---

## 环境初始化（所有步骤前必须执行）

在任何 Bash 命令执行前，先设置必要的环境变量：

```bash
# 确保 agent-browser 可用（Windows 兼容）
export PATH="$HOME/.local/node_modules/.bin:$PATH"
```

---

## 步骤 1（可选）：需求探索

### 触发/跳过判断标准

**执行 brainstorm 的条件（满足任一即执行）：**
- 用户需求描述少于 2 句话，且无法直接推导出具体功能点
- 涉及全新业务领域（项目中无先例的功能模块）
- 需求涉及多方交互、多种角色、或多个子系统联动
- 用户明确要求先探索（"先分析一下"、"帮我理清思路"）

**跳过 brainstorm 的条件（满足任一即跳过）：**
- 用户给出了具体 Bug 现象和复现步骤（"修复X页面的Y报错"）
- 用户需求可映射到明确的 CRUD 操作或 API 端点
- 用户提供了 PRD 文档、原型图、或详细的验收标准
- 改动范围仅涉及配置、文案、样式等简单变更

**调用：** `Skill("compound-engineering:ce-brainstorm", args="<用户需求描述>")`

brainstorm 会通过**交互式对话**澄清需求、探索方案，并生成需求文档。
> **注意：** brainstorm 是本工作流中唯一允许与用户交互的步骤。"不中断原则"从步骤 2 开始生效。

**衔接：** brainstorm 完成后，记录**需求文档文件路径**（从 brainstorm 返回上下文或 `docs/brainstorms/` 目录确认），将需求文档全文传递给步骤 2。

**需求文本缓存（所有路径）：**
- 在步骤 1 开始时，将用户首次提到需求到当前的所有用户消息文本（不做语义过滤）缓存到上下文变量 `ORIGINAL_REQUIREMENT` 中
- 如果执行了 brainstorm，用 **brainstorm 产出的完整需求文档内容**（非摘要）更新 `ORIGINAL_REQUIREMENT`，同时记录需求文档文件路径到上下文变量 `REQUIREMENT_DOC_PATH`
- 此变量将在步骤 2（propose args 构造）和步骤 2.5（传递给 doc-verify 供 A7 需求守卫使用）中消费
- R1 和 R2 传递的是同一份数据：R1 将需求文档传给 propose，R2 将同一份文档传给 A7

---

## 步骤 2：生成规格文档

**调用：** `Skill("opsx:propose", args="<构造后的需求描述>")`

### propose args 构造逻辑

**brainstorm 执行过（REQUIREMENT_DOC_PATH 存在）：**
1. 用 Read 工具读取 `REQUIREMENT_DOC_PATH` 指向的需求文档全文
2. 构造 args，包含以下内容：
   ```
   <用户需求描述>

   【需求约束】
   <Scope Boundaries 章节原文>

   【关键决策】
   <Key Decisions 章节原文>

   【成功标准】
   <Success Criteria 章节原文>

   【项目约束】
   <从 CLAUDE.md "关键技术约定"和"分层依赖"章节提取的关键约定，控制在 15 行以内>
   ```
3. 如果需求文档中不存在对应章节（如无 Success Criteria），跳过该章节不报错
4. 如果 args 总长度超过 5000 字（复杂需求场景）：需求文档从全文降级为核心要点摘要（每个章节提取前 2 句 + 所有带编号的条目），但保留 Scope Boundaries 和 Key Decisions 的完整原文；项目约束段落保留。大多数场景下不会触发此降级

**brainstorm 被跳过（REQUIREMENT_DOC_PATH 不存在）：**
- args = `ORIGINAL_REQUIREMENT`（用户消息文本）+ 【项目约束】段落

### CLAUDE.md 项目约束提取

用 Read 工具读取 `CLAUDE.md`，提取以下两个章节的内容：
1. "关键技术约定"段落（ORM、软删除、认证、工作流、注解处理、缓存、文件存储）
2. "分层依赖"段落（模块依赖关系）

拼接为 15 行以内的精简摘要，重点关注：带精确约束的条目（如"ORM 用 MyBatis-Plus"、"Lombok + MapStruct 顺序不可调换"、"deleted 字段软删除"、"Token 无状态"）

**衔接：** propose 完成后，从输出或 `openspec/changes/` 目录中确认 change 名称（kebab-case），记录到上下文供后续步骤使用。

---

## 步骤 2.5：设计门禁（doc-verify）

### 触发/跳过判断标准

**执行 doc-verify 的条件（满足任一即执行）：**
- propose 生成了 design.md 或 specs 文件（有规格文档可核验）
- 变更涉及现有代码修改（非纯新增模块）
- 用户明确要求核验文档（"帮我核对一下文档"）

**跳过 doc-verify 的条件（满足任一即跳过）：**
- 纯新增模块（无现有代码可核验，如新建一个不关联现有代码的功能）
- 变更范围仅涉及配置、文案、样式等简单变更
- 用户明确跳过（"跳过核验直接实现"）

### 执行逻辑

**调用：** `Skill("doc-verify", args="--change <change-name>")`

doc-verify 会核验步骤 2 生成的规格文档与代码库的一致性，使用 8 个并行 Agent（字段守卫、行号猎手、逻辑侦探、枚举审计、影响雷达、边界猎手、需求守卫、跨文档一致性）。

**需求文本传递：** 调用 doc-verify 时，将上下文变量 `ORIGINAL_REQUIREMENT` 的值作为 A7（需求守卫）的需求输入。具体方式：在 doc-verify 的 Agent prompt 构建阶段，将 `ORIGINAL_REQUIREMENT` 注入到 A7 的 `<requirement>` 块中。A7 采用两档策略：(a) 需求文本充分（> 50 字或含明确功能点）→ 完整运行需求覆盖度 + 可实施性评审；(b) 需求文本过简 → 跳过需求覆盖度核验，仅做可实施性评审，但强制产出"需求简短警告"P1 级发现。需求简短警告不阻塞 Verdict（作为不可自动修复的发现记录）。

### 闭环流程

与步骤 4-5 代码门禁类似：
- doc-verify 发现 P0/P1 问题 → 自动修复简单问题 → 记录复杂问题 → 重核验
- 最多 3 轮
- **在工作流模式下不中断等待用户确认** — 复杂问题记录到上下文，在步骤 3 开始前播报警告

### 衔接

doc-verify 完成后：
- 如果通过（无 P0/P1 或所有问题已修复）→ 继续步骤 3
- 如果未通过（round=3 仍有 P0/P1）→ 在步骤 3 开始前播报："⚠️ 设计门禁未完全通过，X 个问题待解决。建议在实现过程中注意以下问题：..." → 继续步骤 3（不中断流程）
- 记录核验结果摘要（通过/未通过 + 发现数量 + BUG 清单）到上下文，供步骤 9 的 PR 描述使用

---

## 步骤 3：实现代码

**调用：** `Skill("opsx:apply")`

无需传额外参数，opsx:apply 会从当前 openspec 状态自动识别待实现的 change。
逐条完成 tasks.md 中的任务，每条完成后打 `[x]`，直到所有任务完成。

**衔接：** apply 完成后，记录本次改动涉及的文件路径（用于步骤 4 的代码审查和步骤 6 的测试 URL 推断）。

**编译验证：** apply 完成后立即执行编译检查，确认代码无编译错误：
```bash
{{BUILD_COMMAND}}
```
若编译失败，就地修复后重新编译（最多重试 3 次）。3 次后仍失败则记录错误到 PR 描述，继续后续步骤。**原因：** 在无法编译的代码上运行 simplify/code-review 是浪费时间。

---

## 步骤 4-5：质量门禁闭环

### 闭环流程

```
┌──→ simplify（步骤 4）──→ code-review（步骤 5）──→ 发现 P0/P1 问题？──YES──→ 自动修复代码 ──┐
│                                                                                          │
│                                                                                          │
└──────────────────────────────────────────────────────────────────────────────────────────┘
                                                                 │
                                                                 NO（或达到 3 次上限）
                                                                 ↓
                                                              继续步骤 6
```

### 步骤 4：代码简化审查

**调用：** `Skill("simplify")`

simplify 会审查已改动的代码，检查重复、不必要的复杂度、未使用的代码和违反 DRY 原则的地方，并自动修复发现的问题。

**衔接：** 记录 simplify 修复了哪些问题（如有），传递给步骤 5。

### 步骤 5：多维度代码审查

**调用：** `Skill("compound-engineering:ce-code-review")`

ce-code-review 使用多维度审查（正确性、安全性、性能、可维护性、测试覆盖等），产出分级发现（P0/P1/P2）。

### 闭环决策逻辑

**循环计数器：** 从 1 开始，每次进入 simplify 时 +1，最大值为 3。

**判断规则：**
1. 若 code-review 发现 **P0 或 P1 问题**，且循环次数 < 3：
   - 根据审查意见自动修复代码
   - 记录本轮修复内容
   - 回到步骤 4（simplify）重新检查
2. 若 code-review **无 P0/P1 问题**，或仅剩 P2+ 低优先级问题：
   - 通过质量门禁，继续步骤 6
3. 若循环次数达到 3 次仍有 P0/P1 问题：
   - 将未解决问题记录到 PR 描述，继续步骤 6（不中断流程）

**质量汇总：** 闭环结束后，汇总所有修复记录（每轮 simplify 和 code-review 的发现及修复），供步骤 9 的 PR 描述使用。

**闭环后重测：** 质量门禁闭环中若执行了代码修复（即循环次数 ≥ 2），则在进入步骤 6 之前，先执行一次**快速回归验证**：
1. 若项目有编译步骤（如 `mvn compile`），先编译确认无编译错误
2. 若改动涉及后端 API，用 `curl` 验证核心接口可正常响应
3. 这不是完整的 test-browser，只是防止质量门禁修复引入明显回归

---

## 步骤 6：端到端测试

### 测试方式判断

根据步骤 3 改动的文件路径，判断测试方式：

**前端/全栈变更**（改动涉及 `.vue`、`.js`、`.ts` 文件，或前后端都改了）：
- **调用：** `Skill("compound-engineering:ce-test-browser", args="测试 <change名称> 实现的功能，在页面：<推断的测试URL>。使用 headed 模式。仅做功能验证，不截图不录屏。")`
- **测试模式：** 始终使用 Headed 模式（可视化），**不截图、不录屏**，仅通过交互操作验证功能是否正常。

**纯后端变更**（改动仅涉及 `.java`、`.xml` mapper、SQL 等，无前端文件）：
- 跳过 test-browser，改为 **API 验证**：
  1. 先用 `curl -s -o /dev/null -w "%{http_code}" http://localhost:{{API_PORT}}/actuator/health` 检查后端是否可达
  2. 若可达，根据改动的 API 端点用 `curl` 验证核心接口返回正常
  3. 若不可达，记录"后端未运行，跳过 API 验证"，不主动启动服务（启动耗时且可能干扰用户开发环境）
- **调用：** 直接用 Bash 执行 curl 命令，不调用 test-browser skill

### 测试 URL 推断（仅前端/全栈变更时使用）

根据步骤 3 改动的文件路径，结合 `CLAUDE.md` 中的项目结构和端口信息，自动推断最相关的测试页面 URL。

- 若改动文件可直接映射到某个前端路由，使用该路由 URL
- 若改动的是后端或通用组件，找到消费它的前端页面作为测试入口
- 若测试 URL 包含动态参数（如详情页 ID），从项目数据库中查询一条有效记录获取
- 若无法推断，使用项目首页或主列表页

**衔接：** 测试完成后：
1. 记录测试通过/失败状态及验证的功能点列表
2. 若关键测试失败，先修复代码，再重新测试（最多重试 3 次）；3 次后仍失败则报告用户，记录到 PR 描述

**若本次测试出现过失败并修复，则在进入步骤 7 之前，执行步骤 6.5 记录经验教训。**

---

## 步骤 6.5（条件触发）：记录经验教训

**触发条件：** 步骤 6 中发生过测试失败并完成修复。若测试一次通过，跳过此步骤。

**调用：** `Skill("compound-engineering:ce-compound")`

将"发现 Bug → 定位根因 → 修复 → 验证通过"的完整过程归档到 `docs/solutions/`，供后续遇到相同问题时快速查阅。

**执行提示：** 若提示选择模式，**始终选择 Compact-safe（单次执行）** 以节省 context。

---

## 步骤 7：提交前检查

执行以下项目适配的提交前检查，替代通用部署检查：

```bash
# 1. 编译检查
{{BUILD_COMMAND}}

# 2. 检查是否有未处理的冲突标记
git diff --check

# 3. 检查是否误改了 application / bootstrap 配置文件（根据项目规则不应随意修改）
git diff --name-only HEAD | grep -qE "(application|bootstrap).*\.(ya?ml|properties)$" && echo "⚠️ 检测到 application/bootstrap 文件变更，需确认是否为预期修改"

# 4. 检查 .gitignore 覆盖（排除自动生成文件）
git status --short | grep "^?" | head -20
```

**衔接：** 记录检查结果。

**失败处理：**
- 编译失败：修复后重新编译
- 冲突标记：解决冲突
- application/bootstrap 文件变更：记录警告到上下文，不中断流程（根据 CLAUDE.md 中的保护规则）
- 其他警告：记录后继续

---

## 步骤 8：归档变更

**调用：** `Skill("opsx:archive")`

opsx:archive 会：
1. 检查 artifact 完成状态
2. 检查 delta specs，**始终选择"同步后归档（推荐）"**
3. 将 change 归档到 `openspec/changes/archive/YYYY-MM-DD-<name>/`

无需用户干预，所有确认提示均选推荐选项。

---

## 步骤 9：提交 & PR

**PR 检测：** 在执行前，先检查当前分支是否已有未合并的 PR：
```bash
gh pr list --head "$(git branch --show-current)" --state open --json number,title,url
```

**情况 A — 已有 open PR：** 仅执行 commit + push，不调用 ce-commit-push-pr（避免重复创建 PR）：
```bash
git add -A
# 如有框架自动生成的文件（查看 .gitignore 和项目约定），用 git reset HEAD 排除
# commit message 格式：type(scope): 中文描述（如 feat(pl): 新增提成核算功能）
git commit -m "<conventional commit message>"
git push
# 更新已有 PR 描述，补充质量门禁和测试结果
gh pr edit <PR号> --body "<更新后的 PR 描述，包含质量门禁审查结果和测试验证结果>"
```

**情况 B — 无已有 PR：** 调用 ce-commit-push-pr 自动完成全流程：

**调用：** `Skill("compound-engineering:ce-commit-push-pr")`

commit-push-pr 会自动：
1. 创建分支
2. 暂存相关文件（排除自动生成文件）
3. 创建 conventional commit
4. push 并创建 PR

**PR 描述上下文：** 无论哪种情况，PR 描述（或 commit message）应包含以下信息，供 ce-commit-push-pr 使用或手动写入：
- 变更摘要
- 设计门禁结果（doc-verify 的发现及修复，如有）
- 代码门禁审查结果（simplify 和 code-review 的发现及修复）
- 测试验证结果（通过的功能点列表，或 API 验证结果）

---

## 执行规范

- **不中断原则：** 步骤 2 起全部自动执行，不在中间停下来询问用户"是否继续"。步骤 1（brainstorm）是唯一允许交互的步骤。
- **异常处理：** 若某步骤失败，就地修复后继续，不放弃流程。
- **进度播报：** 每步开始时简短说明正在执行哪一步（"▶ 步骤 2.5/10：设计门禁"），让用户知晓进度。
- **上下文传递：** change 名称、改动文件列表、质量门禁修复记录等关键信息需在步骤间显式传递。
- **自动生成文件排除：** 检查项目的 `.gitignore` 和框架约定，排除自动生成的文件不纳入 git commit。
- **设计门禁（步骤 2.5）：** doc-verify 核验规格文档准确性。自动修复简单问题（行号偏移、字段名错误），复杂问题记录到上下文。工作流模式下不中断等待用户确认。循环上限 3 次。跳过条件：纯新增模块、配置/样式变更。
- **代码门禁闭环（步骤 4-5）：** simplify + code-review → 修复 → 重新检查。循环上限 3 次，仅限代码层修复，不回滚规格文档。闭环中若有代码修复（循环 ≥ 2），需在进入步骤 6 前执行快速回归验证（编译 + 核心接口检查）。
- **步骤 3 编译验证：** apply 完成后必须先执行 `{{BUILD_COMMAND}}` 确认无编译错误，再进入质量门禁。
- **步骤 6 测试方式判断：** 前端/全栈变更用 test-browser，纯后端变更用 curl/API 验证。
- **步骤 6.5 判断：** 步骤 6 出现过测试失败时触发 compound 记录经验；测试一次通过则跳过。
- **步骤 7 提交前检查：** 编译 + 冲突检查 + application/bootstrap 文件保护检查 + 未跟踪文件审查。application/bootstrap 文件变更时需提醒用户确认。
- **步骤 9 PR 分支检测：** 执行前用 `gh pr list --head` 检查当前分支是否已有 open PR。若已有 PR（情况 A），手动 commit + push + `gh pr edit` 更新 PR 描述；若无 PR（情况 B），调用 ce-commit-push-pr 全流程。
- **Context 预算管理：** 本工作流涉及多次 skill 调用（最坏情况约 15 次），需注意 context window 预算。双重门禁中尽量精简修复记录，避免逐字抄录审查结果；步骤间仅传递关键摘要信息（change 名称、改动文件、修复摘要），而非完整 skill 输出。

---

## Troubleshooting

| 失败节点 | 症状 | 处理方式 |
|----------|------|---------|
| 步骤 2 propose | openspec change 创建失败或目录冲突 | 检查 `openspec/changes/` 是否已有同名 change；如有则用 `opsx:continue` 继续，或删除后重新 propose |
| 步骤 3 编译 | `{{BUILD_COMMAND}}` 连续 3 次失败 | 记录错误到 PR 描述，跳过质量门禁直接进入步骤 6（在无法编译的代码上运行审查无意义） |
| 步骤 4-5 质量门禁 | 3 轮后仍有 P0/P1 | 将未解决问题记录到 PR 描述，继续步骤 6（不中断流程） |
| 步骤 6 test-browser | 浏览器无法启动或超时 | 降级为 curl API 验证；若后端也不可达，记录"跳过测试"并继续 |
| 步骤 6 测试失败 | 关键功能验证失败 | 就地修复后重新测试（最多 3 次）；3 次后仍失败则报告用户，记录到 PR 描述 |
| 步骤 7 冲突标记 | `git diff --check` 发现冲突 | 就地解决冲突标记后重新检查 |
| 步骤 8 archive | 同步 delta specs 失败 | 选择"仅归档"跳过同步，手动补录 specs |
| 步骤 9 PR | `gh` 未认证或无权限 | 改为手动 `git push`，提示用户手动创建 PR |
| 步骤 9 分支推送 | `git push` 被 reject | 检查是否有远程更新，执行 `git pull --rebase` 后重试 |
| Context 不足 | 工作流中途 context window 耗尽 | 步骤间仅传递关键摘要；若已无法继续，记录已完成的步骤和待办事项供下次恢复 |
