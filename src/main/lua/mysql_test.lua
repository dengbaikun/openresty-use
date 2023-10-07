---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/9/28 16:43
---
---
local MysqlPool = require "mysql_db"
local RedisPool = require "redis_db"
local cjson = require("cjson");
local success_response = {}
success_response["code"] = 200
success_response["message"] = "成功"
ngx.header.content_type = "application/json"
-- 创建 Redis 连接
local red, err = RedisPool.new()
if not red then
    ngx.say("Failed to connect to Redis: ", err)
    return
end
local redis_key = 'test_db================='
local res, err = RedisPool.command(red, "get", redis_key)
if res == ngx.null then
    -- 创建数据库连接
    local db, err = MysqlPool.new()
    if not db then
        ngx.say("Failed to connect to the mysql_db: ", err)
        return
    else
        -- 执行查询
        local sql = "SELECT * FROM users"
        local res, err = MysqlPool.query(db, sql)
        if not res then
            ngx.say("Failed to execute query: ", err)
        else
            local data = res
            res, err = RedisPool.command(red, "set", redis_key, cjson.encode(data))
            res, err = RedisPool.command(red, "expire", redis_key, 10)
            success_response["data"] = data
            --数据响应类型JSON
            ngx.say(cjson.encode(success_response))
            --ngx.log(ngx.ERR,"res type :",type(res))
            ---- 处理查询结果
            --for i, row in ipairs(res) do
            --    ngx.say("TYPE ",type(row))
            --    ngx.log(ngx.ERR,"row:",cjson.encode(row))
            --    ngx.log(ngx.ERR,"row concat:",table.concat(row))
            --    ngx.say("Row ", i, "role: ", row['role'])
            --    ngx.say("Row ", i, ": ", cjson.encode(row))
            --end
        end
        --释放数据库连接
        MysqlPool.close(db)
        RedisPool.close(red)
    end
else
    res, err = RedisPool.command(red, "expire", redis_key, 10)
    success_response["data"] = cjson.decode(res)
    ngx.say(cjson.encode(success_response))
    RedisPool.close(red)
end