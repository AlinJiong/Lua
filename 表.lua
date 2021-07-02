lists = {"one", "two", "three", "four", "five"}

-- concat连接三种方式
print(table.concat(lists))
print(table.concat(lists, ","))
print(table.concat(lists, ",", 2, 4))

-- insert&remove
table.insert(lists, "six")
table.insert(lists, 2, 1)

print(table.concat(lists, ","))

table.remove(lists)
table.remove(lists, 2)

print(table.concat(lists, ","))

-- sort排序
print("Before")
for i, v in ipairs(lists) do
    print(i, v)
end

print("After")
table.sort(lists)
for i, v in ipairs(lists) do
    print(i, v)
end
