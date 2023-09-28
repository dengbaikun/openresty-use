---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/9/28 16:37
---
-- 连接redis
local redis = require('resty.redis')
local _M = {}  -- 创建一个模块表
-- 定义连接池的配置
local redis_config = {
    host = "127.0.0.1",   -- Redis 服务器地址
    port = 6379,          -- Redis 服务器端口
    timeout = 1000,       -- 连接超时时间（毫秒）
    max_idle_timeout = 60000, -- 连接在连接池中的最大空闲时间（毫秒）
    pool_size = 100,       -- 连接池大小
    password = "123456"
}
-- 创建数据库连接池
function _M.new()
    local db, err = redis.new()
    if not db then
        ngx.log(ngx.ERR, "failed to create mysql object: ", err)
        return nil, err
    end

    db:set_timeout(redis_config.timeout)  -- 设置超时时间（以毫秒为单位）

    local ok, err = db:connect(redis_config.host, -- 数据库主机
            redis_config.port -- 数据库端口
    )

    if not ok then
        ngx.log(ngx.ERR, "failed to connect to database: ", err, ": ", errno, " ", sqlstate)
        return nil, err
    end
    db:auth(redis_config.password)
    return db, nil  -- 返回数据库连接对象
end


-- 释放连接
function _M.close(db)
    if not db then
        return
    end

    --释放连接(连接池实现)
    local ok, err = db:set_keepalive(redis_config.max_idle_timeout, redis_config.pool_size)
    if not ok then
        ngx.log(ngx.ERR, "set redis keepalive error : ", err)
    end
end

return _M  -- 返回模块表