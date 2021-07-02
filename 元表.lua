tab = {"one"}
metab = {"1"}

setmetatable(tab, metab)

print(getmetatable(tab[1]))
