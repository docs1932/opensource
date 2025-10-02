

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

