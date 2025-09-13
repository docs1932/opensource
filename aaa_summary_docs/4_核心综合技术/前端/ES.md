
# 1.基础知识
## 1.1 变量
```
小 tips: 如果暂时不确定，就先尝试先用 const, 如果后续需要修改，就使用 let
let a = 1; // 块级作用域，后续允许修改
const b = 2; // 常量，后续不允许修改
```
## 1.2 字符串声明 
```
单引号 ''
const c = 'hi'
双引号 ""
const d = "hello"
模板字符串，反引号 ``
const e = `world`;
const f = `I want to say: ${c} and ${d}`;
console.log(c)
console.log(d)
console.log(e)
console.log(f)
```

## 1.3 变量类型

```
NaN 代表 非数字
null 代表空
undefined 代表未定义
boolean 代表布尔值
number 代表数字
string 代表字符串
object 代表对象
function 代表函数
symbol 代表符号
bigint 代表大整数


class 代表类
set 代表集合
map 代表映射
weakset 代表弱集合
weakmap 代表弱映射
promise 代表promise
generator 代表生成器
iterator 代表迭代器
reflect 代表反射
proxy 代表代理
weakref 代表弱引用
```

### 1.3.6 array
```
====================================
array 代表数组: 
1.>> >>>>>>>>>>>>>>> 数组解构操作 >>>>>>>>>>>>>>>>>>>>
// 解构操作:此时直接console k1,k2,k3即可，不用再arr[0]
const [k1,k2,k3] = [1,2,3]
// 解构：别名(originKey: newKey) + 解构赋值剩余属性(...)
const {username, age: userAge, ...otherInfor} = {
  username: 'tom',
  age: 20,
  gender: 'male',
  city: 'BJ'
}
console.log(username)
console.log(userAge)
console.log(otherInfor)

2.>> >>>>>>>>>>>>>>> 数组运算 >>>>>>>>>>>>>>>>>>>>
const adam_arr1 = [1,2,3]
const adam_arr2 = [4,5,6]
const adam_arr3 = [99, ...adam_arr1, 88, ...adam_arr2, 77]
console.log(adam_arr3)
====================================
```

### 1.3.7 object
```
1.>> >>>>>>>>>>>>>>> 对象运算 >>>>>>>>>>>>>>>>>>>>
const o1 = {
  username: 'tom'
}
const o2 = {
  age: 20
}
const o3 = {
  gender: 'male',
  ...o1,
  ...o2
}
console.log('o3---------------',o3)

2>> >>>>>>>>>>>>>>> 对象功能合并 >>>>>>>>>>>>>>>>>>>>
// 对象的功能合并：把两个对象合并成一个对象
const o4 = Object.assign({}, o1, o2)
console.log('o4---------------',o4)

3.>> >>>>>>>>>>>>>>> 对象浅 copy>>>>>>>>>>>>>>>>>>>>
// 对象的浅 copy，o1 修改属性后，o5 依然是 o1原来的值
const o5 = Object.assign({}, o1)
o1.username = 'john'
console.log('o1---------------',o1)
console.log('o5---------------',o5)
```

## 1.4 表达式
```
=== 表示
!== 表示
== 
!= 
```

## 1.5 函数
### 1.5.1 箭头函数 (匿名函数的一种简写方式)
```
const sum1 = (n:number): number =>  (n + 5)
console.log('sum1--------', sum1(5))

const sum2 = (n:number, m:number): number =>  (n + 5 + m)
console.log('sum2--------', sum2(5, 9))

# 可变参
const sum3 = (k1: number, k2: number, ...k3: number[]): number =>
    k1 + k2 + k3.reduce((sum, cur) => sum + cur, 0);
console.log('sum3--------', sum3(1, 2))
console.log('sum3--------', sum3(1, 2,3))
console.log('sum3--------', sum3(1, 2,3,4))
```

## 1.6 类
### 1.6.1 基本使用：extends, override
```
class Bird {
  // 构造器
  constructor(public name:string, protected age:number) {
    // 有了修饰符 public/protected等之后，这里就不用写了
    //this.name = name
    //this.age = age
  }

  // 普通方法
  public execute(count: number) {
    console.log(`I am: ${this.name}, my age is: ${this.age}, the count is: ${count}`)
  }
}
const brid1 = new Bird('bird: tom', 2)
console.log(brid1)
console.log(brid1.name)
brid1.execute(1999)

class LittleBird extends Bird {
  constructor(public override name:string, protected override age:number, protected gender:string) {
    super(name, age)
  }
  // 普通方法
  public override execute(count: number) {
    console.log(`======== I am: ${this.name}, my age is: ${this.age}, the count is: ${count}`)
  }
}
const littleBird1 = new LittleBird('lb', 3, 'male')
console.log(littleBird1)
littleBird1.execute(888)

```

### 1.6.2 属性/方法修饰符: public(缺省默认值), protected, private, readonly

# 2.Promise & Async
```
常见的异步任务: setTimeout, setInterval, fetch, ajax, axios, request, ...
```

