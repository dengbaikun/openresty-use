---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2024/4/10 14:17
---
-- ip_counter.lua
local _M = {}
local RedisPool = require "redis_tool"
local function format_number(count)
    if count >= 1000 then
        return string.format("%.1fk", count / 1000)
    else
        return tostring(count)
    end
end
function _M.print()
    local ip = ngx.var.remote_addr
    local uri = ngx.var.request_uri
    local host = ngx.var.host
    local red, err = RedisPool:new({ db_index = 0, host='127.0.0.1',port=6379,timeout=5,password='waef@aAdqwe123'})
    if not red then
        ngx.exit(ngx.HTTP_FORBIDDEN)
        return
    end
    local count;
    -- 忽略对 /favicon.ico 的计数
    if uri ~= "/favicon.ico" then
        local res, err = red:incr(host..':'..ip)
        count = res
    end
    local formatted_count = format_number(count)
    ngx.say('<html>')
    ngx.say('<head><style>')
    ngx.say('body { font-size: 30px; }')
    ngx.say('.ip { color: red; }')
    ngx.say('.domain { color: darkorange; }')
    ngx.say('.uri { color: green; }')
    ngx.say('.method { color: blue; }')
    ngx.say('.useragent { color: purple; }')
    ngx.say('.pink-text {color: pink; font-size: 50px;}')
    ngx.say('</style></head>')
    ngx.say('<body>')
    ngx.say('<p class="pink-text">you have been recorded</h1>')
    ngx.say('<p class="ip">Client IP: ', ngx.var.remote_addr, '</p>')
    ngx.say('<p>Number of visits: ', formatted_count, '</p>')
    ngx.say('<p class="domain">Host: ', host, '</p>')
    ngx.say('<p class="uri">Request URI: ', ngx.var.request_uri, '</p>')
    ngx.say('<p class="method">Request Method: ', ngx.var.request_method, '</p>')
    ngx.say('<p class="useragent">User-Agent: ', ngx.var.http_user_agent, '</p>')
    ngx.say('</body></html>')
end

return _M
