---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/2/6 15:56
---
local cjson = require "cjson"
say_hello = {}

function say_hello.say(msg)
    local response = {}
    response['code'] = 200
    response['msg'] = msg
    response['success'] = true
    print(response['msg'])
    local str = cjson.encode(response)
    return str
end
return say_hello