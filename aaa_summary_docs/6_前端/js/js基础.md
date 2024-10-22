
# 1.变量
## 1.1 变量定义
```
1.弃用 var，建议使用 const 和 let 来定义变量
2.定义一个变量时，优先使用 const 来定义变量；若后续发现其地址会发生变化，再改为 let(不改会报错)
3.let 经常定义基本数据类型，如 let a = 100；
4.const 经常用于定义复杂数据类型，如对象或者数组，
例如 const a = {name: 'tom', age: 30};
a.name = 'tom1';
5.当然，当对象或者数组的地址也会发生变化时，再改为 let 定义变量，例如：
6.let a = {name: 'tom', age: 30};
a = {m: 'm1', n:'n1'};
```

# 2.事件
```
1.mouseover 和 mouseout 会有冒泡效果
2.mouseenter 和 mouseleave 不会有冒泡效果 (推荐使用)
```

## 2.1 事件分类

## 2.2 事件流
```
事件流指的是事件完整执行过程中的流动路径。
```
### 2.2.1 事件流分类：事件流的捕获与冒泡
[事件捕获与冒泡](bubble.html)

```
1.捕获阶段：从 DOM 的根元素去执行对应的同名事件(从外到里，如 click 事件)
Document --> Window --> HTML --> body --> div --> p --> span --> 事件目标
2.冒泡阶段：
事件目标 --> span --> p --> div --> body --> HTML --> Window --> Document

简言之，
捕获阶段是从父到子调用同名事件，冒泡阶段是从子到父调用同名事件
```


### 2.2.2 事件流处理：事件流的解绑与阻止冒泡
#### 2.2.2.1 阻止事件流动：阻止冒泡/阻止捕获
```
    const bubble_son = document.querySelector('.bubble-son');
    bubble_son.addEventListener('click',function(e){
        alert('bubble-son');
        // 阻止冒泡/阻止捕获
        e.stopPropagation();
    });
```
#### 2.2.2.2 事件的解绑
```
--------------------------------- 解绑方案1 ---------------------------------
假定事件绑定方式是：
const btn = document.querySelector('.btn');
btn.onclick = function(){
}
则对应的解绑方式是：
btn.onclick = null;
--------------------------------- 解绑方案2 ---------------------------------
假定事件绑定方式是：
    const bubble_son = document.querySelector('.bubble-son');
    const fn = function(e){
        alert('bubble-son');
        // 阻止冒泡/阻止捕获
        e.stopPropagation();
    }
    bubble_son.addEventListener('click', fn);
则对应的解绑方式是：(切记：匿名函数无法被移除，需要在绑定函数时，先定义好函数名，然后再移除)
    bubble_son.removeEventListener('click', fn);
```

