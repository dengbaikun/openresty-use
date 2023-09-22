local cjson = require("cjson");
local redis = require "resty.redis"

-- 创建一个Redis连接池
local red = redis:new()

-- 设置连接超时时间（以毫秒为单位）
red:set_timeout(1000)
-- 连接到Redis服务器
local ok, err = red:connect("127.0.0.1", 6379)
--设置超时时间
red:set_timeout(2000)
--设置服务器链接信息
red:connect("127.0.0.1", 6379)
--设置服务器链接密码
red:auth("123456")

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
    local auth_header = ngx.var.http_Authorization
    if auth_header == nil then
        --校验失败输出结果集
        ngx.say(cjson.encode(not_authority_response))
        return
    end
    local token = "token::" .. auth_header
    local result, err = red:get(token)
    --
    ---- token过期
    if ngx.null == result then
        --校验失败输出结果集
        ngx.say(cjson.encode(not_authority_response))
        return
    else
        --校验失败输出结果集
        local user = cjson.decode(result)
        local username = user['username']
        local uri = ngx.var.uri
        --获取最后一则
        local last_standard = string.match(uri, "/([^/]*)$");
        split_data = split(last_standard, '_')
        if table.maxn(split_data) > 1 then
            --获取用户标识
            local user_identifying = split_data[2]
            if user_identifying == username then
                --ngx.say('SUCCESS')
                return True
            else
                --校验失败输出结果集
                ngx.say(cjson.encode(not_authority_response))
                return
            end
        else
            --校验失败输出结果集
            ngx.say(cjson.encode(not_authority_response))
            return
        end
    end


end
main()


