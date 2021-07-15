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
        arr[series[i][1]][series[i][2]] = 0
    end
end

function erase(tab) --根据情况来消除元素。若没有元素消去，则返回0
    local count = 0
    local arrCopy = copyTable(tab)
    for i = 1, #tab do
        for j = 1, #tab do
            if #DF(arrCopy, i, j) >= 3 then
                count = count + 1
                local series = DF(tab, i, j)
                setZero(series)
            end
        end
    end
    return count
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

function numList(tab) --初始数字序列
    local str = ""
    for i = 1, #tab do
        for j = 1, #tab do
            str = str .. tab[i][j]
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

-- function eraseRules(tab, n, left, down) --消除规则,n表示元素个数
--     if n == 4 then
--         for i = 1, #tab do
--             tab[left][i] = 0
--         end
--         tab[left][down] = 'A'
--     elseif n == 5 then
--         tab[]
--     elseif n>=6 then
--         local number = tab[left][down]
--         for i=1,#tab do
--             for j=1,#tab do
--                 if tab[i][j] == number then
--                     tab[i][j]=0
--                 end
--             end
--         end
--     end
-- end

init()
res = res .. numList(arr)
printTable(arr)

while erase(arr) ~= 0 do
    printTable(arr)
    remove(arr)
    res = res .. restore(arr)
    printTable(arr)
end

print(res)
