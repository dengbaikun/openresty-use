---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/10/9 14:49
---
local pkey = require("resty.sm4")
local resty_crypto = require "resty.crypto"
local resty_sm4 = require "resty.sm4"
local sm4, err = resty_crypto.new("secret", nil, resty_sm4.cipher("ecb", 128))
if not sm4 then
    error(err)
end
local enc_data, err = sm4:encrypt("abc")
if err then
    error(err)
end
ngx.say(sm4:decrypt(enc_data))

local _M = {}  -- 创建一个模块表
--创建公私钥
local privkey, err = pkey.new(private_key_pem)
local pubkey, err = pkey.new(public_key_pem)
function _M.decrypt(ciphertext)
    -- base64解码
    local decrypted = ngx.decode_base64(ciphertext)
    -- 解密
    local plaintext = privkey:decrypt(decrypted, pkey.PADDINGS.RSA_PKCS1_PADDING)
    return plaintext
end

function _M.encrypt(plaintext)
    -- 加密
    local encrypted = pubkey:encrypt(plaintext, pkey.PADDINGS.RSA_PKCS1_PADDING)
    local ciphertext = ngx.encode_base64(encrypted, true)
    return ciphertext
end

return _M