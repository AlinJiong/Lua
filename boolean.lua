-- Lua 把 false 和 nil 看作是 false，
-- 其他的都为 true，数字 0 也是 true:

if false or nil then
    print("至少有一个是 true")
else
    print("false 和 nil 都为 false")
end

if 0 then
    print("数字0是 true")
else
    print("数字0是 false")
end
