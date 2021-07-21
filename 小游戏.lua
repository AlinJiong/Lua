local function add_num_rate(n, rate)
    local num = math.random()
    if num > 0 and num < rate then
        return 1
    elseif num >= rate and num < rate * 2 then
        return 2
    elseif num >= rate * 2 and num < rate * 3 then
        return 3
    elseif num >= rate * 3 and num < rate * 4 then
        return 4
    elseif num >= rate * 4 and num < rate * 5 then
        return 5
    else
        return n
    end
end

local function reduce_num_rate(n, rate)
    local total = {1, 2, 3, 4, 5}
    local flag = 1
    for i = 1, 5 do
        if total[i] == n then
            flag = i
        end
    end
    table.remove(total, flag)
    local num = math.random()
    if num > 0 and num < rate then
        return total[1]
    elseif num >= rate and num < rate * 2 then
        return total[2]
    elseif num >= rate * 2 and num < rate * 3 then
        return total[3]
    elseif num >= rate * 3 and num < rate * 4 then
        return total[4]
    else
        return n
    end
end

local function max_sum_num(_config, _status_data) --返回当前grid的最多数量的数字
    local total = {0, 0, 0, 0, 0}
    for i = 1, 8 do
        for j = 1, 8 do
            if type(_status_data.grid[i][j]) == "number" and _status_data.grid[i][j] ~= 0 then
                total[_status_data.grid[i][j]] = total[_status_data.grid[i][j]] + 1
            end
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
    return flag
end
