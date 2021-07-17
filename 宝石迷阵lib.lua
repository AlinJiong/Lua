--[[
    消消乐数据生成，函数库

    中间数据结构
    creator = {
        -- 当前格子数据 8 x 8
        grid = {
            {1,2,4,4,4,4,5,6},
            {1,2,4,4,4,4,5,6},
            ... 
        }
        xc_data_vec = {3,4,5,2,3,...} -- 格子数据序列，数组。（每次填充新元素 都追加到 尾部）

        cur_has_spec=true/false -- 本次消除 是否 有特殊元素

        cur_spec_C = {4,6,2} --消除特殊元素为C的原始数据集合

        all_rate=n -- 赔率

        prog=n -- 小游戏进度
    }
--]]
local LF = {}

-- 生成一个 8x8 格子数据：初始化元素填充
local function create_grid(_config, _status_data)
    _status_data.grid = {}
    _status_data.xc_data_vec = {}
    for i = 1, 8 do
        _status_data.grid[i] = {}
        for j = 1, 8 do
            _status_data.grid[i][j] = math.random(5)
            table.insert(_status_data.xc_data_vec, _status_data.grid[i][j])
        end
    end
end

-- 开始生成一条结果：初始化中间数据
local function init_creator_data(_config, _status_data)
    _status_data.cur_has_spec = false
    _status_data.all_rate = 0
    _status_data.prog = 0
    _status_data.cur_spec_C = {}
    create_grid(_config, _status_data)
end

local function drop(_config, _status_data) --下落函数
    for i = #_status_data.grid, 2, -1 do --第一行可以为0
        for j = 1, #_status_data.grid do --元素下落
            if _status_data.grid[i][j] == 0 then
                for k = i - 1, 1, -1 do
                    if _status_data.grid[k][j] ~= 0 then
                        _status_data.grid[i][j], _status_data.grid[k][j] =
                            _status_data.grid[k][j],
                            _status_data.grid[i][j]
                        break
                    end
                end
            end
        end
    end
end

local function restore(_config, _status_data) --填充函数
    for i = #_status_data.grid, 1, -1 do
        local flag = 0
        for j = 1, #_status_data.grid do
            if _status_data.grid[i][j] == 0 then
                flag = 1
            end
        end
        if flag == 1 then
            for k = 1, #_status_data.grid do
                if _status_data.grid[i][k] ~= 0 then
                    table.insert(_status_data.xc_data_vec, 0)
                else
                    _status_data.grid[i][k] = math.random(5)
                    table.insert(_status_data.xc_data_vec, _status_data.grid[i][k])
                end
            end
        end
    end
end

-- 下落格子元素。 下落、新元素填充
local function drop_grid(_config, _status_data)
    drop(_config, _status_data)
    restore(_config, _status_data)
end

-- 爆炸特殊元素
local function blast_spec(_config, _status_data)
    for i = 1, #_status_data.grid do
        for j = 1, #_status_data.grid do
            if _status_data.grid[i][j] == "A" then
                _status_data.grid[i][j] = 0
                for k = 1, #_status_data.grid do
                    if type(_status_data.grid[k][j]) == "number" then
                        _status_data.grid[k][j] = 0
                    end
                end
            elseif _status_data.grid[i][j] == "B" then
                _status_data.grid[i][j] = 0
                local left = (i - 1 >= 1 and i - 1 or 1)
                local right = (i + 1 <= #_status_data.grid and i + 1 or #_status_data.grid)
                local up = (j - 1 >= 1 and j - 1 or 1)
                local down = (j + 1 <= #_status_data.grid and j + 1 or #_status_data.grid)
                for x = left, right do
                    for y = up, down do
                        if type(_status_data.grid[x][y]) == "number" then
                            _status_data.grid[x][y] = 0
                        end
                    end
                end
            elseif _status_data.grid[i][j] == "C" then --如果为C，取出一个元素变为0
                _status_data.grid[i][j] = 0
                local number = _status_data.cur_spec_C[#_status_data.cur_spec_C]
                table.remove(_status_data.cur_spec_C)
                for x = 1, #_status_data.grid do
                    for y = 1, #_status_data.grid do
                        if _status_data.grid[x][y] == number then
                            _status_data.grid[x][y] = 0
                        end
                    end
                end
            end
        end
    end
end

-- 递归寻找相同元素的序列
local function DF(tab, x, y, series)
    series = series or {}
    local number = tab[x][y]

    if number == 0 or type(number) == "string" then --提前结束，以及为当前元素为0的情况下，返回空序列
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

--根据相同元素序列，找到左下角元素位置(x,y)
local function left_down(series)
    local down = series[1][1]
    local left = 100

    for i = 1, #series do
        if series[i][1] > down then
            down = series[i][1]
        end
    end

    for i = 1, #series do
        if series[i][1] == down then
            if series[i][2] < left then
                left = series[i][2]
            end
        end
    end

    return down, left
end

--自定义深拷贝函数，只能拷贝一维
local function deepcopy(orig)
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

--自定义二维拷贝函数
local function copy_table(tab)
    local copy = {}
    for i = 1, #tab do
        copy[i] = deepcopy(tab[i])
    end
    return copy
end

--[[
    消除： 
        1、消除元素， 并用空白 或 特殊元素填充消除的位置、 设置 cur_has_spec ； 
        2、计算赔率，小游戏进度，累加到中间数据

    返回值：有消除返回 true 
--]]
local function xiaochu_grid(_config, _status_data)
    _status_data.cur_has_spec = false --初始置为false
    local grid_copy = copy_table(_status_data.grid)
    for i = 1, #_status_data.grid do
        for j = 1, #_status_data.grid do
            if #DF(grid_copy, i, j, nil) >= 3 then
                _status_data.cur_has_spec = true
                local number = _status_data.grid[i][j] --保存当前元素
                local series = DF(_status_data.grid, i, j, nil) --消除元素
                local count = (#series < 6 and #series or 6) --控制小于等于6
                _status_data.all_rate = _status_data.all_rate + _config.normal_rate[number][count] --普通元素消除,赔率增加
                _status_data.prog = _status_data.prog + _config.prog_rate[number] --普通元素消除，进度增加
                if #series > 3 then
                    local x, y = left_down(series)
                    _status_data.grid[x][y] = _config.spec_make[count] --处理4个及以上的元素
                    _status_data.all_rate = _status_data.all_rate + _config.spec_rate[_config.spec_make[count]] --特殊元素消除，赔率增加
                    _status_data.prog = _status_data.prog + _config.prog_spec_rate[#series] --特殊元素消除，进度增加
                end

                if #series >= 6 then --6连及以上的数据
                    table.insert(_status_data.cur_spec_C, number)
                end
            end
        end
    end

    return _status_data.cur_has_spec
end

-- 转换消除数据为字符串
local function xc_data_to_string(_xc_data_vec)
    for i, v in ipairs(_xc_data_vec) do
        _xc_data_vec[i] = tostring(v)
    end

    return table.concat(_xc_data_vec)
end

-- 生成一条游戏结果数据
function LF.create_one_data(_config, _status_data)
    init_creator_data(_config, _status_data)

    while xiaochu_grid(_config, _status_data) do
        drop_grid(_config, _status_data)

        if _status_data.cur_has_spec then
            blast_spec(_config, _status_data)

            drop_grid(_config, _status_data)
        end
    end

    -- 结束，组装数据
    return {
        all_rate = _status_data.all_rate,
        xc_data = xc_data_to_string(_status_data.xc_data_vec),
        prog = _status_data.prog
    }
end

return LF
