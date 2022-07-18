Timer = {
    tick = 0,
    countDown = {}
}

function Timer:update()
    self.tick = self.tick + 1
    if self.countDown == nil then
        return
    end
    self.countDown.tempTick =  self.countDown.tempTick + 1
    if self.countDown.tempTick == self.countDown.time then
        self.countDown:fun()
        if self.countDown.canRepetition then
            self.countDown.tempTick = 0
        else
            self.countDown = nil
        end
    end
end
local handleTimeStr = function (time)
    local l_str = ""
    if(time % 10 == time) then
        l_str = "0".. tostring(time)
    else
        l_str = tostring(time)
    end
    return l_str
end

function  Timer:showTime()
    
    local l_second = self.tick % 60
    local l_min =  (self.tick / 60) % 60
    l_min = math.floor(l_min)
    local l_hour = (l_min / 60) % 60
    l_hour = math.floor(l_hour)

    local l_sStr  = handleTimeStr(l_second)
    local l_mStr = handleTimeStr(l_min)
    local l_hStr = handleTimeStr(l_hour)
    local l_timeStr = l_hStr .. ":" ..l_mStr .. ":" .. l_sStr
    print(l_timeStr)
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
    self.countDown = l_cuntDown
end

-- function Timer:new()
--     local o
--     o = o or {}
--     setmetatable(o,self)
--     self.__index = self
--     return o
-- end

local Building = {
    lv = "",
    name = "",
    product = "",
    getNum = 0,
}

-- function Building:new()
--     local o
--     o = o or {}
--     setmetatable(o,self)
--     self.__index = self
--     return o
-- end

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
        o = o or {}
        setmetatable(o, c)
        return o
    end
    return c
  end

local main = function ()
    local farm = CreateClass(Timer,Building)
    local militaryCamp = CreateClass(Timer,Building)
    farm.lv = 10
    farm.name = "农场"
    farm.product = "粮食"

    militaryCamp.lv = 1
    militaryCamp.name = "军营"
    militaryCamp.product = "士兵"

    farm:setTimer(15,function ()
        farm.getNum = 100 * farm.lv + farm.getNum
        if(farm.getNum == 1000) then
            farm:showTime()
            print(string.format("%s收获%d %s",farm.name,farm.getNum,farm.product))
            farm.getNum = 0
        end
    end,true)

    militaryCamp:setTimer(20,function ()
        militaryCamp.getNum = 2 * militaryCamp.lv + militaryCamp.getNum
        militaryCamp:showTime()
        print(string.format("%s收获%d %s",militaryCamp.name,militaryCamp.getNum,militaryCamp.product))
    end,true)

    for i = 1 , 120 do
        militaryCamp:update()
        farm:update()
    end
end

 main()


