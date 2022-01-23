# Effective c++

客户（client）是指某人或某物。他使用你写的代码（通常是一些接口）。在某个时间点你几乎必然发现，你就你自己的客户。那个时候你很很高兴你在**开发接口时把客户放在心上**。

### 1. 视c++ 为一个语言联邦

1. c
2. object-oriented C++
3. Template c++
4. STL

### 2.尽量以const，enum，inline 替换#define 

1. 每个函数的声明揭示其签名式（signature），也就是参数和返回类型。

2. 如果编译器不允许“static 整数型class 常量”完成“in class ”初值设定。可以改用“the enum hack"补偿做法。

   ```c++
   class MyClass{
   	enum {
   		num = 6;
   	}
   	int m_scores[num];
       int m_a;
       char m_c;
   }
   ```

### 3.尽可能使用const

1. 两个函数如果只是常量（constness）不同，也可以被重载。
2. const 成员函数调用non-const成员函数是个糟糕的选择（const 承诺了不会改变其内部数据）。但反过来却可以。（通过两次转型动作）

### 4.确定对象被使用前已被初始化

1. 对象成员变量的初始化动作发生在进入构造函数前。

2. 推荐在构造函数时使用初始值列表**初始化**，而不是在构造函数里**赋值**。（同时初始值列表列出的成员变量，最好与他们在class中声明的顺序相同）

   ```c++
   MyClass::MyClass(int a,char c):m_a(a),m_c(c){}
   ```

3. 如果一个值是const或references,则必须使用初始值列表初始化。

