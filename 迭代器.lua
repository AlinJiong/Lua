-- 无状态和多状态两种方式

-- 无状态
function square(max, start)
    if start < max then
        start = start + 1
        return start, start * start
    end
end

-- 注意函数的调用方式
for i, n in square, 3, 0 do
    print(i, n)
end

-- 多状态
array = {"Google", "Runoob"}

function elementIterator(collection)
    local index = 0
    local count = #collection
    -- 闭包函数
    return function()
        index = index + 1
        if index <= count then
            --  返回迭代器的当前元素
            return collection[index]
        end
    end
end

for element in elementIterator(array) do
    print(element)
end
