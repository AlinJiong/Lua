-- 若引发错误，结束当前程序
-- assert常用方法
print "enter a number:"
local n = assert(io.read("*number"), "invalid input")

-- error常用方法，if not then end
print "enter a number:"
local n = io.read("*number")
if not n then
    error("invalid input")
end

-- pxcall
-- 若被执行函数一切正常，pcall返回true以及被执行函数函数的返回值，
-- 否则返回false和错误信息。也就是说成功仅仅有一个返回值，而失败则有两个返回值。
print(
    pcall(
        function()
            require("module")
        end
    )
)

-- xpcall(func, handler)
-- xpcall，该函数除了接收一个需要被调用的函数外，还接受一个错误处理函数
xpcall(
    function(i)
        print(i)
    end,
    function()
        print(debug.traceback())
    end,
    100
)
