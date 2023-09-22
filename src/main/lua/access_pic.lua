local cjson = require("cjson");
local redis = require "resty.redis"

-- 创建一个Redis连接池
local red = redis:new()

-- 定义连接池的配置
local redis_config = {
    host = "127.0.0.1",   -- Redis 服务器地址
    port = 6379,          -- Redis 服务器端口
    timeout = 1000,       -- 连接超时时间（毫秒）
    max_idle_timeout = 60000, -- 连接在连接池中的最大空闲时间（毫秒）
    pool_size = 100,       -- 连接池大小
    password = "123456"
}

-- 连接到 Redis 服务器
local ok, err = red:connect(redis_config.host, redis_config.port)
--设置服务器链接密码
red:auth(redis_config.password)
if not ok then
    ngx.say("Failed to connect to Redis: ", err)
    return
end

-- 设置连接池中的最大空闲时间
red:set_idle_timeout(redis_config.max_idle_timeout)
--


function split(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function main()
    --数据响应类型JSON
    ngx.header.content_type = "application/json;charset=utf8"
    --获取请求头Authorization
    local not_authority_response = {}
    not_authority_response["code"] = 403
    not_authority_response["message"] = "无权限访问"
    local success_response = {}
    success_response["code"] = 200
    success_response["message"] = "成功"
    local auth_header = ngx.var.http_Authorization
    if auth_header == nil then
        --校验失败输出结果集
        ngx.say(cjson.encode(not_authority_response))
        return
    end
    local token = "token::" .. auth_header
    ngx.say(token)
    local result, err = red:get(token)
    -- 放回连接到连接池中
    red:set_keepalive(redis_config.pool_size)
    ngx.say(result)
    ----
    ------ token过期
    --if ngx.null == result or nil == result then
    --    --校验失败输出结果集
    --    ngx.say(cjson.encode(not_authority_response))
    --    return
    --else
    --    ngx.say(result)
    --    ----校验失败输出结果集
    --    --local user = cjson.decode(result)
    --    --local username = user['username']
    --    --local uri = ngx.var.uri
    --    ----获取最后一则
    --    --local last_standard = string.match(uri, "/([^/]*)$");
    --    --split_data = split(last_standard, '_')
    --    --if table.maxn(split_data) > 1 then
    --    --    --获取用户标识
    --    --    local user_identifying = split_data[1]
    --    --    if user_identifying == username then
    --    --        --ngx.say('SUCCESS')
    --    --        return true;
    --    --    else
    --    --        --校验失败输出结果集
    --    --        ngx.say(cjson.encode(not_authority_response))
    --    --        return
    --    --    end
    --    --else
    --    --    --校验失败输出结果集
    --    --    ngx.say(cjson.encode(not_authority_response))
    --    --    return
    --    --end
    --end


end
main()


