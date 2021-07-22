--[[
    中间数据结构

    当前格子数据 5 x 6
    grid = {
        {1,2,3,4,5}，
        {1,2,3,4,5}，
        ...
    }

    game_data_vec = {1,2,3,4,5...} --格子数据序列。（随机元素 追加到尾部）

    spec_vec = {0,0,0,0,1}         --四角和中间位置是是否被点亮,点亮置为1

    rate=n --总倍率

--]]
local LF = {}
local spec = {1, 2, 3, 4, 5, "A", "B"} --随机道具格，A为小宝箱，B为大宝箱
math.randomseed(tostring(os.time()):reverse():sub(1, 7)) --随机数生成种子

--随机道具生成，控制概率？若上面的全部点亮，则不生成小宝箱
local function create_random(_config, _status_data)
    _status_data.grid[6] = {}
    for i = 1, 5 do
        _status_data.grid[6][i] = spec[math.random(7)]
        table.insert(_status_data.game_data_vec, _status_data.grid[6][i])
    end
end

--表格初始化
local function create_grid(_config, _status_data)
    _status_data.rate = 0
    _status_data.game_data_vec = {}
    _status_data.spec_vec = {0, 0, 0, 0, 0}
    _status_data.grid = {}
    for i = 1, 5 do
        _status_data.grid[i] = {}
        for j = 1, 5 do
            _status_data.grid[i][j] = math.random(5)
            table.insert(_status_data.game_data_vec, _status_data.grid[i][j])
        end
    end
    create_random(_config, _status_data)
end

--判断当前位置点亮后是否可以连线,返回可以连线的个数，不能连线则返回0
local function line(_config, _status_data, x, y)
    local flag = 0
    local count = 0

    for i = 1, 5 do --判断当前列
        if x ~= i then
            if _status_data.grid[i][y] == 0 then
                flag = flag + 1
            else
                break
            end
        end
    end
    if flag == 4 then
        count = count + 1
    end

    flag = 0
    for i = 1, 5 do --判断当前行
        if y ~= i then
            if _status_data.grid[x][i] == 0 then
                flag = flag + 1
            else
                break
            end
        end
    end
    if flag == 4 then
        count = count + 1
    end

    flag = 0
    if x == y then --判断左斜对角线
        for i = 1, 5 do
            if x ~= i and _status_data[i][i] == 0 then
                flag = flag + 1
            else
                break
            end
        end
    end
    if flag == 4 then
        count = count + 1
    end

    flag = 0
    if x + y == 6 then --判断右斜对角线
        for i = 1, 5 do
            if x ~= i then
                if _status_data[i][6 - i] == 0 then
                    flag = flag + 1
                else
                    break
                end
            end
        end
    end
    if flag == 4 then
        count = count + 1
    end

    return count
end

--[[
    判断当前可以获得最大奖励的格子位置，若没有可以连线的格子，
    选择最中间的格子，然后依次选择四角，其次随机点亮，
    此处还没完全实现
--]]
local function find_max(_config, _status_data)
    local series = {} --保存可以连线的点位
    for i = 1, 5 do
        for j = 1, 5 do
            if _status_data.grid[i][j] ~= 0 then
                local count = line(_config, _status_data, i, j)
                if count ~= 0 then
                    table.insert(series, {i, j, count})
                end
            end
        end
    end

    if #series > 0 then --如果有可以连线的元素，则返回位置
        table.sort(
            series,
            function(a, b)
                return a[3] > b[3]
            end
        )
        return series[1][1], series[1][2]
    else
        if _status_data.spec_vec[#_status_data.spec_vec] == 0 then --中心位置未被点亮
            _status_data.spec_vec[#_status_data.spec_vec] = 1
            return _config.normal_loc[#_status_data.spec_vec][1], _config.normal_loc[#_status_data.spec_vec][2]
        else
        end
    end
end

--点亮元素，大宝箱元素默认点亮可以获取最大奖励的格子，
--返回当前可以生成的连续条数
local function light(_config, _status_data)
    local count = 0
    for i = 1, 5 do
        if type(_status_data.grid[6][i]) == "number" then
            for j = 1, 5 do
                if _status_data.grid[j][i] == _status_data.grid[6][i] then --普通元素点亮
                    _status_data.grid[j][i] = 0
                    count = count + line(_config, _status_data, j, i)
                end
            end
        elseif _status_data.grid[6][i] == "A" then --消除小宝箱,点亮未被点亮的格子
            local series = {} --保存未被点亮的坐标x
            for j = 1, 5 do
                if _status_data.grid[j][i] ~= 0 then
                    table.insert(series, j)
                end
            end
            local x = series[math.random(#series)]
            _status_data.grid[x][i] = 0
            count = count + line(_config, _status_data, x, i)
        elseif _status_data.grid[6][i] == "B" then --消除大宝箱
            local x, y = find_max(_config, _status_data)
            _status_data.grid[x][y] = 0
            count = count + line(_config, _status_data, x, y)
        end
    end
end

--计算当前得分，返回当前倍率 和 下次奖励倍率
local function score(_config, _status_data)
    -- body
end

--转成数据为字符串
local function game_data_to_string(_game_data_vec)
    for i, v in ipairs(_game_data_vec) do
        _game_data_vec[i] = tostring(v)
    end

    return table.concat(_game_data_vec)
end

function LF.create_one_data(_config, _status_data)
    create_grid(_config, _status_data)
    for i = 1, 6 do
        light(_config, _status_data)
        score(_config, _status_data)
        create_random(_config, _status_data)
    end

    return {
        rate = _status_data.rate,
        game_data = game_data_to_string(_status_data.game_data_vec)
    }
end

return LF
