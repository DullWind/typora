## 基础篇

### 渲染流水线

1. 渲染流水线的起点是cpu，即应用阶段主要分为三个阶段
   1. 把数据加载到显存中
   2. 设置渲染状态
   3. 调用drawCall
2. Drawcall是CPU对底层图形绘制接口的调用命令[GPU](https://so.csdn.net/so/search?q=GPU&spm=1001.2101.3001.7020)执行渲染操作，渲染流程采用流水线实现，CPU和GPU并行工作，它们之间通过命令缓冲区连接，CPU向其中发送渲染命令，GPU接收并执行对应的渲染命令。
3. 多种编程语言
   1. GLSL-openGL--跨平台
   2. HLSL-DirectX--微软
   3. CG-NVIDIA--跨平台
4. 通过命令缓冲区使得CPU和GPU并行

### unityShader

ShaderLab 语义块

1. properties 语义块
   	1. 一般属性的名字以下划线开头![image-20220719173410474](unityShader.assets/image-20220719173410474.png)

2. subShader
     1. 一个shader可以有多个，但至少要有一个subShader
     2. Pass 语义块
         1. 类似于js里的package，可以被其他的unityShader所引用
         2. UsePass ：使用该命令来复用其他unityShader中的pass
         3. GrabPss：负责抓取屏幕，并将结果储存在一张纹理中
3. Fallback
     1. 如果所有的subShader都不符合语义，就执行fallback 指令
4. 表面着色器（surfaceShader）
     1. unity自己创造的着色器代码类型，但最后也是转为顶点着色器或者片元着色器

