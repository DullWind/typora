## lua 中class 的实现

> ```lua
> function class(classname, super)
>     local superType = type(super)
>     local cls
> 	
>     --如果super 不是function 也不是table,就当他为空
>     if superType ~= "function" and superType ~= "table" then
>         superType = nil
>         super = nil
>     end
> 	--如果是function 或者是一个c++ 对象 。 _ctype 1 代表c++对象，2 代表lua对象
>     if superType == "function" or (super and super.__ctype == 1) then
>         -- inherited from native C++ Object
>         cls = {}
> 		-- 如果他是一个表，将父类的属性存入类中
>         if superType == "table" then
>             -- copy fields from super（从super里继承属性）
>             for k,v in pairs(super) do cls[k] = v end
>             cls.__create = super.__create
>             cls.super    = super
>         -- 如果他是个函数
>         else
>             cls.__create = super
>             cls.ctor = function() end
>         end
> 
>         cls.__cname = classname
>         cls.__ctype = 1
> 		-- 添加new 函数（调用父类构造函数_create，以及自身构造函数ctor,然后将数据存入对象）
>         function cls.new(...)
>             local instance = cls.__create(...)
>             -- copy fields from class to native object
>             for k,v in pairs(cls) do instance[k] = v end
>             instance.class = cls
>             instance:ctor(...)
>             return instance
>         end
> 
>     else
>         -- inherited from Lua Object
>         -- 如果继承自lua对象，将super设为类的元表
>         if super then
>             cls = {}
>             setmetatable(cls, {__index = super})
>             cls.super = super
>         else
>            --如果没有super，就只添加一个空的构造函数
>             cls = {ctor = function() end}
>         end
> 
>         cls.__cname = classname
>         cls.__ctype = 2 -- lua
>         cls.__index = cls
>         
>         function cls.new(...)
>          local instance = setmetatable({}, cls)
>             instance.class = cls
>             instance:ctor(...)
>             return instance
>         end
>     end
>    
>     return cls
> end
>    ```

关于cls._index = cls 详情看[https://www.cnblogs.com/wang-jin-fu/p/13511870.html](https://www.cnblogs.com/wang-jin-fu/p/13511870.html)

