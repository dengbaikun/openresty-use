---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/10/8 16:35
---
local cjson = require("cjson")
local AesTool = require("aes_tool")
--ngx.say(ngx.arg[1])
ngx.log(ngx.ERR,"asd:",ngx.arg[1])
--ngx.log(ngx.ERR,"asd:",response)
-- ngx.arg 是一个数组下标1 是数据，下标2代表的结束设置为true
ngx.arg[1] = AesTool.encrypt(ngx.arg[1])
ngx.arg[2] = true
