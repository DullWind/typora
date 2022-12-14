##  cocos2dx 内存管理机制

1. 当一个节点被创建的时候会自带一个引用计数，初始化为1，并加入到自动释放池
2. 当这个节点被加入到其他节点时，引用计数会+1
3. 当前帧结束时，自动释放池会将池里所有节点的引用计数-1；
4. 当引用计数为零时，该节点会被自动施法
5. retain 会将当前节点的引用计数加1，release -1

## 渲染机制 

1. 导演类的mainLoop中会调用drawScenen,drawScene会调用场景类的render
2. 场景类的render会调用节点类的visit，visit 会调用draw函数（同时会递归调用自身），draw是个虚函数，主要用来收集渲染信息，打包渲染命令，最后加入到render渲染器的渲染队列里
3. 在visit结束后，会调用渲染器里的proceRnederCommand，渲染器会进行合批处理，接着将命令发生给openGL

## 动作系统

1. action 是所有动作的基类，主要有顺时动作，延迟动作两个大类
2. 节点调运runAction,首先会将自身信息和动作打包发送给actionMgr
3. actionMgr会每帧进行调用所有动作的setp函数
4. setp函数会计算当前完成进度的百分比，接着调用update函数（这是个虚函数，由具体的动作重写）
5. update会根据完成的百分比，执行具体的行为，判断是否完成，如果完成，actionMgr会移除该动作

## 事件分发机制

1. 调度者有三个接口，分别负责消息的注册，删除和分发。同时自身有一个容器来存放消息。
2. 观察者会将消息注册进调度者
3. 当状态改变时，调度者会通知所有已经注册的消息。

## UI框架

### UIbase

1. 用来充当所有UI类的基类（方便管理以及提供一系列的接口）
2. 提供一系列接口（获取组件，绑定数据）,持有UIContainer

### UIContainer

1. 用来存放当前节点下的节点以及组件（可以选择自己需要的以“_”开头）
2. 有几个不同的容器来存储不同的组件类型
3. 提供一个获取组件的接口

### UIMgr                                                                                                                                                                         

1. 用来管理所有的UI组件
2. 有一个容器用来存放所有已经打开的界面
3. 主要的接口有三个（打开ui界面--压入当前容器内。关闭UI界面---从当前栈内取出。发送消息---调用已经打开界面内某个函数）

### Watcher

1. 用来绑定UI界面的数字
2. 主要提供了一个刷新接口

### Dep

1. 用来绑定数据（要更改的数据）
2. 一个dep可以有多个watcher
3. 实现set函数的（通知所有watcher调用他们的刷新接口）

### DepPool

1. 用来管理dep

