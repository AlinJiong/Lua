tabl = {key1 = "val1", key2 = "val2", "val3"}
for k, v in pairs(tabl) do
    print(k .. "-" .. v)
end

tabl.key1 = nil
for k, v in pairs(tabl) do
    print(k .. "-" .. v)
end
