-- 在对一个数字字符串上进行算术操作时，
-- Lua 会尝试将这个数字字符串转成一个数字:

print("2" + 6)
print(type("2" + 6))

-- 字符串连接使用的是 ..
print(123 .. 456)

-- 使用 # 来计算字符串的长度，放在字符串前面
str1 = "this is string 1"
print(#str1)