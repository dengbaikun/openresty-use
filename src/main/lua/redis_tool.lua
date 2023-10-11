local redis_c = require "resty.redis"

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function(narr, nrec)
        return {}
    end
end

local _M = new_tab(0, 155)
_M._VERSION = '0.01'

local commands = {
    "append", "auth", "bgrewriteaof",
    "bgsave", "bitcount", "bitop",
    "blpop", "brpop",
    "brpoplpush", "client", "config",
    "dbsize",
    "debug", "decr", "decrby",
    "del", "discard", "dump",
    "echo",
    "eval", "exec", "exists",
    "expire", "expireat", "flushall",
    "flushdb", "get", "getbit",
    "getrange", "getset", "hdel",
    "hexists", "hget", "hgetall",
    "hincrby", "hincrbyfloat", "hkeys",
    "hlen",
    "hmget", "hmset", "hscan",
    "hset",
    "hsetnx", "hvals", "incr",
    "incrby", "incrbyfloat", "info",
    "keys",
    "lastsave", "lindex", "linsert",
    "llen", "lpop", "lpush",
    "lpushx", "lrange", "lrem",
    "lset", "ltrim", "mget",
    "migrate",
    "monitor", "move", "mset",
    "msetnx", "multi", "object",
    "persist", "pexpire", "pexpireat",
    "ping", "psetex", "psubscribe",
    "pttl",
    "publish", --[[ "punsubscribe", ]]   "pubsub",
    "quit",
    "randomkey", "rename", "renamenx",
    "restore",
    "rpop", "rpoplpush", "rpush",
    "rpushx", "sadd", "save",
    "scan", "scard", "script",
    "sdiff", "sdiffstore",
    "select", "set", "setbit",
    "setex", "setnx", "setrange",
    "shutdown", "sinter", "sinterstore",
    "sismember", "slaveof", "slowlog",
    "smembers", "smove", "sort",
    "spop", "srandmember", "srem",
    "sscan",
    "strlen", --[[ "subscribe",  ]]     "sunion",
    "sunionstore", "sync", "time",
    "ttl",
    "type", --[[ "unsubscribe", ]]    "unwatch",
    "watch", "zadd", "zcard",
    "zcount", "zincrby", "zinterstore",
    "zrange", "zrangebyscore", "zrank",
    "zrem", "zremrangebyrank", "zremrangebyscore",
    "zrevrange", "zrevrangebyscore", "zrevrank",
    "zscan",
    "zscore", "zunionstore", "evalsha"
}

local mt = { __index = _M }

local function is_redis_null(res)
    if type(res) == "table" then
        for k, v in pairs(res) do
            if v ~= ngx.null then
                return false
            end
        end
        return true
    elseif res == ngx.null then
        return true
    elseif res == nil then
        return true
    end

    return false
end


-- change connect address as you need
function _M.connect_mod(self, redis)
    redis:set_timeout(self.timeout)
    redis:connect(self.host, self.port)
    local count, err = redis:get_reused_times()                             -- 获取复用次数
    if count < 1 then
        local ok, err = redis:auth(self.password)
        if not ok then
            ngx.log(ngx.ERR, "Redis auth fail: ", err)
            return nil, err
        end
    end
    redis:select(self.db_index)
    return redis
end

function _M.set_keepalive_mod(self,redis)
    -- put it into the connection pool of size 100, with 60 seconds max idle time
    return redis:set_keepalive(self.max_idle_timeout, self.pool_size)
end

function _M.init_pipeline(self)
    self._reqs = {}
end

function _M.commit_pipeline(self)
    local reqs = self._reqs

    if nil == reqs or 0 == #reqs then
        return {}, "no pipeline"
    else
        self._reqs = nil
    end

    local redis, err = redis_c:new()
    if not redis then
        return nil, err
    end

    local ok, err = self:connect_mod(redis)
    if not ok then
        return {}, err
    end

    redis:init_pipeline()
    for _, vals in ipairs(reqs) do
        local fun = redis[vals[1]]
        table.remove(vals, 1)

        fun(redis, unpack(vals))
    end

    local results, err = redis:commit_pipeline()
    if not results or err then
        return {}, err
    end

    if is_redis_null(results) then
        results = {}
        ngx.log(ngx.WARN, "is null")
    end
    -- table.remove (results , 1)

    self:set_keepalive_mod(redis)

    for i, value in ipairs(results) do
        if is_redis_null(value) then
            results[i] = nil
        end
    end

    return results, err
end

function _M.subscribe(self, channel)
    local redis, err = redis_c:new()
    if not redis then
        return nil, err
    end

    local ok, err = self:connect_mod(redis)
    if not ok or err then
        return nil, err
    end

    local res, err = redis:subscribe(channel)
    if not res then
        return nil, err
    end

    res, err = redis:read_reply()
    if not res then
        return nil, err
    end

    redis:unsubscribe(channel)
    self:set_keepalive_mod(redis)

    return res, err
end

local function do_command(self, cmd, ...)
    if self._reqs then
        table.insert(self._reqs, { cmd, ... })
        return
    end

    local redis, err = redis_c:new()
    if not redis then
        ngx.log(ngx.ERR, "failed to create redis object: ", err)
        return nil, err
    end

    local ok, err = self:connect_mod(redis)
    if not ok or err then
        ngx.log(ngx.ERR, "failed to connect to redis: ", err)
        return nil, err
    end

    local fun = redis[cmd]
    local result, err = fun(redis, ...)
    if not result or err then
        -- ngx.log(ngx.ERR, "pipeline result:", result, " err:", err)
        return nil, err
    end

    if is_redis_null(result) then
        result = nil
    end

    self:set_keepalive_mod(redis)

    return result, err
end

function _M.new(self, opts)
    opts = opts or {}
    local host = opts.host or  "127.0.0.1" -- Redis 服务器地址
    local port = opts.port or  6379 -- Redis 服务器端口
    local timeout = (opts.timeout and opts.timeout * 1000) or 1000
    local max_idle_timeout = (opts.max_idle_timeout and opts.max_idle_timeout * 1000) or 60000 -- 连接在连接池中的最大空闲时间（毫秒）
    local pool_size = opts.pool_size or 1000 -- 连接池大小
    local password = opts.password or '123456'
    local db_index = opts.db_index or 0

    for i = 1, #commands do
        local cmd = commands[i]
        _M[cmd] = function(self, ...)
            return do_command(self, cmd, ...)
        end
    end

    return setmetatable({
        host = host, -- Redis 服务器地址
        port = port, -- Redis 服务器端口
        timeout = timeout, -- 连接超时时间（毫秒）
        max_idle_timeout = max_idle_timeout, -- 连接在连接池中的最大空闲时间（毫秒）
        pool_size = pool_size, -- 连接池大小
        password = password,
        db_index = db_index,
        _reqs = nil }, mt)
end

return _M