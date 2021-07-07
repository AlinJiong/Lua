-- setmetatable(tabel,metatable)

--  lua查找表中元素的规则
-- （1）先在表中查找，如果找到，返回该元素的值，找不到进行第（2）步
-- （2）判断该表是否具有元表，如果没有，返回nil，如果有，进行第（3）步
-- （3）判断元表中是否具有__index方法，如果__index为nil，则返回nil
--  如果__index方法是一个表，重复（1）（2）（3），如果__index方法是一个函数，则返回该函数的返回值
print("...index...")
function main()
    local t = {name = "hi"}
    local mt = {__index = {money = 300}}
    setmetatable(t, mt)
    print(t.name)
    print(t.money)
end

main()

-- __index方法是一个函数，则返回该函数的返回值
function f1()
    local t = {name = "hi"}
    local mt = {
        __index = function()
            return 3000
        end
    }
    setmetatable(t, mt)
    print(t.name)
    print(t.money)
end

f1()

-- __newindex用于对表的更新，
-- 如果在table中找到该元素，修改时，改变table。
-- 否则调用__newindex函数，对元表进行操作

-- 如果__newindex是一个函数，则在给table中不存在的字段赋值时，
-- 会调用这个函数，但是赋值不成功，不改变table
print("__newindex__")
t = {}
local mt = {
    __newindex = function(tabel, key, value)
        print("key=" .. key)
        print("value=" .. value)
        key = value
    end
}

function new()
    local t = {a = "ok"}
    setmetatable(t, mt)
    print(t.a)
    t.a = "change"
    print(t.a)

    t.b = "new"
    print(t.b) --输出为nil
end

new()

-- 如果__newindex是一个表，若给table不存在的字段赋值时，
-- 会调用这个函数，修改元表
print("......")
t = {}
local mt = setmetatable({key1 = "v1"}, {__newindex = t})
print(mt.key1)

mt.newkey = "v2"
print(mt.newkey, t.newkey)

-- 添加操作符
print("...operation...")
local mt = {}
mt.__add = function(t1, t2)
    local tmp = {}
    for _, v in ipairs(t1) do
        table.insert(tmp, v)
    end
    for _, v in ipairs(t2) do
        table.insert(tmp, v)
    end
    return tmp
end

local t1 = {1, 2, 3}
local t2 = {4}
setmetatable(t1, mt)
local t3 = t1 + t2
for _, v in ipairs(t3) do
    print(v)
end

-- __call元方法,将table当成函数来使用
print("...call...")
local mt = {}
--__call的第一参数是表自己
mt.__call = function(mytable, ...)
    --输出所有参数
    for _, v in ipairs {...} do
        print(v)
    end
end

t = {}
setmetatable(t, mt)
--将t当作一个函数调用
t(1, 2, 3)

-- __tostring,可以修改table转化为字符串
print("...tostring...")
local mt = {}
mt.__tostring = function(t)
    local s = "{"
    for i, v in ipairs(t) do
        if i > 1 then
            s = s .. ","
        end
        s = s .. v
    end
    s = s .. "}"
    return s
end

t = {1,2,3}
--直接输出t
print(t)
--将t的元表设为mt
setmetatable(t,mt)
--输出t
print(t)