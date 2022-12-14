# 答案版

## c++

### 程序的编译过程：

1. 预编译 
   - 宏定义进行替换，处理所有条件预编译指令，如#if,#endif
   - 处理#include预编译指令，将文件内容进行替换
   - 删除注释
   - 保留所有#pragma编译器指令，如#pragma once
   - 添加行号和文件标识
2. 编译
   - 预编译之后会生成xxx.i文件
   - inline展开
   - 进行词法分析，语法分析，语义分析，优化，目标代码生成，目标代码优化
3. 汇编
   - 汇编--将汇编代码转变成机器可执行指令，产生目标文件xx.o
4. 链接
   1. 将不同源文件进行链接，从而形成一个可执行文件
   2. 分为静态链接和动态链接

### 程序的内存分配

1. 栈，堆，全局/静态区，常量区，代码区

### 原码，反码，补码

1. 原码：十进制转二进制，得到的就是原码。符号位 + 二进制标识
2. 反码：为了实现，两个相反的数相加等于0
   1. 反码的负数相加出错，其实问题不大。我们只需要加实现两个负数加法时，将两个负数反码包括符号位全部按位取反相加，然后再给他的**符号位强行置‘1’**就可以了。
   2. 表示
      - 正数的反码不变
      - 负数的反码 = 符号位不变 + 其他位取反
3. 补码：
   1. 补码的引入是为了解决减法问题
   2. 表示：
      1. 反码+1
   3. 定义：类似于时钟的原理，10 - 2 = 10 + 10 = 8 点。它之所以等于反码+ 1 ，只是因为正好可以这样算而已。

### new ，delete和 malloc,free

1. new,delete 是操作符，而mallco ,free是函数
2. new 失败会报错,而mallco 是返回空
3. 使用new 时无需指定大小，而mallco 需要
4. new ,delete会调用类的构造函数(析构函数)，而mallco,free不会，因此new 返回的是指定类型的指针，而malloc 需要自己指定
5. malloc,free 支持重载

### 成员函数能不能调用delete this

1. 可以，但调用完以后不能在使用类的数据成员和虚函数

### delete 和 delete[] 区别

	1. delete 用来会调用对象的析构函数
	2. delete[] 用来会调用数组中每个对象的析构函数

### vector 和 list的区别

1. vector 底层的实现是数组，list 的底层实现是双向链表
   1. vector 查询的时间复杂度是O1，平均扩容复杂度也是O1
2. vector 是顺序内存,list 是不连续的

### set容器

1. 底层是红黑树，键和值是相同的

### 指针和引用的区别

1. 指针是一个变量，只是指针存储的是一个地址，引用是变量的一个别名
2. 引用不可以为空，没有const 引用
3. sizeof 指针返回的是指针大小，引用返回的是对象大小
4. 指针可以有多级
5. 自增含义不一样

### 四大转换

1. static_cast:强制类型转换
   1. 没有类型检测
   2. 用于类层次中基类和派生类之间指针和引用的类型转换
   3. 基本数据类型之间的转换
   4. 空指针转为目标类型指针
2. dynamic_cast 
   1. 有类型检查
   2. 一般用于基类向派生类之间指针类型转换
3. const_cast
   1. 常量指针转为非常量的指针
   2. 一般用来修改底层指针（const char* p）
4. reinterpret_cast
   1. reinterpret_cast<type-id> (expression)
   2. type-id 必须是一个指针、引用、算术类型、函数指针或者成员指针。它可以用于类型之间进行强制转换。

### 右值引用

1. 右值：与左值相对的概念，c++里的一个表达式的值不是左值就是右值，左值指的是可以拥有名字的变量，比如 int a = 19;a 就是左值，19就是右值。

   1. 纯右值：临时变量，不与对象关联的字面常量
   2. 将亡值：当用一个右值去初始化一个对象时，会调用相应的移动构造函数或者移动赋值函数，同时该右值会被马上销毁。这就是将亡值。

2. 当一个对象被用作右值时，用的是对象的值。当被用作左值时，用的是对象的身份（在内存中的位置）

3. 右值引用：必须绑定到右值的引用。

4. std::move（）：将一个左值变为一个右值：将对象的状态或者所有权从一个对象转移到另一个对象，只是转移，没有内存的搬迁或者内存拷贝。

   相当于告诉编译器：我们有一个左值，但我们希望像一个右值一样处理它。
   
5. std:: forward () 完美转发

### 面向对象3个特征

1. 继承：让某种类型对象获得另一个类型对象的属性和方法
2. 封装：数据和代码绑定在一起不受外界干扰，把客观事物封装成抽象的类
3. 多态：重载实现编译时多态，虚函数实现运行时多态

### 构造函数初始化列表和函数体有什么不同

1. 初始化列表会比在函数体内赋值，少调用一次构造函数。

### 智能指针

1. share_ptr: 可以有多个对象拥有这个指针，但会出现循环引用的错误。可以使用weak_ptr 解决

