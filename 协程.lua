-- 建立一个协程
-- coroutine.create(f)

local co =
    coroutine.create(
    function()
        print("in coroutine")
        return "coroutine return"
    end
)
print(co)
print(coroutine.resume(co))

-- Output:
-- thread: 0039B808
-- in coroutine
-- true    coroutine return

-- 开始或启动协程
-- coroutine.resume(co,[,val1,...])
-- 正确的话，返回值为true和函数返回值，错误的话，返回false和错误信息
-- 保护模式下运行，即不会中断整个流程。发生错误后，返回false+错误信息，协程状态变成dead
local co =
    coroutine.create(
    function(input)
        print("input : " .. input)
        local param1, param2 = coroutine.yield("yield") --yield的返回值给resume
        print("param1 is : " .. param1)
        print("param2 is : " .. param2)
        -- return 也会将结果返回给 resume
        return "return"
    end
)

--第一次执行,将参数传给input,yield的返回值给resume
print(coroutine.resume(co, "function input"))
print("this is second chunk")
--第二次执行,将参数作为yield的返回值,传给param1 param2
print(coroutine.resume(co, "param1", "param2"))

-- Output:
-- input : function input
-- true    yield
-- this is second chunk
-- param1 is : param1
-- param2 is : param2
-- true    return

-- 挂起一个协程
-- coroutine.yield(...)
-- 传递给 yield 的参数都会转为 resume 的额外返回值
local co =
    coroutine.create(
    function()
        coroutine.yield("yield1", "yield2")
    end
)

print(coroutine.resume(co))
-- Output:
-- true    yield1  yield2

-- wrap
-- 不显示错误信息，true/false，类似于creat用法
local wrap =
    coroutine.wrap(
    function(input)
        print("input : " .. input)
        local param1, param2 = coroutine.yield("yield")
        print("param1 is : " .. param1)
        print("param2 is : " .. param2)
        -- return 也会将结果返回给 resume
        return "return"
    end
)

--第一次执行,将参数传给input
print(wrap("function input"))
print("this is main chunk")
--第二次执行,将参数作为yield的返回值,传给param1 param2
print(wrap("param1", "param2"))

-- Output:
-- input : function input
-- yield
-- this is main chunk
-- param1 is : param1
-- param2 is : param2
-- return
