--
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
--
---- 创建 RSA 公钥和私钥对象
--local rsa_public_key, err = rsa.new(public_key_pem)
--if not rsa_public_key then
--    ngx.log(ngx.ERR, "Failed to create RSA public key: ", err)
--    ngx.exit(500)
--end
--
--local rsa_private_key, err = rsa.new(private_key_pem)
--if not rsa_private_key then
--    ngx.log(ngx.ERR, "Failed to create RSA private key: ", err)
--    ngx.exit(500)
--end
--
---- 要加密的数据
--local data_to_encrypt = "Hello, OpenResty!"
--
---- 执行加密操作
--local encrypted_data, err = rsa_public_key:encrypt(data_to_encrypt)
--if not encrypted_data then
--    ngx.log(ngx.ERR, "Failed to encrypt data: ", err)
--    ngx.exit(500)
--end
--
---- 执行解密操作
--local decrypted_data, err = rsa_private_key:decrypt(encrypted_data)
--if not decrypted_data then
--    ngx.log(ngx.ERR, "Failed to decrypt data: ", err)
--    ngx.exit(500)
--end
--
---- 输出加密后和解密后的数据
--ngx.say("Original data: " .. data_to_encrypt)
--ngx.say("Encrypted data: " .. ngx.encode_base64(encrypted_data))
--ngx.say("Decrypted data: " .. decrypted_data)

local pkey = require("resty.openssl.pkey")
local data_to_encrypt = "Hello, OpenResty!"
local privkey, err = pkey.new(private_key_pem)
-- 要加密的数据
--local pub_pem = privkey:to_PEM("public")
local pubkey, err = pkey.new(public_key_pem)
--local encrypted_data = pubkey:encrypt(data_to_encrypt, pkey.PADDINGS.RSA_PKCS1_PADDING)
local encrypted_data = "ebJ7IQSs3LMoOAHICmbswAMynEUjm6GzT9p7dDfuFsfBnpXFR2a0CGP0IFDfC0Gpnc9PBPSJlHZcsOk6oNRRJbjc3d3tc+jyZ2ZVQ8ZwvDPk7VLasqx4+vWeX57RtOMG6NFzX7/ulb10drf0qxQuoanXoJLSS/wVTlW7S/k+8fU="
encrypted_data = ngx.decode_base64(encrypted_data)
-- 执行加密操作
local decrypted_data = privkey:decrypt(encrypted_data, pkey.PADDINGS.RSA_PKCS1_PADDING)
ngx.say("Original data: " .. data_to_encrypt)
ngx.say("Encrypted data: " .. ngx.encode_base64(encrypted_data))
ngx.say("Decrypted data: " .. decrypted_data)



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