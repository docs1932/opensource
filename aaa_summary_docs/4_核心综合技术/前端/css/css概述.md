
# 1.概述

## 1.2 css, scss, sass, less, tailwindcss
```
✅ 当前主流趋势
SCSS：依然是大多数企业级项目的主流（尤其是 Angular、传统 React/Vue 项目）。
Less：热度下降，主要遗留在 Ant Design 等特定生态。
Tailwind CSS：近几年最火的趋势，特别是在新项目、创业公司、个人项目和部分大厂（GitHub Copilot UI、Laravel、Vercel 项目都用）。

📊 从社区和招聘趋势看：
企业项目 / 传统团队：SCSS 更稳妥。
新项目 / 敏捷开发 / 初创公司：Tailwind CSS 更流行。
Less：除非你必须和 Ant Design 等库紧耦合，否则很少再单独选择。

✅ 总结建议
如果你在学 Angular → 推荐 SCSS（Angular CLI 默认支持，生态成熟）。
如果你要做 新项目 / 想快速出 UI / 不想管理样式架构 → Tailwind CSS 是更潮流的选择。
Less 不建议新学，除非你所在团队有遗留代码或 UI 库强绑定。
```

# 2.常用属性
## 2.1 z-index
```
z-index 是 CSS 中用于控制元素在 Z 轴（垂直于屏幕方向）上的堆叠顺序的属性。理解它需要先了解“层叠上下文（Stacking Context）”和“层叠顺序（Stacking Order）”。

z-index 只对定位元素（position 不为 static）生效
它决定了元素在 Z 轴上的“前后”关系：值越大，越靠近用户（显示在上层） 

/* 以下 position 值才能使用 z-index */
position: relative;
position: absolute;
position: fixed;
position: sticky;

/* 以下 position 值 z-index 无效 */
position: static; /* 默认值 */

/* z-index 合法的取值 */
auto: 默认值，不创建新层叠上下文，继承父级堆叠顺序
<integer>: 整数（可正可负），值越大越靠前
    • 现代浏览器：±2147483647（32位有符号整数）
    • 实际建议：用合理值（如 1, 10, 100, 1000）
inherit: 继承父元素的 z-index
```

## 2.2 clip-path
https://bennettfeely.com/clippy/

```
------ html  ------
<div class="clip-path-container"></div>

------ css  ------
.clip-path-container {
  width: 300px;
  height: 300px;
  background: red;
  background-size: cover;
  transition: all ease 2s;
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  &:hover {
    clip-path: circle(50% at 50% 50%);
  }
}
```

## 2.3 perspective