4. non-local staic(extern 声明的变量）可能会有初始化顺序的问题。推荐使用local staic。 

## 构造/析构/赋值运算

### 5.了解c++默认编写并调用了哪些函数

1. 构造
2. 析构
3. 拷贝构造
4. 赋值构造  

### 6.若不想使用编译器自动生成的函数，就该明确拒绝

### 7.为多态基类声明virtual析构函数

1. 不是所有基类的设计都是为了多态，有可能是为了屏蔽拷贝构造函数（P39）

### 8.别让异常逃离析构函数(不甚理解)

1. `std::abort()`结束进程
2. 析构函数不应该抛出异常。可以选择捕捉他们然后当做没看见或者直接结束程序。`try{}catch(){}`
3. 如果客户需要对某个操作运行期间抛出异常做出反应，应该提供一个普通函数执行这个操作，而非放在析构函数中

### 9.绝不在构造函数和析构函数中调用virtual函数

### 10.令operator= 返回一个reference to *this

### 11.在operator= 中处理“自我赋值”

一般发生在一个类中有个类类型

1. 比较是否是同一地址
2. 合适的语句顺序
3. copy-and-swap(通过值传递和swap实现)

### 12.复制对象时勿忘记复制其每一个成分

1. 复制所有local 成员变量
2. 如果基类的拷贝函数是自己定义的，在子类中也请显示的调用他们。
3. 不要尝试拷贝构造和拷贝赋值互相调用。

## 资源管理

### 13.以对象管理资源

资源指的是，一旦你用了它，将来必须还给系统。比如说，内存，互斥锁，网络socket，数据库连接，以及图形界面中的字型和笔刷。（后面几个都不懂）

1. 将资源的管理权限移交给对象而不是程序员。有个具体的例子就是智能指针（shared_ptr 和auto_ptr）。当它离开它的作用域时，它会自动销毁它指向的对象。就避免了内存泄漏的可能。 
2. 获得资源后立刻放进管理对象。资源取得时便进行初始化。在离开时得到释放（RALL）
3. 管理对象运用析构函数确保资源被释放。

指针在销毁时不会释放其所指向的资源，但对象销毁时会调用其析构函数。

### 14.在资源管理类中小心copying行为

1. RALL拷贝时记得使用深拷贝
2. copying 有三种选择
   1. 禁止拷贝
   2. 施行引用计数
   3. 使用智能指针shared_ptr(ptr,destruct)。它允许自定义析构函数。

### 15.在资源管理类中提供对原始资源的访问

1. apis往往要求取地原始资源，因此每个RALL class 都应该提供一个“取得其所管理资源”的办法。
2. 对资源的访问有显示转换和隐式转换两种选择。

### 16.成对使用new 和 delete 时要求采取相同的形式

1. 注意区分delete 和 delete[]
2. 如果你在创建对象时使用，new的表达式中使用[],则在delete中也需要使用[]；

### 17. 以独立语句将newed对象置于智能指针内

1. 如果不这么，一旦异常抛出，会有内存泄漏的风险。（编译器在执行参数列表里的函数时的顺序不是一定的）

## 设计与声明

### 18.让接口更容易被使用

1. 好的接口容易被正确使用，不易被误用（如果某个客户企图使用某个接口却没有获得他所预期的行为，这个代码不该通过编译）
2. 正确使用
   1.  接口一致性（比如c++的STL容器都有一个size（）方法，不像其他语言有的是length，count，length（）。。。）
   2. 与内置类型的兼容（如果重载 * ，返回的是一个const ，可以阻止 a * b = c）的发生。
3. 阻止误用
   1. 建立新类型，限制类型
   2. 消除客户的资源管理责任（RALL）
   3. shared_ptr 支持定制性删除器。可以防止dll问题。

### 19.设计class犹如设计type

1. 新的type的对象应该如何被创建和销毁
2. 对象的初始化和对象的赋值该有什么样的差别
3. 新type的对象如果被passed by value,意味着什么
4. 什么是新type的”合法值“
5. 你的新type需要配合某个继承图系
6. 你的新type需要什么样的类型转换
7. 什么样的操作符和函数对此新type而言是合理的
8. 什么样的标准函数应该被驳回
9. 谁该取用新type的成员
10. 什么是新type的”未声明接口“
11. 你的新type有多么一般化
12. 你是否真的需要一个type

### 20.多用引用传递代替值传递

1. 这一条规则对内置数据类似不管用

### 21.必须返回对象时，别妄想返回其reference

1. 不要返回一个指针或者引用指向一个栈内对象。
2. 不要返回一个引用指向堆对象。
3. 不要返回一个指针或引用指向local static 对象（当可能有多个这个对象时）

### 22.将成员变量声明为private

1. 为了封装性。可以赋予客户访问数据的一致性。细微划分访问控制，允许约束条件以获得保证，并提供class作者以充分的实现弹性。
2. protected 不比public 更有封装性

### 23. 宁以non-member,non-freiend 替换 member 函数（在可以实现相同功能的前提下）

1. 这样做可以增加封装性，包裹弹性和机能扩充性
2. 选择non-member并不会增加“能够访问class内之private成分“的函数数量
3. 越多函数可以访问私有的数据，数据的封装性越低。
4. 封装：意味着我们能够改变事物而只影响有限客户 。

### 24.若所以参数都需要类型转换，请采用non-member函数

1. 因为成员函数会隐身传递一个this指针，这个指针无法发生隐式类型转换。所以需要声明为非成员函数。

### 25.考虑写出一个不抛异常的swap函数

1. swap 主要有两个职责

   1. 提供便捷高效的置换两个值
   2. 帮助class提供异常安全性保障

2. c++ 内置版本的定义

   ```c++
   namespace std{
   	template<typename T>
       void swap(T& a ,T& b){
           T temp(a);
           a = b;
           b = temp;
       }
   }
   ```

3. 如果你嫌以上函数效率不高，你可以自己定义一个swap成员函数，但要确保不会抛出异常。

4. 如果你提供了一个member swap。也要提供一个non-member swap  来调用前者。如果参数类型是class ，请提供特化 std::swap。如果不是直接覆盖它就好（**注意：**不能再全局空间内直接定义，c++委员会不允许我们改变std命名空间内的东西，因此我们可以自己定义一个命名空间，然后重载swap）。

5. 调用swap时应针对std::swap 使用using 声明式(不能直接调用std::swap。因为这样会显示强制调用std里的swap),然后调用swap。

6. 对类类型进行std templates 全特化是好的，但不要在std里加入全新的东西。

## 实现

### 26.尽可能延后变量定义式的出现时间

1. 当你确定需要用到变量时再定义。

### 27.尽量少做转型动作

1. c++ 有四种新的转型动作
   1. const_cast<T> (expression)  // c++里唯一用来从const 转为非const 的类型转换。
   2. dynamic_cast<T>(expression) //安全向下转型
   3. reinterpret_cast<T> (...) //执行低级转型
   4. static_cast<T>(...) //强迫隐式转换
2. 类型转换实际上会改变内存数据。比如int转double
3. 如果转型是必要的，试着将它隐藏再某个函数后面。
4. 尽量使用c++的类型转换

### 28.避免返回handles指向对象的内部成分

1. handles(号码牌)：reference，指针，迭代器（用来取得某个对象）
2. 这个条框可增加封装性。帮助const成员函数的行为像个const，避免“虚吊号码牌”（空悬指针）的发生。

### 29.为“异常安全”而努力是值得的

1. 两个标准
   1. 不泄漏任何资源
   2. 不允许数据败坏
2. 三个保证（只需提供一个就好）
   1. 基本承诺：异常抛出后，所有对象处于一种前后一致的状态。数据结构不会因此受到破坏。（通常使用以对象来管理数据）
   2. 强烈保证：如果一个函数运行成功那么就成功，如果没有成功，程序会返回调用函数前的状态。（通常使用copy-and-swap,先取得副本然后操作，如果成功就将副本赋值回去）
   3. 不抛掷保证：将一个函数声明为 `int doSomething() throw();` 这并不意味着这个函数不会抛出异常，而是指如果抛出异常，将是严重错误。程序将会退出。
3. 函数中的异常安全等级，取决于函数中异常安全等级最弱的那一个。

###  30.透彻了解inlining的里里外外

1. inline 可以显示定义，在函数前面添加“inline”。也可以隐式定义，直接将函数定于类内。
2. inline并不是强制的，编译器可以选择拒绝。（一般拒绝函数指针，循环，递归或者过于复杂的代码） 
3. 一般将inline 置于头文件内，因为大多数buid environments 在编译过程中进行inlining。

### 31.将文件间的编译依存关系降至最低

1. 主要思想就是，将文件间的依存关系，相依于声明式，不要相依于定义式。由此有两个主要的方法。
   1. **Handle classes**:定义两个接口一模一样的文件。主文件内会多一个指针成员（最好是share_ptr）指向其具体实现类。这种设计通常被称为**pimple idiom**（pointer to implementation(实现) 	语法）。这个类通常称为Handle classes。这样就能实现，**接口与实现的分离**。
   2. Interface classes：有一个抽象基类，这个基类提供一个静态方法创建一个指向子类对象的基类指针。
   3. 以上两种方法都可以降低接口与实现的耦合。但也会有些额外的开销，比如handle classes 需要进行一次额外的跳转，interface classes 需要维护vptr，以及虚表。但这些都是小问题。
   4. 最后，以上这些操作都不应该是inline 操作，因为一旦inline 的函数发生变化，所有调用inline函数都要重新编译。
2. 程序库头文件应该以“完全且仅有声明式”的形式存在。

### 32.确定你的public继承塑膜出is-a 关系

1. is-a 是一种关系，代表着一种“是”的关系，比如class d("derived") 继承自 class B("Base")。意味着d 就是 B，B可以干的事情，d都可以干。但d可以干的事情，b不可以干。
2. 以上那个关系不能想当然。比如正方形就不能public 继承矩形，因为正方形的长等于宽，我们不能做到只增加他的长，而不增加它的宽。但矩形可以。

### 33.避免遮掩继承而来的名称

1. 派生类中的名称会遮掩base classes 内的名称（就算名称不一样也会遮掩，或者叫覆盖），在public继承下没有人希望如此
2. 为了解决遮掩问题可以使用using声明式，或者转交函数。
3. 说句题外话：不管派生类是怎么继承基类，只要基类成员是public 或者 protect ，派生类就可以访问（private的话派生类也不可以访问）。继承方式改变的只是类外对象访问基类成员的方式。

### 34.区分接口继承和实现继承

1. 纯虚函数意味着指定接口继承
2. 虚函数意味着提供指定接口继承以及默认的实现继承
3. 非虚函数意味着实现继承

### 35.考虑virtual 函数以外的其他选择

如果某个类重载了他的调用符，那么他就是函数对象。它可以拥有自己的的状态，在类中定义状态变量。函数对象可以有自己特有的类型。（可以被继承）

1. virtual函数的替代方法有多种
   1. NVI（non-virtual interface）,也叫做 Template Method （模板模式），跟c++ 的template 没什么关系。声明一个私有的虚函数，然后通过一个公共的函数调用它（就是将一个函数具体的实现延迟到子类）。
   2. 通过Stratery（策略模式）来代替
      1. 将函数从类内抽离出来进行封装成一个对象（可以被继承）。当需要使用时把对象做为参数重新传入就好。
      2. 将虚函数替换为“函数指针成员变量”
      3. 通过tr1::function 来替代
         - (tr1::function)它能接受任何可调用物，只要可调用物的的签名式兼容于需求端即可
         - 它可以调用bind来绑定不同的对象
2. 将成员函数移到类外部会带来一个问题，非成员函数无法访问类的保护和私有成员。当然你可以把它声明为友元函数，但这样的话就破坏对象的封装性。

### 36.绝不重新定义继承而来的non-virtual 函数

### 37. 绝不重新定义继承而来的缺省参数值

1. 静态类型：声明时所用的类型
2. 动态类型：目前所指对象的类型
3. 缺省参数值都是静态绑定的，但virtual函数却是动态绑定的。因此如果你重新定义了缺省的参数值就会导致，运行函数的时候，调用的是派生类的函数，但参数值却是基类的。

### 38.通过复合塑模出has-a 或“根据某物实现出”

1. 复合（class a 内有一个 class b 的对象）的意义和public 继承完全不一样。
2. 在应用域，复合意味着has-a(有一个)。在实现域，复合意味着is-implemented-in-terms-of（根据某物实现出）。
   - 应用域：你所塑造世界中的某些东西（人，汽车，视频等等）
   - 实现域：用于实现对象的某些细节（缓冲区（buffer），互斥器（mutexes））

### 39.明智而审慎地使用private继承

及时一个virtual 函数是私有的，派生类仍然可以重新定义它。

1. private 继承意味着is-implemented-in-terms-of(根据某物实现出)。它通常比复合的使用级别低（当你不确定要使用复合还是private的使用，就使用复合）。有两种情况下使用private是合理的

   1. 当derived class 需要访问基类的protect 成员的时候
   2. 需要重新定义基类的虚函数的时候。（可以选择重新新建一个专门的类public继承自基类，然后当前类私有的拥有新建的这个类）（复合+继承）

2. 和复合不同，private 继承可以造成empty base 最优化。比如

   ```c++
   class A{} //空类
   class B{
   	int i;
   	A a;
   } // 对象的大小会超过1
   class C : private A{
       int i;
   }// 对象大小等于4；
   ```

   这个就叫做EBO（empty base optimization）空白基类最优化

### 40.明智而审慎地使用多重继承

1. 多重继承比较复杂可能导致新的歧义性，以及对virtual继承的需要。
2. virtual 继承会增加各种成本（大小，初始化）（比如说当创建一个派生类对象的时候最先调用的是virtual基类的构造函数，然后才是自身的），最好virtual 不带有任何数据。
3. 多重继承某些时候确实有用，但尽量少用。

# 模板与泛型编程

### 41.了解隐式接口和编译期多态

1. 记得区别编译期多态和运行期多态
2. 对于classes 而言接口都是显式的，以函数签名为中心。多态则是通过virtual 发生于运行期。
3. 对template参数而言，接口是隐式的，基于有效表达式。多态则是通过template具现化和函数重载解析发生于编译期。
   1. 比如在模板里定义了w.size()。则代码w的类型有size() 这个接口

### 42.了解typename的双重定义

1. 在template的参数列表中使用typename 或者 class 没有任何区别。

2. 区分从属名称和非从属名称
   1. template内出现的名称如果相依于某个template 名称，这个就是从属名称。

   2. 如果从属名称在class内呈嵌套状，我们称他为嵌套从属名称。如C::const_iterator。

   3. 如果不依赖template参数的名称就叫非从属名称（non-dependent names）。比如int。

3. 如果解析器在template中遭遇一个嵌套从属名称，它便会假设这个名称不是一个类型。比如会把上面的`C::const_iterator` 认为是一个变量。（要解决也很简单在这个名称之前放置关键字typename）`typename C::const_iterator`

4. 不允许在base class list 内使用typename(我的理解是继承列表)

   也不允许在成员初始值列表中使用typename。

### 43.学习处理模板化基类内的名称

1. 如果继承的是一个模板类，请假设派生类对基类的内容毫无所知。因为模板可能会有特例化，它可能会有一些一般基类没有的函数。当然你可以显示指定`this->`指明基类内的成员。

## 模板相关的东西，从这里开始就不太懂了

### 44.将与参数无关的代码抽离template

1. templates 生成多个classes 和多个函数，所以任何template 代码都不应该与某个造成膨胀的template 参数产生相依关系。如

   ```c++
   template<typename T,std::size n>
   //        类型参数↑    非类型参数↑
   class Matrix{
       cout << "这是一个" << n << "阶" << 矩阵 << endl;
   }
   ```

   因此只要n发生改变，就会生成一个新的模板。

2. 因非类型模板参数而造成的代码膨胀，往往可以消除，做法是以函数参数或class 成员变量替换 template 参数。

3. 因类型参数而造成的代码膨胀，也可以降低，做法是让带有完全相同二进制表述的具现类共享实现码。

### 45.运用成员函数模板接收所有兼容类型

1. 请使用member function templates （成员函数模板）生成 ”可接受所有兼容类型“的函数。
2. 如果你声明member template 用于”泛化copy构造“或泛化  assignment 操作" 你还是需要声明正常的copy 构造函数和copy assignment 操作符。

### 46.需要类型转换时请为模板定义非成员函数

1. class template 并不依赖template实参推导，但function template 可以。
2. 当我们编写一个class template ,而它所提供之”与此template 相关的“函数支持”所有参数之隐式类型转换"时，请将那些函数定义为“class template”内部的friend 函数。（因为成员函数会隐式传递this指针，而this指针不支持隐式转换）

### 47.请使用traits classes 表现类型信息

1. 迭代器分类
   1. Input 迭代器：只能向前移，一次一步，只能读取不能改写。例子：istream_iterators。
   2. Ouput迭代器：只能前移，一次一部，只能改写，不能读取。例子：ostream_iterators。
   3. forward迭代器：以上功能都能实现，而且可以多次读写。例子：slist。
   4. Bidirectional（双向）迭代器：可以前移也可以后移。例子：set,multiset,map。
   5. random access 迭代器：可以随机访问
2.  traits（特征）
   1. 作用：允许在编译期间取的某些类型信息
   2. 定义：它是一种技术，也是一个c++程序员共同遵守的协议 
      1. 确定若干你希望将来可以取得的类型相关信息，对迭代器而言，我们希望取得其分类
      2. 为该信息选择一个名称
      3. traits 能够施行于内置类型，因此类型traits 信息必须位于类型自身之外。标准技术是把它放入一个template及其一个或多个特化版本中。
   3. 使用：
      1. 建立一组函数重载或函数模板，彼此间的差异只有各自的traits参数。令每个函数实现码与其接受之traits信息相应和。（不用 if 判断或者 typeid 是因为他们在运行时才执行，而函数重载在编译时就进行）
      2. 建立一个控制函数调用上面的函数重载或模板，并传递traits class所提供的信息。

### 48.认识template元编程

1. 它可以将运行期的工作转移到编译器来。因而得以实现早期错误检测和更高效的执行效率

2. TMP通过递归来实现循环

   1. TMP的“hello world"(计算阶乘) 通过”递归模板具现化“，实现循环(使用enum hacks。条例2)

      ```c++
      template<unsigned n>
      struct Factorial{
          enum {value = n * Factorial<n-1> : value}
      }
      template<>
      struct Factorial<0>{
          enum {value = 1};
      }
      ```

3. TMP可以用来生成"基于政策选择组合"的客户定制代码，也可用来避免生成对某些特殊类型并不适合的代码。

4. TMP可能不会成为主流，但对某些程序库开发人员，会成为他们的主要粮食。

# 定制new 和 delete

### 49.了解new-handler 的行为

1. set_new_handler 允许客户指定一个函数，在内存分配无法获得满足时被调用。（new_handler 是一个函数指针哦）

2. set_new_handler 会放回被替换前的那个new_handler

3. 一个优先的new-handler 函数需要做到以下事情

   1. 让更多内存被使用
   2. 安装另一个new-handler（类似于状态转移）
      1. 卸除new-handler（将指针设为null）
   3. 抛出bad-alloc
   4. 不放回（通常直接调用abort()或exit()直接退出程序）

4. c++ 并不支持自定义类的new-handler。但是你可以自己定义啊。

   ```c++
   class Widget{
   public:
   	static std::new_handler set_new_handler(std::new_handler p) throw();
       static void* operator new(std::size_t size) throw(std::bad_alloc);
   private:
       static std::new_handler currentHandler;
   }
   ```

5. operator new 主要做以下事情：

   1.   调用标准`set_new_handler`，告知Widget的错误处理函数。这会将Widget的 `new-handier` 安装为 `global new-handier`。
   2. 调用global operator new,执行实际之内存分配。如果分配失败，`global operator new`会调用Widge的new-handier,因为那个函数才刚被安装为`global new-handiero`如果`global operator new`最终无法分配足够内存，会抛出一个 bad_alloc异常。在此情况下Widget的operator new必须恢复原本的`global new-handie`r,然后再传播该异常。为确保原本的new-handier总是能够被重新安 装回去，Widget将`global new-handier`视为资源并遵守条款13的忠告，运用资 源管理对象(resource-managing objects )防止资源泄漏
   3. 如果`global operator new`能够分配足够一个Widget对象所用的内存，Widget 的operator new会返回一个指针，指向分配所得。Widget析构函数会管理 `global new-handier`,它会自动将 `Widget’s operator new` 被调用前的那个 global new-handier恢复回来.

6. "mixin"风格的base class:允许derived classes 继承单一特定能力。

### 50.了解new 和 delete 的合理替换时机

1. overruns （写入点在分配区块尾端后） underruns (写入点在分配区块起点前)
2. 理由：
   1. 用来检测运用上的错误（内存泄漏，，超出下标）
   2. 收集使用上的统计数据
   3. 强化效能：编译器自带的operator new 主要用于一般目的，如果你会定制的话，它就会快很多。
      - 增加分配和归还的速度：比如编译器提供的内存管理是线程安全的，而你的程序是单线程的，你就可以优化这以部分。
      - 降低缺省内存管理带来的空间额外开销
      - 为了弥补缺省分配器中的非最佳对齐
      - 为了将相关对象成簇集中：将常用的数据结果放在同一个页当中。
      - 为了获得非传统的行为：分配和归还共享内存的区块。

### 51.编写new 和delete时需要固守常规

1. 不能放回一个0byte的空间，如果客户申请的是0size 就反回1size。
2. operator new 应该内含一个无穷循环，并在其中尝试分配内存，如果无法满足内存需求就应该调用new- handler 。它也应该有能力处理0bytes申请。
3. operator delete 应该收到null 指针时不做任何事。

### 52.写了placement new 也要写placement delete

1. 定义：如果一个operator new 接受的参数除了size_t 之外还有其他的，那么他就是所谓的placement new。

   ```c++
   class Widget{
   	static void* operator new(std::size_t size, void* pMemory) throw();
   }
   vector<int>* pv = new vector();
   Widget* pw = new (pv);
   ```

2. 当你写了一个placement operator new 后也请写一个参数类型一模一样的placement operator delete 。因为在operator new 失败时，他会调用相应版本的operator delete。否在程序会发生内存泄漏。

3. 当你声明了placemnet new 和placement delete。也请声明他们的正常版本，否则会遮盖他们。

### 杂项讨论

### 53.不要轻易忽视编译器的警告

1. 严肃对待编译器发出的警告信息。（不要忽视他们）
2. 不要过度依赖编译器的报警能力，因为不同的编译器对待事情的态度并不相同。

### 54.让自己熟悉包括TR1在内的标准程序库

1. c++ 98

   1. STL（Standard Template Library,标准模板库）：覆盖容器（vector，string,map），迭代器，算法，函数对象，各种容器适配器.
   2. Iostreams 
   3. 国际化支持,multiple active localse(多种语言环境)
   4. 数值处理
   5. 异常阶层体系
   6. c89 标准程序库

2. TR1（Technical Report 1）

   Tr1 自身只是一份规范。

   1. 智能指针
   2. tr1::function
   3. tr1::bind
   4. Hash tables
   5. 正则表达式
   6. Tuples（元组）
   7. tr1::arry
   8. tr1::mem_fn
   9. tr1::reference_wrapper
   10. 随机数
   11. 数学特殊函数
   12. c99 兼容扩充

   TR1 组件 template 编程技术

   1. type traits ：条例47
   2. tr1::result_of ：template 用来 推导函数调用的返回类型

### 55.让自己熟悉Boost

1. 最后一个条例拉。
2. Boost是一个社区，一个很牛逼的网站。致力与免费，源码开发，同僚复审的c++程序库开发。Boost 跟c++ 委员会有着很深的py关系。被称为c++新标准的试验场。
3. Boost 提供很多tr1组件实现品，以及其他许多程序库。

