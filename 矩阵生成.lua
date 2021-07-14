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
--自定义打印函数
function myprint(tab)
    print(table.concat(tab, ","))
end

--打印整个table
function printTable(tab)
    print("...")
    for i = 1, #tab do
        myprint(tab[i])
    end
end

--自定义深拷贝函数，只能拷贝一维
function deepcopy(orig)
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

--自定义二维拷贝
function copyTable(tab)
    local copy = {}
    for i = 1, #tab do
        copy[i] = deepcopy(tab[i])
    end
    return copy
end

--自定义消除函数
function remove(tab)
    for i = #tab, 1, -1 do
        for j = 1, #tab do
            if i ~= 1 and tab[i][j] == 0 then
                tab[i][j] = tab[i - 1][j]
            end
        end
    end
end

function judgeRow(tab) --判断行
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

function judgeCol(arr, xlabel) --判断列,xlabel表示第几列
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

for i = 1, 8 do --初始化生成序列
    arr[i] = {}
    for j = 1, 8 do
        arr[i][j] = math.random(5) --此处的9根据实际情况改变
    end
end

printTable(arr)

arrCopy = copyTable(arr)

for i = 1, 8 do
    local len, label = judgeRow(arrCopy[i])
    if label ~= 0 then
        for j = label - len + 1, label do
            arr[i][j] = 0
        end
    end

    local len, label = judgeCol(arrCopy, i)
    if label ~= 0 then
        for j = label - len + 1, label do
            arr[j][i] = 0
        end
    end
end

printTable(arr)
printTable(arrCopy)


