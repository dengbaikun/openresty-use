---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/10/12 16:01
---
package.path = 'F:/IdeaProject/openresty/openresty/src/main/lua/lua-resty-jwt/lib/?.lua;;G:/openresty-1.21.4.1-win64/lualib/?.lua;;'
local ffi = require("ffi")
--local openssl = ffi.load("C:/Program Files/OpenSSL-Win64/bin/libssl-1_1-x64.dll")  -- 请根据你的系统和库文件名称进行调整
local openssl = ffi.load("C:/Program Files/OpenSSL-Win64/bin/libcrypto-1_1-x64.dll")
local jwt = require "resty.jwt"
local secret_key = "lua-resty-jwt"
local cjson = require "cjson"
local jwt_obj = {
    header = { typ = "JWT", alg = "HS256" },
    payload = { foo = "bar" }
}
local jwt_token = jwt:sign(secret_key, jwt_obj)
print(jwt_token)
jwt_obj = jwt:verify(secret_key, jwt_token)
print(cjson.encode(jwt_obj))
--ngx.say(jwt_token)