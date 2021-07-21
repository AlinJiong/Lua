tab = {}
math.randomseed(tostring(os.time()):reverse():sub(1, 7))

for i = 1, 8 do
    tab[i] = {}
    for j = 1, 8 do
        tab[i][j] = math.random(5)
    end
end

function add_num_rate(n) --增加至28%，其余为18%*4
    local num = math.random()
    if num > 0 and num < 0.18 then
        return 1
    elseif num >= 0.18 and num < 0.36 then
        return 2
    elseif num >= 0.36 and num < 0.54 then
        return 3
    elseif num >= 0.54 and num < 0.72 then
        return 4
    elseif num >= 0.72 and num < 0.90 then
        return 5
    else
        return n
    end
end

count = {0, 0, 0, 0, 0}

for i = 1, 1000 do
    local k = add_num_rate(5)
    count[k] = count[k] + 1
end

for i = 1, 5 do
    print(count[i])
end

function reduce_num_rate(n)
    local total = {1, 2, 3, 4, 5}
    local flag = 1
    for i = 1, 5 do
        if total[i] == n then
            flag = i
        end
    end
    table.remove(total, flag)
    local num = math.random()
    if num > 0 and num < 0.22 then
        return total[1]
    elseif num >= 0.22 and num < 0.22 * 2 then
        return total[2]
    elseif num >= 0.22 * 2 and num < 0.22 * 3 then
        return total[3]
    elseif num >= 0.22 * 3 and num < 0.22 * 4 then
        return total[4]
    else
        return n
    end
end

count = {0, 0, 0, 0, 0}

for i = 1, 1000 do
    local k = reduce_num_rate(5)
    count[k] = count[k] + 1
end

for i = 1, 5 do
    print(count[i])
end

function max_sum_num(tab)
    local total = {0, 0, 0, 0, 0}
    for i = 1, 8 do
        for j = 1, 8 do
            total[tab[i][j]] = total[tab[i][j]] + 1
        end
    end

    local m = total[1]
    local flag = 1
    for i = 1, #total do
        if total[i] > m then
            m = total[i]
            flag = i
        end
    end
    return flag, m
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

printTable(tab)
print(max_sum_num(tab))
