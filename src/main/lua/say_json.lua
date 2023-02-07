local cjson = require "cjson"
local function say_json()
    ngx.header.content_type = "application/json;charset=utf8"
    local response = {}
    response['code'] = 200
    response['msg'] = 'SUCCESS'
    response['success'] = true
    ngx.say(cjson.encode(response))
end
say_json()