--多级缓存流程操作
--1）Lua脚本查询Nginx缓存
--2）Nginx如果没有缓存
--2.1）Lua脚本查询Redis
--2.1.1）Redis如果有数据，则将数据存入到Nginx缓存，并响应用户
--2.1.2）Redis没有数据，Lua脚本查询MySQL
--       MySQL有数据，则将数据存入到Redis、Nginx缓存[需要额外定义]，响应用户
--3）Nginx如果有缓存，则直接将缓存响应给用户



--响应数据为JSON类型
ngx.header.content_type="application/json;charset=utf8"
--引入依赖库
--cjson：对象转JSON或者JSON转对象
local cjson = require("cjson")
local mysql = require("mysql")
local lrredis = require("redis")

--获取请求参数ID   http://192.168.211.141/act?id=1
local id = ngx.req.get_uri_args()["id"];

--加载本地缓存
local cache_ngx = ngx.shared.act_cache;

--组装本地缓存的key,并获取nginx本地缓存
local ngx_key = 'ngx_act_cache_'..id
local actCache = cache_ngx:get(ngx_key)

--如果nginx中没有缓存，则查询Redis集群缓存
if actCache == "" or actCache == nil then
	--从Redis集群中加载数据
	local redis_key = 'redis_act_'..id
	local result = lrredis.get(redis_key)
	
	--Redis中数据为空，查询数据库
	if result[1]==nil or result[1]==ngx.null then
		--组装SQL语句
		local sql = "select * from activity_info where id ="..id
		--执行查询
		result = mysql.query(sql)
		--数据不为空，则添加到Redis中
		if result[1]==nil or result[1]==ngx.null then
			ngx.say("no data")
		else
			--数据添加到Nginx缓存和Redis缓存
			lrredis.set(redis_key,cjson.encode(result))
			cache_ngx:set(ngx_key, cjson.encode(result), 2*60);
			ngx.say(cjson.encode(result))
		end
	else
		--将数据添加到Nginx缓存中
		cache_ngx:set(ngx_key, result, 2*60);
		--直接输出
		ngx.say(result)
	end
else
	--输出缓存数据
	ngx.say(actCache)
end