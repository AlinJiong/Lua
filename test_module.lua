-- 加载方式第一种
require("module")

print(module.constant)
module.func1()
module.func3()

-- 加载方式第二种
local m = require("module")
print(m.constant)