2. unique_ptr: 同时只能有一个unique_ptr指向给定对象，可以通过reset方法重新指定。

3. auto_ptr : 主要是为了解决“有异常抛出时发生内存泄漏”的问题；抛出异常，将导致指针p所指向的空间得不到释放而导致内存泄漏；

4. auto_ptr构造时取得某个对象的控制权，在析构时释放该对象。我们实际上是创建一个auto_ptr类型的局部对象，该局部对象析构时，会将自身所拥有的指针空间释放，所以不会有内存泄漏；

5. 手撕

   ```c++
   template<class T>
       class IntelPtr {
       public:
           IntelPtr(T* ptr = nullptr) : _ptr(ptr),_count(new int(0)) {}
           IntelPtr(IntelPtr& ip) {
               this->_ptr = ip._ptr;
               this->_count = ip._count;
               *(this->_count)++;
           }
           IntelPtr<T>& operator=(const IntelPtr& s) {
               if (this != &s) {
                   if (--(*(this->_count)) == 0) {
                       delete this->_ptr;
                       delete this->_count;
                   }
                   this->_count = s._count;
                   this->_ptr = s._ptr;
               }
               return *this;
           }
           T& operator*() {
               return *(this->_ptr);
           }
   
           T* operator->() {
               return this->_ptr;
           }
           ~IntelPtr() {
               if (--(*(this->_count)) == 0) {
                   delete this->_ptr;
                   this->_ptr = nullptr;
                   delete this->_count;
                   this->_count = nullptr;
               }
           }
   
       private:
           T* _ptr;
           int* _count;
       };
   ```

   

### c++ 和lua 怎么进行交互

1. c++调用lua

   1. 通过一个虚拟堆栈，lua 提供了c api 来对栈进行操作
   2. 函数调用流程是先将函数入栈，参数入栈，然后用lua_pcall调用函数，此时栈顶为参数，栈底为函数，所以栈过程大致会是：参数出栈->保存参数->参数出栈->保存参数->函数出栈->调用函数->返回结果入栈。

2. lua调用c++

   1. 注意：函数要遵循规范,要接收一个lua_state作为参数,同时返回一个整数（lua可以有多个返回值）
   2. 将函数写入lua.c中，然后重新编译lua文件
   3. 静态依赖的方式：在vc++目录中，把lua中的头文件和lib文件的目录包含进来，然后->链接器->附加依赖项->将lua51.lib和lua5.1.lib也包含进来。
   4. 大概顺序是：我们在c++中写一个模块函数，将函数注册到lua解释器中，然后由c++去执行我们的lua文件，然后在lua中调用刚刚注册的函数

3. 总结：lua和c++是通过一个虚拟栈来交互的。

   c++调用lua实际上是：由c++先把数据放入栈中，由lua去栈中取数据，然后返回数据对应的值到栈顶，再由栈顶返回c++。

   lua调c++也一样：先编写自己的c模块，然后注册函数到lua解释器中，然后由lua去调用这个模块的函数。
   
   https://blog.csdn.net/v_xchen_v/article/details/77249332

### 手写单例

```c++
 mutex mtx;
    class MyClass {
        static MyClass* _instance;
        static MyClass* getInstance() {
            if (_instance == nullptr) {
                mtx.lock();
                if (_instance == nullptr) {
                    _instance = new MyClass();
                }
                mtx.unlock();
            }
            return _instance;
        }
    private:
        MyClass() {};
    };
```

### 反码uint8的范围

1. uint8 ： 8位无符号整型，范围是 0 ~256-1
2. 数据在计算机中用补码储存

### const int*  p，int const * p , int* const  p的区别

1. cons int * == int const * 都是顶层const，指的是p所指向的地址里的值不可改变
2. int * const p 指的是p这个指针是个常量不可改变。

### 访问栈的速度比堆块的原因

1. 访问堆，需要借助中间指针
2. 栈更集中，访问频繁，容易缓存命中
3. 栈页不会被从内存中换出

### 在栈上分配内存和在堆上分配内存哪个更快？

1. 肯定是栈快
2. 栈上的内存是连续的，如果想要申请内存直接在当前地址上向下申请一块内存就好，而在堆上，需要去计算内存地址，如果内存不够还需要页面置换。

### 函数签名

1. 参数以及参数类型

2. 返回值及其类型

3. 函数名

4. 函数的后置const 算函数重载

   ```c++
    class MyClasss {
       public:
           void test(int a, int b) { 
               cout << a + b;
           }
           void test(const int a, int b) { // 不算函数重载
               cout << a - b;
           }
           void test(int a, int b) const { // 算函数重载
               cout << a - b;
           }
       };
   ```

   

### static关键字的作用

1. 修饰全局变量和函数：只在同一文件内可见，默认初始化。定义后始终存在。
2. 修饰类：静态的成员变量只与类有关，与对象无关。静态的成员函数，不具有this指针。无法访问类的非static成员。

