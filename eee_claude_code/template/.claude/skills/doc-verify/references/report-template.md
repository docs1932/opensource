# doc-verify Report: {document_name}

**核验时间:** {timestamp}
**核验轮次:** {round}/3
**文档路径:** {document_path}

---

## Summary

| 维度 | 状态 |
|------|------|
| 字段一致性 (A1) | {verified_count}/{total_count} 正确, {issue_count} 问题 |
| 行号准确性 (A2) | {verified_count}/{total_count} 正确, {issue_count} 偏移 |
| 逻辑一致性 (A3) | {verified_count}/{total_count} 匹配, {issue_count} 偏差 |
| 枚举/字典 (A4) | {verified_count}/{total_count} 准确, {issue_count} 冲突 |
| 影响范围 (A5) | {covered_count} 项已覆盖, {missing_count} 项遗漏 |
| 边界条件 (A6) | {covered_count}/{total_count} 已覆盖, {missing_count} 遗漏 |
| 需求覆盖度 (A7) | {covered_count}/{total_count} 已覆盖, {missing_count} 遗漏 |
| 跨文档一致性 (A8) | {consistent_count}/{total_count} 一致, {conflict_count} 矛盾 |

---

## P0 — Critical (必须修复)

| # | 文档位置 | 问题 | Agent | 建议 |
|---|---------|------|-------|------|
| 1 | {doc_location} | {title} | {agents} | {suggested_fix} |

## P1 — High (应该修复)

| # | 文档位置 | 问题 | Agent | 建议 |
|---|---------|------|-------|------|
| 1 | {doc_location} | {title} | {agents} | {suggested_fix} |

## P2 — Moderate (建议修复)

| # | 文档位置 | 问题 | Agent | 建议 |
|---|---------|------|-------|------|
| 1 | {doc_location} | {title} | {agents} | {suggested_fix} |

## P3 — Low (可选)

| # | 文档位置 | 问题 | Agent | 建议 |
|---|---------|------|-------|------|
| 1 | {doc_location} | {title} | {agents} | {suggested_fix} |

---

## Auto-fixed

| # | 类型 | 原始 | 修正 |
|---|------|------|------|
| 1 | 行号偏移 | InvoiceServiceImpl:123 | InvoiceServiceImpl:122 |
| 2 | 字段名修正 | OrderProductDO.deptId | OrderProductDO.sellDeptId |

---

## 现有 BUG 发现

| # | 文件 | 行号 | BUG 描述 | 严重度 |
|---|------|------|---------|--------|
| 1 | {file} | {line} | {description} | {severity} |

---

## 用户确认忽略

| # | 问题 | 忽略原因 |
|---|------|---------|
| 1 | {title} | 用户确认 |

---

## Verdict

**{Ready / Ready with notes / Not ready}**

{verdict_detail}
