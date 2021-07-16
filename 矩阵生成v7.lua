-- 1、判断元素个数、找出位置序列
-- 2、根据位置序列，找出左下角位置。
-- 3、判断当前可以消除的元素，直到不能消除为止
-- 4、特殊元素消除效果产生，重复1、2、3 直至不能消除为止

--貌似不需要保存合成元素序列，遍历整个二维表即可
--function eraseNum(tab)有所改动

-- 规则的实现
-- 1、消除元素，找到合成元素位置
-- 2、继续消除元素，直到不能消除为止
-- 3、合成元素效果的实现

local arr = {}
local num = 5 --定义元素个数
local res = "" --目标序列

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

function init() --初始化序列
    for i = 1, 8 do
        arr[i] = {}
        for j = 1, 8 do
            arr[i][j] = math.random(num)
        end
    end
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

function myprint(tab) --自定义打印函数
    print(table.concat(tab, ","))
end

function printTable(tab) --打印整个table
    print("...")
    for i = 1, #tab do
        myprint(tab[i])
    end
end

function printSeries(series) --自定义打印序列函数
    for i = 1, #series do
        print(series[i][1], series[i][2])
    end
end

function DF(tab, x, y, series) --返回该点相同元素的序列
    series = series or {}
    local number = tab[x][y]

    if number == 0 then --提前结束，以及为当前元素为0的情况下，返回空序列
        return series
    end

    tab[x][y] = 0
    table.insert(series, {x, y})

    if x < #tab and tab[x + 1][y] == number then
        DF(tab, x + 1, y, series)
    end

    if x > 1 and tab[x - 1][y] == number then
        DF(tab, x - 1, y, series)
    end

    if y < #tab and tab[x][y + 1] == number then
        DF(tab, x, y + 1, series)
    end

    if y > 1 and tab[x][y - 1] == number then
        DF(tab, x, y - 1, series)
    end

    return series
end

function setZero(series) --置0函数
    for i = 1, #series do
        if type(arr[series[i][1]][series[i][2]]) == "number" then
            arr[series[i][1]][series[i][2]] = 0
        end
    end
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

function pos(series) --返回左下角元素位置
    local down = series[1][2]
    local left = series[1][1]

    for i = 2, #series do
        if series[i][2] > down then
            down = series[i][2]
        end
    end

    for i = 1, #series do
        if series[i][2] == down then
            if series[i][1] < left then
                left = series[i][1]
            end
        end
    end

    return left, down
end

function eraseRules(tab, n, left, down) --消除规则,n表示元素个数
    if n == 4 then
        tab[left][down] = "A"
    elseif n == 5 then
        tab[left][down] = "B"
    elseif n >= 6 then
        tab[left][down] = "C"
    end
end

function eraseNum(tab) --根据规则，消除元素并置0，合成元素按等级置为A,B,C
    local count = 0
    local arrCopy = copyTable(tab)
    for i = 1, #tab do
        for j = 1, #tab do
            if #DF(arrCopy, i, j, nil) >= 3 then
                count = count + 1
                local series = DF(tab, i, j, nil)
                if #series > 3 then --大于3的情况才需要处理合成元素位置
                    local left, down = pos(series)
                    eraseRules(arr, #series, left, down)
                end
                setZero(series)
            end
        end
    end
    return count
end

function endNum(tab) --根据规则，消除到当前不能消除为止
    local str = ""
    while eraseNum(tab) ~= 0 do
        remove(tab)
        str = str .. restore(tab)
    end
    return str
end

function findSpecial(tab) --寻找合成元素并消除
    local str = ""
    for i = 1, #tab do
        for j = 1, #tab do
            if tab[i][j] == "A" then --等于A就消除竖排元素
                tab[i][j] = 0
                for k = 1, #tab do
                    if type(tab[i][k]) == "number" then
                        tab[i][k] = 0
                    end
                end
                str = str .. endNum(tab)
            elseif tab[i][j] == "B" then
                tab[i][j] = 0
                local L = (i - 1 >= 1 and i - 1 or 1)
                local R = (i + 1 <= #tab and i + 1 or #tab)
            end
        end
    end
end

init()
res = res .. numList(arr)

function erase(tab) --根据情况来消除元素。若没有元素消去，则返回0
    local count = 0
    local arrCopy = copyTable(tab)
    for i = 1, #tab do
        for j = 1, #tab do
            if #DF(arrCopy, i, j) >= 3 then
                count = count + 1
                local series = DF(tab, i, j)
                local left, down = pos(series)
                eraseRules(arr, #series, left, down)
                setZero(series)
                remove(tab)
                res = res .. restore(arr)
            end
        end
    end
    return count
end

printTable(arr)

while erase(arr) ~= 0 do
    printTable(arr)
    remove(arr)
    res = res .. restore(arr)
    printTable(arr)
end

print(res)
