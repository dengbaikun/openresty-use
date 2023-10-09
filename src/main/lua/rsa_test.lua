-- 使用lua-resty-openssl-0.8.25.zip 库操作
-- 读取 RSA 公钥文件
local public_key_path = "e:/rsa/rsaPublicKey.pem"
local public_key_file, err = io.open(public_key_path, "r")
if not public_key_file then
    ngx.log(ngx.ERR, "Failed to open public key file: ", err)
    ngx.exit(500)
end

local public_key_pem = public_key_file:read("*a")
public_key_file:close()

-- 读取 RSA 私钥文件
local private_key_path = "e:/rsa/rsaPrivateKey.pem"
local private_key_file, err = io.open(private_key_path, "r")
if not private_key_file then
    ngx.log(ngx.ERR, "Failed to open private key file: ", err)
    ngx.exit(500)
end

local private_key_pem = private_key_file:read("*a")
private_key_file:close()

local pkey = require("resty.openssl.pkey")
-- 要加密的数据
local data_to_encrypt = "Hello, OpenResty!"
local privkey, err = pkey.new(private_key_pem)
local pubkey, err = pkey.new(public_key_pem)
-- 执行加密操作
local encrypted_data = pubkey:encrypt(data_to_encrypt, pkey.PADDINGS.RSA_PKCS1_PADDING)
--encrypted_data = ngx.decode_base64(encrypted_data)
-- 执行解密操作
local decrypted_data = privkey:decrypt(encrypted_data, pkey.PADDINGS.RSA_PKCS1_PADDING)
-- 执行签名操作
local signature, err = privkey:sign(data_to_encrypt,'SHA1',pkey.PADDINGS.RSA_PKCS1_PADDING)
-- 执行验签操作
local ok, err = pubkey:verify(signature, data_to_encrypt, "SHA1", pkey.PADDINGS.RSA_PKCS1_PADDING)
ngx.say("Original data: " .. data_to_encrypt)
ngx.say("Encrypted data: " .. ngx.encode_base64(encrypted_data))
ngx.say("Decrypted data: " .. decrypted_data)
ngx.say("Sign data: " .. ngx.encode_base64(signature))
ngx.say("Verify data: " .. tostring(ok))


--local pkey = require("resty.openssl.pkey")
--local privkey, err = pkey.new()
--local pub_pem = privkey:to_PEM("public")
--local pubkey, err = pkey.new(pub_pem)
--local s, err = pubkey:encrypt("🦢", pkey.PADDINGS.RSA_PKCS1_PADDING)
--ngx.say(#s)
---- outputs 256
--local decrypted, err = privkey:decrypt(s)
--ngx.say(decrypted)
---- outputs "🦢"