-- goto语句
local a = 1
::label::  print("--- goto label ---")

a = a+1
if a < 3 then
    goto label   -- a 小于 3 的时候跳转到标签 label
end
