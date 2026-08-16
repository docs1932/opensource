---
name: doc-verify
version: "1.0.0"
description: |
  需求文档自动核验。8 个并行 Agent 从不同维度验证文档：
  A1-A6 核验文档与代码库的一致性（字段守卫、行号猎手、逻辑侦探、枚举审计、影响雷达、边界猎手），
  A7 核验需求覆盖度和可实施性（需求守卫），A8 核验跨文档一致性。

  自动修复简单问题（行号偏移、字段名错误），交互确认复杂问题（业务逻辑偏差），
  闭环收敛直到文档通过（最多 3 轮）。

  支持两种调用方式：
  1. 独立调用：/doc-verify <文档路径>
  2. 工作流编排：作为 custom-claude-template-prod-workflow 步骤 2.5（设计门禁）

  触发条件：用户通过 /doc-verify 命令调用，或由 custom-claude-template-prod-workflow 自动编排。
---

<!-- ============================================================
  ✅【通用模板】本文件可直接使用，无需改动。
  依赖：
    - openspec CLI（用于 `openspec instructions apply --change`）
    - Claude 的 Agent 工具（8 个并行 sonnet Agent）
  如需自定义：核验维度/Agent 职责在 references/agent-prompts.md 中修改，
  报告输出格式在 references/report-template.md 中修改。
  ============================================================ -->

# doc-verify — 需求文档自动核验

核验需求/设计文档与代码库的一致性，以及需求覆盖度和可实施性。8 个并行 Agent 独立核验不同维度，发现并修复文档错误，闭环直到文档准确。

---

## When to Use

- 在实现需求前，验证设计文档与代码库的一致性（作为设计门禁）
- 编写完 openspec change 的 design/proposal 后，确认文档准确
- 用户通过 `/doc-verify` 命令显式调用
- 由 `custom-claude-template-prod-workflow` 作为步骤 2.5 自动编排调用
- 文档包含代码引用（文件名:行号、类名.字段名、枚举值等）需要核验时

---

## 输入

**参数格式：** `<文档路径>` 或 `--change <change名称>` 或空（自动推断）

