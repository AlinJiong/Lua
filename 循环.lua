-- while循环
-- while condition do
--     body
-- end

a = 0
while (a < 10) do
    print(a)
    a = a + 1
end

-- for循环体
-- for var=exp1,exp2,exp3 do
--     <执行体>
-- end

-- var 从 exp1 变化到 exp2，每次变化以 exp3 为步长递增 var，
-- 并执行一次 "执行体"。exp3 是可选的，如果不指定，默认为1。
for i = 1, 11 do
    print(i)
end

for i = 1, 11, 2 do
    print(i)
end

-- repeat循环，当前循环结束后判断。类似于do while
-- repeat

-- until

a = 10
repeat
    print(a)
    a = a + 1
until (a > 15)

-- break语句
a = 10
while (a < 20) do
    a = a + 1
    if (a > 15) then
        break
    end
    print(a)
end

-- goto语句
-- local a = 1
-- ::label:: print("--- goto label ---")

-- a = a+1
-- if a < 3 then
--     goto label   -- a 小于 3 的时候跳转到标签 label
-- end