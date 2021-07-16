--下面代码预计处理流程，先从上到下处理行，然后从左到右处理列，
--若从下到上处理行，会导致上面本来可以消除的错位
--然后单独根据行列数目来处理
-- 处理流程：
-- 1、先随机生成随机数
-- 2、然后判断重复的行列并消除
-- 3、将上层的数字下移，生成随机数填充，
-- 重复2、3

--处理难点：
-- 1、交叉情况的判断
-- 2、更新后，地图状态的更新
-- 3、结束条件的判断
-- 4、消除规则定义

local arr = {}
local arrCopy = {}
local num = 4 --定义元素个数
local res = "" --目标序列
function myprint(tab) --自定义打印函数
    print(table.concat(tab, ","))
end

function printTable(tab) --打印整个table
    print("...")
    for i = 1, #tab do
        myprint(tab[i])
    end
end

function deepcopy(orig) --自定义深拷贝函数，只能拷贝一维
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function copyTable(tab) --自定义二维拷贝函数
    local copy = {}
    for i = 1, #tab do
        copy[i] = deepcopy(tab[i])
    end
    return copy
end

function remove(tab) --自定义消除0的函数
    for i = #tab, 2, -1 do --第一行可以为0
        for j = 1, #tab do
            if tab[i][j] == 0 then
                for k = i - 1, 1, -1 do
                    if tab[k][j] ~= 0 then
                        tab[i][j], tab[k][j] = tab[k][j], tab[i][j]
                        break
                    end
                end
            end
        end
    end
end

function restore(tab) --自定义还原函数，返回生成数序列
    local str = ""
    for i = #tab, 1, -1 do
        local flag = 0
        for j = 1, #tab do
            if tab[i][j] == 0 then
                flag = 1
            end
        end
        if flag == 1 then
            for k = 1, #tab do
                if tab[i][k] ~= 0 then
                    str = str .. "0"
                else
                    tab[i][k] = math.random(num)
                    str = str .. tab[i][k]
                end
            end
        end
    end
    return str
end

function judgeRow(tab) --判断行，若有元素可以消去，返回消除个数和下标
    local max_len, count, flag = 1, 1, 1 --flag记录行下标
    for i = 1, #tab - 1 do
        if tab[i] == tab[i + 1] then
            count = count + 1
            if count >= max_len then
                max_len = count
                flag = i + 1
            end
        else
            count = 1
        end
    end

    if max_len >= 3 then
        return max_len, flag --若有元素可以消去，返回消除个数和下标
    else
        return max_len, 0
    end
end

function judgeCol(arr, xlabel) --判断列,xlabel表示第几列。若有元素可以消去，返回消除个数和下标
    local max_len, count, flag = 1, 1, 1 --flag记录列下标

    for i = 1, #arr - 1 do
        if arr[i][xlabel] == arr[i + 1][xlabel] then
            count = count + 1
            if count >= max_len then
                max_len = count
                flag = i + 1
            end
        else
            count = 1
        end
    end

    if max_len >= 3 then
        return max_len, flag --若有元素可以消去，返回消除个数和下标
    else
        return max_len, 0
    end
end

function init() --初始化序列
    for i = 1, 8 do
        arr[i] = {}
        for j = 1, 8 do
            arr[i][j] = math.random(num)
        end
    end
end

function erase(tab) --消除重复行列
    local sum = 0 --记录消除的次数
    for i = 1, #tab do
        local len, label = judgeRow(arrCopy[i])
        if label ~= 0 then
            sum = sum + 1
            for j = label - len + 1, label do
                arr[i][j] = 0
            end
        end

        len, label = judgeCol(arrCopy, i)
        if label ~= 0 then
            sum = sum + 1
            for j = label - len + 1, label do
                arr[j][i] = 0
            end
        end
    end
    return sum
end

function numList(tab) --初始数字序列
    local str = ""
    for i = 1, #tab do
        for j = 1, #tab do
            str = str .. tab[i][j]
        end
    end
    return str
end

-- init()
-- printTable(arr)

-- arrCopy = copyTable(arr)

-- erase(arr)
-- printTable(arr)
-- printTable(arrCopy)

-- remove(arr)
-- printTable(arr)

-- print(restore(arr))
-- printTable(arr)

init()
arrCopy = copyTable(arr)
res = res .. numList(arr)
printTable(arr)

while erase(arr) ~= 0 do
    printTable(arr)
    remove(arr)
    printTable(arr)
    res = res ..restore(arr)
    printTable(arr)
    arrCopy = copyTable(arr)
end

print(res)