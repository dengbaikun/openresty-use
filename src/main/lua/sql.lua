---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/2/8 10:24
---
require "luasql.mysql"
local cjson = require "cjson"
local function getList(sql)
    local list = {}
    --创建环境对象
    env = luasql.mysql()

    --连接数据库
    conn = env:connect("account","root","123456","127.0.0.1",3306)

    --设置数据库的编码格式
    conn:execute"SET NAMES UTF8"

    --执行数据库操作
    cur = conn:execute(sql)

    row = cur:fetch({},"a")

    while row do
        table.insert(list, row)
        row = cur:fetch({},"a")
    end
    conn:close()  --关闭数据库连接
    env:close()   --关闭数据库环境
    return list
end
local sql = 'select * from sp_region limit 20'
local list = getList(sql)
local  val = cjson.encode(list)
print(val)
--文件对象的创建
file = io.open("test.txt","w+");
file:write(val)
file:close()