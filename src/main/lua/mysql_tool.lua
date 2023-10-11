local mysql_c = require "resty.mysql"

local _M = { }
_M._VERSION = '0.01'

local mt = { __index = _M }


-- change connect address as you need
function _M.connect_mod(self, mysql)
    mysql:set_timeout(self.timeout)
    return mysql:connect({
        host = self.host, -- 数据库主机
        port = self.port, -- 数据库端口
        database = self.database, -- 数据库名
        user = self.user, -- 数据库用户名
        password = self.password, -- 数据库密码
        charset = self.charset, --使用的字符集
        max_packet_size = self.max_packet_size
    })
end

function _M.set_keepalive_mod(self, mysql)
    -- put it into the connection pool of size 100, with 60 seconds max idle time
    return mysql:set_keepalive(self.max_idle_timeout, self.pool_size)
end

function _M.query(self, sql, ...)
    local mysql, err = mysql_c:new()
    if not mysql then
        ngx.log(ngx.ERR, "failed to create mysql object: ", err)
        return nil, err
    end
    local ok, err, errno, sqlstate = self:connect_mod(mysql)
    if not ok or err then
        ngx.log(ngx.ERR, "failed to connect to database: ", err, ": ", errno, " ", sqlstate)
        return nil, err
    end
    local res, err, errno, sqlstate = mysql:query(sql, ...)
    if self._reqs then
        table.insert(self._reqs, { cmd, ... })
        return
    end
    if not res then
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
        return nil, err
    end
    self:set_keepalive_mod(mysql)
    return res, nil  -- 返回查询结果
end

function _M.new(self, opts)
    opts = opts or {}
    opts = opts or {}
    local host = opts.host or "192.168.3.191" -- mysql 服务器地址
    local port = opts.port or 3307 -- mysql 服务器端口
    local timeout = (opts.timeout and opts.timeout * 1000) or 1000
    local max_idle_timeout = (opts.max_idle_timeout and opts.max_idle_timeout * 1000) or 60000 -- 连接在连接池中的最大空闲时间（毫秒）
    local pool_size = opts.pool_size or 100 -- 连接池大小
    local user = opts.user or "root" -- 连接池大小
    local password = opts.password or 'rck123##2020fstest'
    local database = opts.database or 'talentcard-apicomponent'
    local charset = opts.charset or 'utf8mb4'
    local max_packet_size = 1024 * 1024 * 4

    return setmetatable({
        host = host, -- mysql 服务器地址
        port = port, -- mysql 服务器端口
        timeout = timeout, -- 连接超时时间（毫秒）
        max_idle_timeout = max_idle_timeout, -- 连接在连接池中的最大空闲时间（毫秒）
        pool_size = pool_size, -- 连接池大小
        password = password,
        user = user,
        database = database,
        charset = charset,
        max_packet_size = max_packet_size, }, mt)
end

return _M