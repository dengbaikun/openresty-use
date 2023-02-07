--设置JSON响应
ngx.header.content_type="application/json;charset=utf8"

--引入依赖包
local cjson = require "cjson"
local rabbitmq = require "resty.rabbitmqstomp"
--依赖token.lua,解析令牌数据
local jwttoken = require "token"

--获取请求头Authorization
local auth_header = ngx.var.http_Authorization
--秘钥
local secret = "5pil6aOO5YaN576O5Lmf5q+U5LiN5LiK5bCP6ZuF55qE56yR"
--通过token.lua中的check方法校验
local result = jwttoken.check(auth_header,secret)

--令牌校验通过了，则发送MQ排队信息
if result.code==200 then
	--校验通过
	--配置MQ的账号密码
	local opts = { username = "guest",
				   password = "guest",
				   vhost = "/" }	
	--创建RabbitMQ对象	
	local mq, err = rabbitmq:new(opts)

	--设置超时时间
	mq:set_timeout(10000)

	--链接RabbitMQ
	local ok, err = mq:connect("192.168.211.141",61613)

	--配置请求头信息  配置给哪个Queue（队列）发送消息、消息的编码等等
	local headers = {}
	--目标地址
	headers["destination"] = "/queue/red.queue"
	headers["receipt"] = "msg#1"
	headers["app-id"] = "luaresty"
	headers["persistent"] = "true"
	--传递的数据的类型
	headers["content-type"] = "text/plain"
	--编码格式
	headers["content_encoding"] = "UTF-8"
		
	--准备消息
	local msg = {}
	msg["user"]=result.body.payload.username

	--发送
	local ok, err = mq:send(cjson.encode(msg), headers)

	--响应消息
	local resp = {}

	if not ok then
		resp["code"]=500
		resp["message"]="手太慢了"
		resp["body"]=err
		ngx.say(cjson.encode(resp))
		return
	end
	
	--成功
	resp["code"]=200
	resp["message"]="排队抢红包！"
	resp["body"]=err
	ngx.say(cjson.encode(resp))
	return
else
	--校验失败输出结果集
	ngx.say(cjson.encode(result))
end