### 资源管理,如何确保内存被正确释放

1. 用对象的方式来管理指针。（RALL）
2. 一个new 对应一个 delete
3. 删除对象数组时，使用delete[]

### map 和 unordered_map

1. map 
   - 底层是红黑树
   - 数据有序
2. unordered_map
   - 底层是哈希表
   - 数据无序

### lambda

1. 可以编写内嵌的匿名函数

2. 必须包含捕获列表和函数体

3. 需要指定返回类型

4. 捕获列表分为值捕获和引用捕获，如果是值捕获，值是在lambda创建时拷贝的

5. [==]：隐式的值捕获 。[&]隐式的引用捕获。

   ```c++
   [capture] （parameters） mutable ->return-type {statement};
   ```

### 同步方式

1. 临界区：通过对多线程的串行化来访问公共资源或一段代码
2. 互斥对象（mutex）：只有拥有互斥对象的线程才有访问公共资源的权限。
3. 信号量：信号量也是内核对象。它允许多个线程在同一时刻访问同一资源，但是需要限制在同一时刻访问此资源的最大线程数目
4. 事件对象： 通过通知操作的方式来保持线程的同步，还可以方便实现对多个线程的优先级比较的操作

### c++ 异常处理

1. 优点：使代码更加整洁，且易于维护。允许函数抛出异常给它的调用者

2. 缺点：增加一些性能开销，如果在构造函数或者析构函数中发生异常，容易导致内存泄漏

   ```c++
   try{
   
   }
   catch(){
   
   }
   ```


### set容器

1. 数据结构：底层使用平衡的搜索树——红黑树实现
2. 插入删除操作时仅仅需要指针操作节点即可完成，不涉及到内存移动和拷贝
3. set中元素都是唯一的，而且默认情况下会对元素自动进行升序排列
4. set内部元素也是以键值对的方式存储的，只不过它的键值与实值相同
5. set中不允许存放两个实值相同的元素
6. 迭代器是被定义成const iterator的，说明set的键值是不允许更改的，并且不允许通过迭代器进行修改set里面的值
7. set容器的键和值是相同的

### 字节序

1. 小端字节序：低字节存放在内存低地址

2. 大端字节序：高地址存放在内存低地址q

3. ```c++
   void check_cup(void) {
       int a = 0x0102;    
       char *p = (char *)&a; 
       if (*p == 2)  puts("Big endian."); 
       else if (*p == 1) 
           puts("Little endian.");
   }
   ```

   

### c++ 14 新特性

1. 函数返回值类型推导
2. lambda表达式参数可以直接是auto
3. std::make_unique（与make_share相类似）
4. C++14引入std::quoted用于给字符串添加双引号，直接看代码
5. std::exchange （好像是完美转发一个值给另一个值）

### 为什么函数声明在.h文件中 函数定义在.cpp文件中

1. 因为函数可以有多次声明，但只能有一次定义。如果把函数定义在头文件中，然后有多处地方引用了这个头文件，就会出错。

### 隐式转换禁用

1. 在构造函数后面声明 == explicit

### placement new

1. `placement new`将在这块内存空间上构造对象

2. ```c++
   // pre-allocated buffer
   void *buf  = ::operator new(sizeof(string)); 
   // placement new
   string *p = new(buf) string("hi");    
   ```

### deque 实现

1. deque 实现为分段的数组，同时还维护一个数组，用来存放各个数组的首地址。
2. 在插入的时候，如果当前分段的数组已经满了，它就会创建新的数组。并把该分段的首地址放在索引数组里。因此双端队列在两端插入数据时会很快，但在中间插入的时候要移动数据就会很满。

### 虚函数可以是内联函数吗

1. 不可以，
2. 内联函数时在编译阶段就会确定下来。虚函数在运行时才确定。

### 写一个模板swap函数, 为什么形参是引用, 特化一个char *版本的, std::move是否可以用在swap中

```c++
 template<typename T1>
    void mySwap(T1& a, T1& b) {
        cout << "模板" << endl;
        T1 temp(a);
        a = b;
        b = temp;
    }   

    template<>
    void mySwap<char*>(char*& a, char*& b) {
        cout << "特化" << endl;
        char* temp(a);
        a = b;
        b = temp;
    }
    
```

### 内存对齐

#pragma pack(n):每个特定平台上的编译器都有自己默认的对齐系数，程序员可以通过预编译指令#pragma pack(n),n=1,2,4,8,16来改变这一系数

​	数据成员对齐规则：结构或联合的数据成员，第一个数据成员在offset为0的地方，以后每个数据成员的对齐方式都按照#pragma pack指定的数值和这个数据成员自身占用内存中比较小的那个进行。
​    结构或联合整体对其原则：在数据成员完成自身对齐后，结构或联合本身也要进行对齐，对齐按照#pragma pack(n)指定的数值和结构或联合最大数据成员占用内存中比较小的那个进行。
### 其他

1. 栈的大小是1M
2. sizeof(string) = 20

