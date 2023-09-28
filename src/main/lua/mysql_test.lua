---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/9/28 16:43
---
---
local mysql_db = require "mysql_db"
local redis_db = require "redis_db"
local cjson = require("cjson");
local success_response = {}
success_response["code"] = 200
success_response["message"] = "成功"
ngx.header.content_type = "application/json"
-- 创建数据库连接
local red, err = redis_db.new()
if not red then
    ngx.say("Failed to connect to the mysql_db: ", err)
    return
end
resp,err = red:get('test_db=================')
ngx.log(ngx.ERR,"test_db========222222=========",resp)
if not resp then
    ngx.log(ngx.ERR,"test_db=============11111111====",resp)
    success_response["data"] = cjson.decode(resp)
    ngx.say(cjson.encode(success_response))
    redis_db.close(red)
    return
end
-- 创建数据库连接
local db, err = mysql_db.new()
if not db then
    ngx.say("Failed to connect to the mysql_db: ", err)
    return
end
-- 执行查询
local sql = "SELECT * FROM users"
local res, err = mysql_db.query(db, sql)
if not res then
    ngx.say("Failed to execute query: ", err)
else
    red:set('test_db=================', cjson.encode(res))
    success_response["data"] = res
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
-- 释放数据库连接
mysql_db.close(db)
redis_db.close(red)
