package.path ='C:/Program Files (x86)/Lua/5.1/three/redis-lua-2.0.4/src/?.lua;;D:/luasocket-3.1.0/src/?.lua'
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by DK.
--- DateTime: 2023/2/6 16:55
---
redis_client ={}

function redis_client.call(cmd, ...)
    local redis = require 'redis'
    local host = "127.0.0.1"
    local port = 6379
    local password = "123456"
    client = redis.connect(host, port)
    client:auth(password)
    redis.call = function(cmd, ...)
        return loadstring('return client:'.. string.lower(cmd) ..'(...)')
    end
end

return redis_client
