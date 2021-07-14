
--     local len, label = judgeRow(arrCopy[i])
--     if label ~= 0 then
--         for j = label - len + 1, label do
--             arr[i][j] = 0
--         end
--     end

--     local len, label = judgeCol(arrCopy, i)
--     if label ~= 0 then
--         for j = label - len + 1, label do
--             arr[j][i] = 0
--         end
--     end
-- end

erase(arr)
printTable(arr)
printTable(arrCopy)

remove(arr)
printTable(arr)

print(restore(arr))
printTable(arr)
