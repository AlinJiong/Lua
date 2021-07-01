-- nil 还有一个"删除"作用，
-- 给全局变量或者 table 表里的变量赋一个 nil 值，等同于把它们删掉

tabl = {key1 = "val1", key2 = "val2", "val3"}
for k, v in pairs(tabl) do
    print(k .. "-" .. v)
end

tabl.key1 = nil
for k, v in pairs(tabl) do
    print(k .. "-" .. v)
end


-- nil 作比较时应该加上双引号""

if type(x) == "nil" then
    print("true")
end
