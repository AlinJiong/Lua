function f1(n)
    if n == 0 then
        return 1
    else
        return n * f1(n - 1)
    end
end

print(f1(5))

-- 函数可以存在变量里
f2 = f1
print(f2(5))

-- function可以用匿名函数的方式传递参数
function testFun(tab, fun)
    for k, v in pairs(tab) do
        print(fun(k, v))
    end
end

tab = {key1 = "val1", key2 = "val2"}
testFun(
    tab,
    function(key, val) --匿名函数
        return key .. "=" .. val
    end
)



