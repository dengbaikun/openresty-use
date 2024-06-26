---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/10/8 16:35
---
local cjson = require("cjson")
local AesTool = require("aes_tool")
local RsaTool = require("rsa_tool")
local CryptographyType = ngx.req.get_headers()["Cryptography"]
ngx.log(ngx.ERR,"CryptographyType encrypt:",CryptographyType)
local Cryptography = AesTool
if CryptographyType == 'RSA' then
    Cryptography = RsaTool
end
----ngx.say(ngx.arg[1])
--ngx.log(ngx.ERR,"asd:", ngx.arg[1])
----ngx.log(ngx.ERR,"asd:",response)
---- ngx.arg 是一个数组下标1 是数据，下标2代表的结束设置为true
--ngx.arg[1] = AesTool.encrypt(ngx.arg[1])
--ngx.arg[2] = true
-- 获取当前响应数据
local chunk, eof = ngx.arg[1], ngx.arg[2]
local status = ngx.status
--ngx.log(ngx.ERR, "Response status: " .. status)
if status == ngx.HTTP_OK then
    -- 定义全局变量，收集全部响应
    if ngx.ctx.buffered == nil then
        ngx.ctx.buffered = {}
    end

    -- 如果非最后一次响应，将当前响应赋值
    if chunk ~= "" and not ngx.is_subrequest then
        table.insert(ngx.ctx.buffered, chunk)

        -- 将当前响应赋值为空，以修改后的内容作为最终响应
        ngx.arg[1] = nil
    end

    -- 如果为最后一次响应，对所有响应数据进行处理
    if eof then
        -- 获取所有响应数据
        local whole = table.concat(ngx.ctx.buffered)
        ngx.ctx.buffered = nil
        ngx.log(ngx.ERR,"whole:",whole)
        -- 进行你所需要进行的处理
        whole = Cryptography.encrypt(whole)

        -- 重新赋值响应数据，以修改后的内容作为最终响应
        ngx.arg[1] = whole
    end
end