local series = {}
table.insert(series, {1, 1})
table.insert(series, {1, 2})
table.insert(series, {1, 3})

print(series[2][2])
for i = 1, #series do
    print(series[i][1],series[i][2])
end

