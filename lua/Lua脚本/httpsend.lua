--响应数据JSON
ngx.header.content_type="application/json;charset=utf8"
--引入依赖库
local http = require "resty.http"
local cjson = require "cjson"

--获取uri

--Redis缓存中找对应的URI
--如果是404，返回
--ngx.say("无效地址！")
--code =404
--return;

--创建链接对象
local httpc = http.new()

--指定请求头、提交数据、提交的地址
--执行HTTP请求
local res, err = httpc:request_uri("http://192.168.0.101:18082/api/userinfo/one", {
	method = "GET",
	headers = {
	  ["Content-Type"] = "application/x-www-form-urlencoded",
	},
	keepalive_timeout = 60000,
	keepalive_pool = 10
})

--判断code==404

--lua操作Redis缓存-->缓存地址


--响应结果
ngx.say(res.body)