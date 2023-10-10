local resty_crypto = require "resty.crypto"
local resty_sm4 = require "resty.sm4"
local str = require "resty.string"
local sm4, err = resty_crypto.new("secret", nil, resty_sm4.cipher("ecb", 128))
if not sm4 then
    error(err)
end
local enc_data, err = sm4:encrypt("abc")
if err then
    error(err)
end
ngx.say(str.to_hex(enc_data))
ngx.say(sm4:decrypt(enc_data))