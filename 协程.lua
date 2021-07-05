co =
    coroutine.create(
    function()
        for i = 1, 3 do
            print("Before", i)
            coroutine.yield()
            print("After", i)
        end
    end
)

coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)

print("...wrap...")
function wrap(param)
    print("Before", param)
    obtain = coroutine.yield()
    print("After", obtain)
    return 3
end

resumer = coroutine.wrap(wrap)
print(resumer(1))
print("......")
print(resumer(2))
