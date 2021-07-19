-- 基础函数库

local basefunc = {
    string={},
}

-- 字符串分割
-- 来自 http://blog.163.com/chatter@126/blog/static/127665661201451983036767/
function basefunc.string.split(str, sepa)
	if str==nil or str=='' then
		return nil
	end

	sepa = sepa or ","

    local result = {}
    for match in (str..sepa):gmatch("(.-)"..sepa) do
        table.insert(result, match)
    end
    return result
end

-- 反向查找（简单查找，不支持模式匹配）
-- 找到则起始及终点位置的索引； 否则，返回 nil。
function basefunc.string.rfind(str,find)

	-- 倒序查找
	local rstr = string.reverse(str)
	local rfind = string.reverse(find)

	local r1,r2 = string.find(rstr,rfind,1,true)
	if not r1 then return nil end

	-- 换算成正序
	local len = string.len(str)
	return len - r2 + 1,len - r1 + 1
end
function basefunc.string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end
function basefunc.string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end
function basefunc.string.trim(input)
    return string.gsub(input, "^%s*(.-)%s*$", "%1")
end


return basefunc