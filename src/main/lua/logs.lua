--引入库文件
local cjson = require "cjson"
local producer = require "resty.kafka.producer"

--创建Kafka链接配置
local broker_list = {
	{ host = "47.119.115.165", port = 9092 },
}
--创建消息生产者对象
local bp = producer:new(broker_list, { producer_type = "async" })

--获取用户IP
local headers=ngx.req.get_headers()
local ip=headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"

--创建消息信息 时间、ip、uri
local logjson = {}
logjson["accesstime"]=os.date("%Y-%m-%d %H:%m:%S")
logjson["ip"]=ip
logjson["uri"]=ngx.var.uri

--发送消息
local ok, err = bp:send("seckilllog", nil, cjson.encode(logjson))
if not ok then
	ngx.say("send err:", err)
	return
end

