-- 默认为共有继承，.访问成员对象，:调用成员函数。

Account = {balance = 10}
function Account:withdraw(v)
    self.balance = self.balance - v
end

function Account:deposit(v)
    self.balance = self.balance + v
end

-- 通过creat函数实例化一个类,继承于Account
function Account:create()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

a = Account:create()
--重写基类方法
function a:deposit(v)
    print("hello world")
end

print(a.balance)
a.deposit(100)

-- 调用基类的方法使用:
-- 访问成员对象用.

a:withdraw(200)
print(a.balance)
