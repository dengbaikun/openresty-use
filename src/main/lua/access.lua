--依赖token.lua,解析令牌数据
local jwttoken = require "token"
local cjson = require("cjson");
--数据响应类型JSON
ngx.header.content_type="application/json;charset=utf8"
--获取请求头Authorization
local auth_header = ngx.var.http_Authorization
--秘钥
local secret = "5pil6aOO5YaN576O5Lmf5q+U5LiN5LiK5bCP6ZuF55qE56yR"
--通过token.lua中的check方法校验
local result = jwttoken.check(auth_header,secret)

--令牌校验通过了
if result.code==200 then
    --ngx.say(cjson.encode(result))
    payload = result.body.payload
    ngx.req.set_header("payload", cjson.encode(payload))
    return true;
else
	--校验失败输出结果集
	ngx.say(cjson.encode(result))
end