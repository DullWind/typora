### socket.**select(**recvt, sendt [, timeout]**)** 

recvt是一个带有套接字的数组，用于测试可用于读取的字符。监视sendt数组中的套接字，查看是否可以立即在其上写入。timeout是等待状态更改的最长时间（秒）。零、负或忽略的超时值允许函数无限期阻塞。Recvt和sendt也可以是空表或nil。数组中的非套接字值（或具有非数字索引的值）将被忽略。

该函数返回一个套接字表准备好读取，一个套接字表准备好写入，以及一条错误消息。

```lua
local recvt, sendt, status = socket.select({self.m_sock}, nil, 1)
```

tips:在调用accept之前，在receive参数中使用服务器套接字调用select并不保证accept会立即返回。使用settimeout方法，否则accept可能会永远阻塞。

ps:使用settimeout 可以使accept函数成为异步的（感觉描述的不准确）



### client:**receive(**[pattern [, prefix]]**)** 

 根据指定的pattern 从客户端对象读取数据。模式遵循Lua文件I/O格式，所有模式之间的性能差异可以忽略不计。 

模式可以是以下任意一种：


“*a”：从套接字读取，直到连接关闭。不执行行尾翻译；

“*l”：从套接字读取一行文本。该行以LF字符（ASCII 10）终止，可选地前面有CR字符（ASCII 13）。返回的行中不包括CR和LF字符。事实上，模式忽略了所有CR字符。这是默认模式；

number：使方法从套接字读取指定数量的字节。

prefix是一个可选字符串，在返回之前连接到任何接收数据的开头。

###  string.byte (s [, i [, j] ]) 

 函数返回字符`s[i], s[i+1], ···, s[j]`的内部数字编码(ASCII码)，其中参数`i`的默认值是1，而参数`j`的默认值是`i`。 

