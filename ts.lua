function ts(tab)
    return tab[1], tab[2]
end

tab = {1, 2, 3}
v1, v2 = ts(tab)
while v1 ~= 0 do
    print(tab[1])
    if (tab[1] == 1) then
        break
    end
end