**推断优先级：**
1. 如果参数是文件路径（包含 `.md` 或 `/` 或 `\`）→ 文件路径模式
2. 如果参数以 `--change` 开头 → openspec change 模式
3. 如果当前对话上下文中有明显的文档路径或 change 名称 → 使用上下文
4. 否则 → 用 AskUserQuestion 让用户选择：输入文档路径 或 选择 openspec change

---

## 执行流程

### Step 1: 加载文档

**文件路径模式：**
```
用 Read 工具读取文档文件内容
```

**openspec change 模式：**
```bash
openspec instructions apply --change "<change-name>" --json
```
从 `contextFiles` 中找到 proposal.md、design.md、specs、tasks 等文件，全部读取。

**文档加载后：**
- 简短播报："正在核验文档：<文件名>"
- 记录文档中引用的所有**代码文件路径**（用于 Agent 上下文传递）
- 检查上下文中是否有用户原始需求文本（可能来自 custom-claude-template-prod-workflow 传递的 `ORIGINAL_REQUIREMENT` 变量，或独立调用时从对话上下文推断）
- 如果存在需求文本，缓存为 `REQUIREMENT_TEXT`；判断需求充分性：长度 > 50 字或包含明确功能点描述（如带编号的需求列表）→ 标记为 `REQUIREMENT_ADEQUATE = true`，否则 → 标记为 `REQUIREMENT_ADEQUATE = false`
- 用 Read 工具预读取文档中显式引用的代码文件，注入到 Agent 的 `<code-context>` 块（第一层：编排器预读取）。Agent 运行时自行 Grep 搜索的代码作为第二层补充
- 预读取失败的文件在 `<code-context>` 中标注"未找到该文件，Agent 需自行搜索"

---

### Step 2: 并行派出 8 个 Agent

使用 Agent 工具，一次性派出 8 个 Agent（并行），每个使用 `model: "sonnet"`。

**播报：**
```
核验团队：
- A1 字段守卫（字段名、类型、值域）
- A2 行号猎手（行号、方法名引用）
- A3 逻辑侦探（业务流程 vs 代码路径）
- A4 枚举审计（枚举值、字典值、状态码）
- A5 影响雷达（变更影响范围）
- A6 边界猎手（边界条件和异常路径）
- A7 需求守卫（需求覆盖度 + 可实施性评审）
- A8 跨文档一致性（文档间矛盾和遗漏）
```

#### Agent Prompt 模板

每个 Agent 的完整 prompt 模板（共同上下文 + A1-A8 任务描述）定义在 `references/agent-prompts.md`。

构建 Agent prompt 时：
1. 先读取 `references/agent-prompts.md` 获取共同上下文模板和各 Agent 专属任务描述
2. 将文档内容、需求文本、代码上下文注入到模板对应位置
3. 每个 Agent 使用 `model: "sonnet"`

**Agent 职责速览：**

| Agent | 名称 | 核验维度 |
|-------|------|---------|
| A1 | 字段守卫 | 字段名、类型、值域与 DO/VO/Entity 的一致性 |
| A2 | 行号猎手 | 行号引用、方法名引用的准确性 |
| A3 | 逻辑侦探 | 业务流程描述 vs 代码实际执行路径 |
| A4 | 枚举审计 | 枚举值、字典值、状态码的正确性 |
| A5 | 影响雷达 | 变更影响范围的完整性 |
| A6 | 边界猎手 | 边界条件和异常场景的覆盖度 |
| A7 | 需求守卫 | 需求覆盖度 + 可实施性评审（两档策略） |
| A8 | 跨文档一致性 | 文档间矛盾和遗漏 |

---

### Step 3: 合并发现

收集 8 个 Agent 的 JSON 返回，执行合并管线：

#### 3.1 容错解析

对每个 Agent 返回的 JSON 做容错处理：
- 如果 JSON 解析失败，尝试提取文本中的 JSON 部分
- 如果仍然失败，记录该 Agent 为"返回格式异常"，跳过其发现
- 在报告中标注异常的 Agent

#### 3.2 去重

使用指纹（根据 Agent 类型选择）：
- A1-A6 发现：`normalize(code_file) + line_bucket(code_line, ±3) + normalize(title)`
- A7 发现（需求覆盖/模糊指令）：`normalize(doc_location) + normalize(title)`（A7 的发现不涉及 code_file/code_line）
- A8 发现（跨文档矛盾）：`normalize(source_doc) + normalize(title)`（A8 的发现引用的是源文档而非代码文件）

语义去重（跨 Agent 类型）：
当不同类型 Agent 的发现指向同一文档位置时，合并为一条发现，标注所有相关 Agent。

当指纹匹配时：
- 保留最高 severity
- 保留最长 description
- 在 Reviewer 列标注所有发现该问题的 Agent（如 "A1, A3"）

#### 3.3 跨 Agent 一致性提升

当 2+ 个独立 Agent 报告同一问题时，在该发现中标注"多 Agent 共识"，提升可信度。

#### 3.4 分区

将发现分为三个队列：

| 队列 | 条件 | 处理方式 |
|------|------|---------|
| **auto-fix** | `auto_fixable=true` 且类型为行号偏移/字段名拼写错误 | Step 4a: 自动修复 |
| **interactive** | 其余 P0/P1/P2 问题 | Step 4b: 交互确认 |
| **bugs** | `bugs_found` 列表中的代码 BUG | 独立 BUG 清单 |

#### 3.5 排序

按 severity (P0→P3) → code_file 路径 → code_line 行号排序

---

### Step 4: 执行修复

#### 4a: 自动修复（auto-fix 队列）

对每个 auto-fixable 发现：
1. 用 Edit 工具直接修改文档文件
2. 记录修复内容："自动修复：InvoiceServiceImpl:123 → InvoiceServiceImpl:122（行号偏移 -1）"
3. 修复后不需要用户确认

**自动修复的安全边界：**
- 仅修复行号偏移（±3 行内）和字段名拼写错误
- 每次修复只能改变文档中的引用，不能改变代码
- 如果不确定修复是否正确，降级为 interactive

#### 4b: 交互确认（interactive 队列）

**独立调用模式**（默认）：按文件/模块分组批量呈现。

1. 将 interactive 队列中的发现按涉及的代码文件/文档模块分组
2. 对每组，使用 AskUserQuestion 呈现该文件的所有问题：

**呈现格式：**
```
文件/模块：InvoiceServiceImpl.java（3 个问题）

问题 1 [P1]：dealOrder() 执行顺序
- 文档描述：先更新订单状态，再更新产品状态
- 代码实际：先更新产品状态（377-379行），再更新订单（380-383行）
- 建议：修正文档描述以匹配代码实际执行顺序

