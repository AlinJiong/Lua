local db = {}

local command = {}

function command.GET(key)
    return db[key]
end

function command.SET(key, value)
    local last = db[key]
    db[key] = value
    return last
end

command.SET(1, 2)
print(command.GET(1))
print(command.SET(1, 3))

print(command.GET(1))