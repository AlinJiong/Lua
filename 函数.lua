function max(num1, num2)
    if (num1 > num2) then
        result = num1
    else
        result = num2
    end
    return result
end

-- 多返回值
s, e = string.find("www.baidu.com", "baidu")
print(s, e)

function maximum(a)
    local mi = 1 -- 最大值索引
    local m = a[mi] -- 最大值
    for i, val in ipairs(a) do
        if val > m then
            mi = i
            m = val
        end
    end
    return m, mi
end

print(maximum({8, 10, 23, 12, 5}))

-- 可变参数
-- 在函数参数列表中使用三点 ... 表示函数有可变的参数。
function add(...)
    local s = 0
    for i, v in ipairs {...} do --> {...} 表示一个由所有变长参数构成的数组
        s = s + v
    end
end

print(add(2, 3, 4, 5))

function average(...)
    result = 0
    local arg = {...} --> arg 为一个表，局部变量,将传入的表保存
    for i, v in ipairs(arg) do
        result = result + v
    end
    print("总共传入 " .. #arg .. " 个数")
    return result / #arg
end

print("平均值为", average(10, 5, 3, 4, 5, 6))
