local redis = require "redis_tool"
local red = redis:new()
--ngx.log(ngx.ERR,"red.host",str(red.host))
--local ok, err = red:set("dog", "an animal")
--if not ok then
--    ngx.say("failed to set dog: ", err)
--    return
--end
--red:t1()
ngx.say(red.host)
ngx.say(red._VERSION)
ngx.say(redis.port)
red:init_pipeline()
red:set("dog", "an animal")
ngx.say(red:get('dog'))
red:commit_pipeline()
--red:t1()
--ngx.say("set result: ", ok)