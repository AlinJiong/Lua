-- lua最简单的构造表达式是{}
-- 也可以在表里添加一些数据，直接初始化表:

local tab1 = {}

-- 直接初始表,初始索引从 1 开始，不同于其他语言
local tab2 = {"apple", "pear", "orange", "grape"}
for k, v in pairs(tab2) do
    print("Key" .. ":" .. k)
end

-- 索引可以是数字或者字符串
a = {}
a["key"] = "value"
a[10] = 20

for k, v in pairs(a) do
    print(k .. ":" .. v)
end

-- table 不会固定长度大小，有新数据添加时 table 长度会自动增长，
-- 没初始的 table 都是 nil
a3 = {}
for i = 1, 10 do
    a3[i] = i
end

a3["key"] = "val"
print(a3["key"])
print(a3["none"])

for k, v in pairs(a3) do
    print(k .. ":" .. v)
end
