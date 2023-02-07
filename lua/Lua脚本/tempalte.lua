--- 启动调试
local mobdebug = require("src.initial.mobdebug");
mobdebug.start();
local redis = require "resty.redis"
local red = redis:new()
local res,err = red:connect("127.0.0.1",6379)
if not res then
    ngx.say("failed to connect: ", err)
    return
end
res,err = red:auth("123456")
if not res then
    ngx.say("failed to authenticate: ", err)
    return
end
res, err = red:get("message")
if not res  then
    ngx.say("failed to get: ", err)
    return
end
if res == ngx.null then
    ngx.say("not find message: ")
    return
end
local msg = res;
res, err = red:close()
ngx.say(msg)