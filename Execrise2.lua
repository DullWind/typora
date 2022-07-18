Timer = {
    tick = 0,
    countDownList = {}
}

function Timer:update()
    self.tick = self.tick + 1
    -- 遍历倒计时表
    for i = #self.countDownList, 1, -1 do
        local l_countDown = self.countDownList[i]
        l_countDown.tempTick = l_countDown.tempTick + 1
        if l_countDown.tempTick == l_countDown.time then
            l_countDown:fun()
            if l_countDown.canRepetition then
                l_countDown.tempTick = 0
            else
                table.remove(self.countDownList,i)
            end
        end
    end
end

function  Timer:showTime()
    local l_second = self.tick % 60
    local l_min =  (self.tick / 60) % 60
    l_min = math.modf(l_min)
    local l_hour = (l_min / 60) % 60
    l_hour = math.modf(l_hour)
    print(string.format("%d:%d:%d", l_hour, l_min, l_second))
end

function Timer:setTimer(time,fun,canRepetition)
    if time == nil or fun == nil then
        return
    end
    if time == 0 then 
        return
    end
    canRepetition = canRepetition or false
    local l_cuntDown = {
        time = time,
        tempTick = 0,
        fun = fun,
        canRepetition = canRepetition,
    }
    table.insert(self.countDownList,l_cuntDown)
end

function Timer:new()
    local o
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

local Building = {
    lv = "",
    name = "",
    product = "",
    getNum = 0,
}

function Building:new()
    local o
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function CreateClass(...)
    local c = {}
    local arg = {...}
    setmetatable(c, {__index=function(t, k)
        for _, p in pairs(arg) do
            local v = p[k]
            if(v) then 
                return v
            end
        end
    end})
    c.__index = c
    function c:New(o)
        local o
        o = o or {}
        setmetatable(o, c)
        return o
    end
    return c
  end

local main = function ()
    local farm = CreateClass(Timer:new(),Building:new())
    local militaryCamp = CreateClass(Timer:new(),Building:new())
    farm.lv = 1
    farm.name = "农场"
    farm.product = "粮食"

    militaryCamp.lv = 1
    militaryCamp.name = "兵营"
    militaryCamp.product = "兵力"

    farm:setTimer(15,function ()
        farm.getNum = 100 * farm.lv + farm.getNum
        if(farm.getNum == 1000) then
            farm:showTime()
            print(string.format("%s收获%d %s",farm.name,farm.getNum,farm.product))
        end
    end,true)

    militaryCamp:setTimer(20,function ()
        militaryCamp.getNum = 2 * militaryCamp.lv + militaryCamp.getNum
        farm:showTime()
        print(string.format("%s收获%d %s",militaryCamp.name,militaryCamp.getNum,militaryCamp.product))
    end,true)

    -- for i = 1 , 120 do
    --     militaryCamp:update()
    --     farm:update()
    -- end
end

main()