## 1.7 接口
```
使用范围：
1.定义对象的结构：描述数据模型，，描述对象结构，API  响应格式等，开发中用的最多的场景
2.类的契约：规定一个类要实现哪些属性和方法
3.自动合并：扩展第三方库的类型，在大项目中可能会用到
```
### 1.7.1 接口定义类的结构
```
interface IPersoon {
  name: string
  // 可选属性
  age?: number
  speak(words:string):void
}

class Person implements IPersoon {
  constructor(public name: string, public age:number) {}
  speak(words: string): void {
      console.log(`${this.name} is ${this.age} years old and is speaking: ${words}`)
  }
}

const xiaoming = new Person("xiaoming", 15)
xiaoming.speak("Hello World!")
```

### 1.7.2 接口定义对象 (匿名内部类)
```
const linda: IPersoon = {
  name: "linda",
  speak(words:string):void {
    console.log(`Hahaha, ${this.name} is speaking: ${words}`)
  }
}
linda.speak("niunai")
```

### 1.7.3 接口定义方法 (函数式接口)
```
interface ISum {
  sum(m:number, n?:number):number
}

const my_sum: ISum = {
  sum(m):number {
    return m + 1
  }
}
console.log(my_sum.sum(1765))
```

### 1.7.4 接口之间也是可以继承的
```
interface IAnimal {
    name: string
}
interface IDog extends IAnimal {
    age: number
}
```

### 1.7.5 接口的自动合并
```
interface IAnimal {
 name: string
}
interface IAnimal {
 age: number
}
const animal: IAnimal = {
    name: "tom",
    age: 3
}
```

### 1.7.6 接口和 type 的区别
```
1.同：
interface 和 type 都可以用于定义对象结构，在很多场景中可以互换

2.不同点:
interface: 更专注于对象和类的结构，支持合并和继承
type: 可以定义类型别名，联合类型，交叉类型，不支持继承和合并
```

## 1.8 泛型

## 2.1 Promise
```
const promise1 = new Promise((resolve, reject) => {
  resolve("p1 成功!")
})
promise1.then(data => {
  console.log(data)
  return new Promise((resolve, reject) => {
    resolve("p2 成功!")
  })
}, err => {
  // return new Promise((resolve, reject) => {
  //   reject("p1 失败")
  // })
  throw new Error("p1 失败")
})
.then(data => {
    console.log(data)
}, err => {
  // return new Promise((resolve, reject) => {
  //   reject("p2 失败")
  // })
  throw new Error("p2 失败")
})
```

## 1.9 异常处理

## 2.2 Async + await
```
// 这里返回一个 Promise
function compute(count: number) {
  return new Promise((resolve, reject) => {
    if (count > 0) {
      resolve(`Success: ${count}`)
    } else {
      reject(`Failure: ${count}`)
    }
  })
}

// 这里函数需要使用 async 关键字修饰
async function getStu(count: number) {
  console.log("111111")
  // 这里的 await 关键字，会等待 compute() 返回结果，然后把结果赋给 data
  const data = await compute(count)
  console.log(data)
  console.log("2222")
}

getStu(-9)
```

# 3.Proxy
```
interface Student {
  name: string;
  age: number;
}

const adam_c1 = document.getElementById('adam_c1') as HTMLElement | null;

const stu: Student = { name: '张三', age: 50 };

const p1 = new Proxy<Student>(stu, {
  get(target, property: PropertyKey, receiver) {
    // 使用 Reflect 更规范
    return Reflect.get(target, property, receiver);
  },
  set(target, property: PropertyKey, value, receiver) {
    const result = Reflect.set(target, property, value, receiver);

    // 只有当属性属于 Student 类型时才更新 DOM（可选）
    if (typeof property === 'string' && (property in target)) {
      if (adam_c1) {
        adam_c1.textContent = String(value);
      }
    }

    return result; // 必须返回 boolean
  }
});
```

# 4.Module (ES module --> 可以在浏览器端使用)
## 4.1 常用方案
```
✅ 方法一：使用 export 关键字逐个导出（推荐，最清晰）=============
// utils.js
export const name = "张三";
export const age = 20;

export function sayHello() {
    console.log("Hello");
}

export class Person {
    constructor(name) {
        this.name = name;
    }
}

✅ 方法二：在文件末尾统一导出（适合已有代码批量改造）
// utils.js
const name = "张三";
const age = 20;

function sayHello() {
    console.log("Hello");
}

class Person {
    constructor(name) {
        this.name = name;
    }
}

// 一次性导出所有
export { name, age, sayHello, Person };
```
## 4.2 实践
```
1.在引入 js 文件的地方配置: type="module"
 <script type="module" src="./js/app.js"></script>
 
2.export 的文件: adam.ts
export const adam_var:string = "hello world"

export const adam_fn = function sum(m:number, n:number):number {
  return m + n
}

export default {
  "username": "AZ",
  "age": "100",
}

3.import 的文件: app.ts
import {adam_var, adam_fn} from '../test/adam'
import adam_module from '../test/adam'
console.log(adam_var)
console.log(adam_fn(1, 2))
```

# 5.Module (CommonJS --> 只能在 Node.js 中使用，，，不可以运行在浏览器 !!!)
```
1.定义一个 模块 a2.js
module.exports = {
  a2_name: 'zzz',
  a2_age: 1000
}
2.导入
const a2 = require('./a2')
console.log(a2.a2_name)
```

