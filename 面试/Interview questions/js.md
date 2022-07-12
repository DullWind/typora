一.使用构造函数实现一个类Foo，需要有属性 count, 方法bar(), 并且写出创建该类对象的方法

```javascript
function Foo(){
	this.count = 0;
}
Foo.prototype.bar = function(){};
```

二.undefined 与 null

null 代表没有对象，典型用法是1）作为函数的参数，表示该函数参数不是对象。2）原型链的终点

undefined 代表“缺少值”，用法有1）变量被声明但没有定义。2）调用函数应该提供但没有提供。3）对象没有赋值的属性，该属性为undefined。4）函数没有返回值，默认返回undefined

三.强制转换

1. praseInt()
2. praseFloat()
3. Numer()

四、使用use strict

1. 消除js的一些不合理用法
2. 消除代码运行的不安全之处
3. 增加运行速度

五、闭包---隐藏一个变量

1. 局部变量
2. 能够访问到这个变量（可以使用return 或 插入到window里）
3. 变量不会被垃圾回收机制回收

六、暂时性死区

1. 一个变量在定义前使用。

七、es6新增特性

1. let关键字
2. 变量不允许重复定义
3. 不存在变量提升
4. const 定义常量
5. 箭头函数
6. 字符串模板``----里面可以包含变量${varible}
7. set 和 map
8. 类

八、

1. call，apply 立即调用。bind返回一个绑定this对象的函数。
2. apply 的参数是数组
