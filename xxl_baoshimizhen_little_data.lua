--[[
    小游戏 数据生成
    {
        rate = 0,              --总倍率：连线 和 特殊奖励 相加
        game_data="133545687", --生成序列
    }
--]]
-- 数据缓存（未写入文件）
local little_game_data = {}
require "printfunc"
local little_lib = require "xxl_bsmz_little_lib"

local config = {
    --普通玩法的四角以及中间格子坐标
    normal_loc = {
        {1, 1},
        {1, 5},
        {5, 1},
        {5, 5},
        {3, 3}
    },
    --额外押注新增的四角坐标
    extra_loc = {
        {2, 3},
        {3, 2},
        {3, 4},
        {4, 3}
    },
    --普通玩法四角和中间格子点亮的奖励
    normal_rate = {0.7, 0.7, 0.7, 0.7, 1.4},
    --额外押注新增的四角的奖励
    extra_rate = {0.7, 0.7, 0.7, 0.7}
}

-- 计算结果数据的 hash 值，用于查重
local function data_hash(_data)
    return _data.xc_data
end

local function main()
    -- 状态数据
    local _status_data = {
        total_count = 0
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
