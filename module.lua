module = {}
module.constant = "constant常量"

function module.func1()
    print("this is a public function\n")
end

local function func2()
    print("this is a private function\n")
end

function module.func3()
    func2()
end

return module
