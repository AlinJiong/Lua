--[[
    消消乐数据生成

    结果数据结构：
    {
        all_rate=0,             -- 总赔率： 每个元素赔率 相加
        xc_data="631413.....",  -- 消除数据
        prog=0,                 -- 小游戏进度值， 大于等于 100 表明有小游戏
    }
--]]
require "printfunc"

local xxl_bsmz_lib = require "xxl_bsmz_lib"

--[[
    生成的数据： 赔率 => {小游戏进度(精确到10%) => {结果数组} }

--]]
local xiaoxiao_datas = {}

-- 配置表
local config = {
    -- 每种普通元素的赔率（消除价值），不包括特殊元素。
    -- 说明： 元素id => {消除个数 => 赔率}
    normal_rate = {
        {0, 0, 1, 2, 5, 10},
        {0, 0, 2, 5, 8, 20},
        {0, 0, 3, 6, 9, 30},
        {0, 0, 4, 7, 10, 35},
        {0, 0, 5, 8, 15, 40}
    },

    -- 加进度： 消除个数 => 进度
    prog_rate = {7, 8, 9, 10, 11, 12},
    prog_spec_rate = {0, 0, 0, 15, 20, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45},

    -- 特殊元素生成： 消除个数 => 特殊元素
    spec_make = {nil, nil, nil, "A", "B", "C"},
    -- 特殊元素赔率
    spec_rate = {A = 10, B = 20, C = 30}
}

-- 计算结果数据的 hash 值，用于查重
local function data_hash(_data)
    return _data.xc_data
end

local function main()
    -- 状态数据
    local _status_data = {
        total_count = 0,
        xc_data_map = {} -- 消除数据
    }

    for i = 1, 5 do
        local _data = xxl_bsmz_lib.create_one_data(config, _status_data)

        local _hash = data_hash(_data)

        if not _status_data[_hash] then
            _status_data.total_count = _status_data.total_count + 1
            _status_data[_hash] = true

            dump(_data)
        end
    end
end

main()
