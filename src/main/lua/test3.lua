---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/10/11 14:35
---
opts = opts or {}
local host = opts.host or "192.168.3.253" -- Redis 服务器地址
local port = opts.port or 6379 -- Redis 服务器端口
local timeout = (opts.timeout and opts.timeout * 1000) or 1000
local max_idle_timeout = (opts.max_idle_timeout and opts.max_idle_timeout * 1000) or 60000 -- 连接在连接池中的最大空闲时间（毫秒）
local pool_size = opts.pool_size or 1000 -- 连接池大小
local password = opts.password or '95279527'
local db_index = opts.db_index or 0
local config = {
    host = host, -- Redis 服务器地址
    port = port, -- Redis 服务器端口
    timeout = timeout, -- 连接超时时间（毫秒）
    max_idle_timeout = max_idle_timeout, -- 连接在连接池中的最大空闲时间（毫秒）
    pool_size = pool_size, -- 连接池大小
    password = password,
    db_index = db_index,
    _reqs = nil }

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function(narr, nrec)
        return {}
    end
end

local m = new_tab(0, 155)
m._VERSION = '0.01'
m.version = 1.1
for key, val in pairs(config) do
    m[key] = val
end
for key, val in pairs(m) do
    print('key:', key, ',val:', val)
end