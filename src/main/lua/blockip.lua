--动态白名单
--Redis库依赖
local redis = require("resty.redis");
local cjson = require("cjson");
--key组装
local key = "whitelist"
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
local whitelist_ips = cjson.decode(result)
local iputils = require("resty.iputils")
local whitelist = iputils.parse_cidrs(whitelist_ips)
if not iputils.ip_in_cidrs(ngx.var.remote_addr, whitelist) then
  return ngx.exit(ngx.HTTP_FORBIDDEN)
end