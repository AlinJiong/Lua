local arr = {}
local arrCopy = {}
local num = 4 --定义元素个数
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

function printSeries(s) --自定义打印序列函数
    for i = 1, #s do
        print(s[i][1], s[i][2])
    end
end

init()
printTable(arr)
series = DF(arr, 2, 3, nil)
print(#series)
printSeries(series)
series = DF(arr, 8, 8, nil)
print(#series)
printSeries(series)

series = DF(arr, 2, 2, nil)
print(#series)
printSeries(series)

printTable(arr)

series = DF(arr, 7, 7, nil)
print(#series)

printSeries(series)
printTable(arr)
