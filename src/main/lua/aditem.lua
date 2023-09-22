--数据响应类型JSON
ngx.header.content_type="application/json;charset=utf8"
--Redis库依赖
local redis = require("resty.redis");
local cjson = require("cjson");

--获取id参数（type）
--local id = ngx.req.get_uri_args()["id"];
local uri = ngx.var.uri;
--获取最后一则
local username =  string.match(uri, "/([^/]*)$");
--key组装
local key = "user::"..username
--创建链接对象
local red = redis:new()
--设置超时时间
red:set_timeout(2000)
--设置服务器链接信息
red:connect("127.0.0.1", 6379)
--设置服务器链接密码
red:auth("123456")
--查询指定key的数据
local result=red:get(key);
--关闭Redis链接
red:close()
if result==nil or result==null or result==ngx.null then
    return true
else
    --输出数据
    ngx.say(result)
end