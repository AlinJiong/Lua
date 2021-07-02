function test(list)
    local index = 0
    local len = #list
    return function()
        index = index + 1
        if index <= len  then
            return list[index]
        end
    end
end

a = {1, 2, 3, 4, 5}
for i in test(a) do
    print(i)
end