问题 2 [P2]：recycleAmount 字段类型
...

选项：[全部修复] [选择性修复] [全部忽略]
```

3. 用户选择处理：
   - **全部修复**：编排器根据 suggested_fix 批量用 Edit 工具修改文档
   - **选择性修复**：展开该组内单个问题逐个确认
   - **全部忽略**：整组标记为"用户确认忽略"，不修改

**工作流模式**（被 custom-claude-template-prod-workflow 调用时）：跳过交互确认。
- 所有 interactive 队列的发现直接记录到上下文，不等待用户确认
- 在进入步骤 3（apply）前播报未解决问题摘要

---

### Step 5: 闭环判断

维护 `round` 计数器（初始值为 1，最大值为 3）。

**判断逻辑：**
1. 统计当前仍存在的 P0/P1 问题数量（排除用户确认忽略的）
2. 如果 P0/P1 数量 > 0 且 round < 3：
   - round++
   - 播报："第 N/3 轮核验完成，仍有 X 个 P0/P1 问题，开始重核验..."
   - 回到 Step 2（重跑 8 个 Agent）
3. 如果 P0/P1 数量 = 0 或 round = 3：
   - 进入 Step 6（输出报告）

**增量核验优化：**
- 第 2 轮起，Agent prompt 中附加 `<previous-fixes>` 块，列出上一轮已修复的内容
- Agent 只需验证修复是否正确 + 检查修复是否引入新问题
- 不需要全量重核验（节省 context）

---

### Step 6: 输出最终报告

按 `references/report-template.md` 的格式输出核验报告。

**Verdict 判断：**
- 无 P0/P1 且 auto-fix 全部成功 → `Ready` ✓
- 无 P0 但有未修复的 P1（用户忽略的） → `Ready with notes`
- 有未修复的 P0 或 round=3 仍有 P0/P1 → `Not ready — X 个未解决问题`

---

## 优雅降级

- 如果某个 Agent 超时或返回格式异常：跳过该 Agent，在报告中标注"Agent X 返回异常，已跳过"
- 如果文档无法解析为可验证声明：提示用户"文档格式不匹配，请确保文档包含代码引用（如文件名:行号、类名.字段名）"
- 如果文件路径模式但文件不存在：报错并停止
- 如果 openspec change 模式但 change 不存在：列出可用 change 让用户选择
- 如果 A7 的 `<requirement>` 为需求过简提示：A7 执行(b)档策略——仅做可实施性评审 + 强制产出"需求简短警告"P1 发现。需求简短警告不阻塞 Verdict（作为不可自动修复的发现记录，在报告中标注"A7 需求简短警告"）
- 如果 A8 的搜索范围为空（无 openspec/specs/ 或无同 change 文档）：A8 报告"无相关文档可比对"并跳过

## 与 custom-claude-template-prod-workflow 的集成

当 doc-verify 作为 custom-claude-template-prod-workflow 步骤 2.5 被调用时：

1. 使用 `--change <change-name>` 模式
2. 从 openspec contextFiles 读取 proposal + design + specs + tasks
3. 闭环过程中**不中断工作流**——自动修复简单问题，复杂问题记录后继续（不等待用户确认）
4. 核验结果（通过/未通过 + 发现摘要）传递给步骤 3（apply）
5. 如果步骤 2.5 未通过，在步骤 3 开始前播报警告

**独立调用时**的行为如上文所述（完整交互式流程）。

---

## Troubleshooting

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 所有 8 个 Agent 都超时 | 文档过长或引用了大量代码文件 | 将大文档拆分为模块分别核验；减少预读取的代码文件数 |
| Agent 返回非 JSON 格式 | LLM 输出格式不稳定 | Step 3.1 容错解析会自动提取 JSON；若全部失败则降低重试轮次 |
| A7 报告"需求简短警告" | 用户需求文本 < 50 字 | 补充详细需求描述后重新核验，或接受警告继续 |
| A8 报告"无相关文档可比对" | 无 openspec/specs/ 或无同 change 文档 | 正常现象，不阻塞核验 |
| 自动修复后引入新问题 | 行号偏移修正可能连锁影响 | Step 5 闭环机制会在第 2 轮检测到并回退 |
| 核验报告全是 P2/P3 | 文档与代码基本一致 | 正常结果，Verdict 为 `Ready` |
| 3 轮后仍有 P0 未解决 | 文档与代码存在根本性差异 | 需要人工介入，对比文档和代码决定以哪个为准 |
