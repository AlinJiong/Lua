-- goto���
local a = 1
::label::  print("--- goto label ---")

a = a+1
if a < 3 then
    goto label   -- a С�� 3 ��ʱ����ת����ǩ label
end
