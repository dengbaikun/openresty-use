import lombok.extern.slf4j.Slf4j;
import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemWriter;

import javax.crypto.Cipher;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

/**
 * @author DK
 * @version V1.0.0
 * @date 2023/10/9 11:20
 */
@Slf4j
public class Main {

    private static String sign(String data, String yckRsaSk) throws Exception {
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(yckRsaSk));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(spec);
        Signature signature = Signature.getInstance("SHA1withRSA");
        signature.initSign(privateKey);
        signature.update(data.getBytes(StandardCharsets.UTF_8));
        byte[] sign = signature.sign();
        return new String(Base64.getEncoder().encode(sign));
    }


    /**
     * 使用公钥进行验签
     *
     * @param original
     * @param signValue
     * @param pk
     * @return
     */
    public static boolean verifyByPK(byte[] original, byte[] signValue, PublicKey pk, String algorithm) {
        try {
            Signature rsa = Signature.getInstance(algorithm);
            rsa.initVerify(pk);
            rsa.update(original);
            return rsa.verify(signValue);
        } catch (Exception e) {
            log.error("验签失败报错" + e.getMessage());
        }
        return false;
    }
    public static void main(String[] args) throws Exception {
//        // 生成RSA算法的KeyPairGenerator对象
//        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
//        // 初始化KeyPairGenerator对象，指定密钥长度
//        keyPairGenerator.initialize(1024);
//        // 生成KeyPair对象，包含公钥和私钥
//        KeyPair keyPair = keyPairGenerator.generateKeyPair();
//        // 获取公钥
//        PublicKey publicKey = keyPair.getPublic();
//        // 获取私钥
//        PrivateKey privateKey = keyPair.getPrivate();
//        //将公钥转换为字符串格式
//        String publicKeyString = Base64.getEncoder().encodeToString(publicKey.getEncoded());
//        System.out.printf("publicKeyString=%s\n",publicKeyString);
//        // 将私钥转换为字符串格式
//        String privateKeyString = Base64.getEncoder().encodeToString(privateKey.getEncoded());
//        System.out.printf("privateKeyString=%s\n",privateKeyString);
        String str = "hello";
        String pk = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCdt6GLFhcOjoXrxr8UiT7VVKOCH2ImUSntXyUoayWbCw5r98QIIICdqOa0TwJbVS0Nr8ohgUj3ozFcFKpF2ZZq+aQ5n4iCWEPnYi/7HogzSfhVnBoI3xAD3greUeYE5pGK+P91/n5l96jhdIik65QsdYhGUFMEcB+cllz63GT8OQIDAQAB";
        String sk = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJ23oYsWFw6OhevGvxSJPtVUo4IfYiZRKe1fJShrJZsLDmv3xAgggJ2o5rRPAltVLQ2vyiGBSPejMVwUqkXZlmr5pDmfiIJYQ+diL/seiDNJ+FWcGgjfEAPeCt5R5gTmkYr4/3X+fmX3qOF0iKTrlCx1iEZQUwRwH5yWXPrcZPw5AgMBAAECgYBM8RzaIbi13UnwMFFfz2Tb5iKuhGj5kHcH2nbiNQNvlAFBIup7nH+iapfCNxlLPU5xcuUFW3EhfnfCGELJONFsL4TXSzysz3UOYUGXu16/2oLHWJzAqMSN/6IgV0ARFExsigpsId49wxpewv2DmXSjYI3HzuOB7Fhq+/1I+3gIEQJBAPCnGjkyngmLES1zXMp7Uw7BhapOmKLv/cga7LmIhQEM1kq7efp0DKa74/T+4Y420V6G7ZvdwTMEMwignTM9EWMCQQCnxoY9uWcLevGisHCd2uLpXIbD7gS8lGxp6ew0FQywVv69509ZskZYQlR5tPK+Di0GJjU2ZrcmOGcuKXpBeRyzAkA5WmnaheC6P4V5govzyc5yrtZvT0n7Uxz1is0uLoYcSPXtW57nfK7jMdZTNkeFQDVHxPpt8jywLukGvliYtI4nAkA2XplmK0z/ZWok5LS6ExLxuPBbUijqy9aORCYtgpzIEIkhFXKbiLBPLb+eaUs41/MzSPJ5nLPBiQm25e4ehZcNAkAXlFk+XP/eH3UJhSXJvLXrlfHblIxHd+D48+Z0pSYsZ4zPJ8349em4y/BqrbnhAOX4nJC8DrG4TYPXC5FcFW/8";
        String appSecret= "900511_TEST";
        X509EncodedKeySpec pkSpec = new X509EncodedKeySpec(Base64.getDecoder().decode(pk));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey pbk = keyFactory.generatePublic(pkSpec);
        Cipher encrypt = Cipher.getInstance("RSA/ECB/OAEPPadding");
        encrypt.init(Cipher.ENCRYPT_MODE, pbk);
        String encodeToString ="L7jUK4lj4en0UFhl+0zAQjoviraZroIjfPrfkA90ppFbF/X/4p22kWbvIiXyr2Ywq/R09NYzSeBsqLVCUx1mjQUzG4NfzAR3lfr6nkx5VWXnn23KKXUS6jq5a/SFpyQllu5zLis3brtbMhef2XKQMnKUmSgfLWMNEI7x5I+umH8=";
        String sign = sign(str+appSecret, sk);
        System.out.printf("加密字符串:%s\n", encodeToString);
        System.out.printf("sign:%s\n", sign);


        PKCS8EncodedKeySpec skSpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(sk));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PrivateKey sbk = kf.generatePrivate(skSpec);
        //RSA解密
        Cipher decrypt = Cipher.getInstance("RSA/ECB/OAEPPadding");
        decrypt.init(Cipher.DECRYPT_MODE, sbk);
        byte[] bytes = decrypt.doFinal(Base64.getDecoder().decode(encodeToString));
        System.out.printf("解密字符串:%s\n", new String(bytes));
        boolean verify = verifyByPK((new String(bytes)+appSecret).getBytes(), Base64.getDecoder().decode(sign), pbk, "SHA1withRSA");
        System.out.printf("验签结果:%s\n",verify);
        String publicKeyPrefix = "PUBLIC KEY";
        String privateKeyPrefix = "PRIVATE KEY";
        try(FileWriter priFileWriter = new FileWriter("e:/rsa/rsaPrivateKey.pem");
            PemWriter priPemWriter = new PemWriter(priFileWriter);
            FileWriter pubFileWriter = new FileWriter("e:/rsa/rsaPublicKey.pem");
            PemWriter pubPemWriter = new PemWriter(pubFileWriter)) {
            priPemWriter.writeObject(new PemObject(privateKeyPrefix, sbk.getEncoded()));
            pubPemWriter.writeObject(new PemObject(publicKeyPrefix, pbk.getEncoded()));
        }
//        String responseJson = "{\n" +
//                "    \"randomKey\": \"zuyRAEHqfjKPnznhBH9de3rwLBljUpaG9VCLKpJrKoUFoFkw5URypsbdRToQoCEu9XzwBVxdtZ4/Ajh/c2uDTH2VwKfp4hXPVLMztHohuIUPxVMgJB6ZC3/mfyhPoQuItXaZVxHAhyGg7ZGiL3522mIoPuMzf5iyZnVHJpXpLP4=\",\n" +
//                "    \"serialNumber\": \"7207643f5f724c059e15cff9a5c8c905\",\n" +
//                "    \"code\": \"000\",\n" +
//                "    \"data\": \"EETQWMal4WpxsGQBY/mTlnsiuNpwX5e4BD4XvW6ohqxWCvHYQaj+Ut7T7ZnaoJJo2/y4MMppFRNFG+fpC1y2Og==\",\n" +
//                "    \"sign\": \"IVY2tFd8UCHmAf70HfC7+rxG4jtbphWO84ECBZsfx8mc9jS1MpHtoy4GmST7sH2THZ3u6TWzu1ixRTpfI+r/9NyMWaTUnMFhrRyKpF+7TODQm2nHiXWA1XN3uLg1Koc3SGvQFaGfcK/Cwdtc1eYQYLUACzJVCAXyagwwVHeIxAI=\",\n" +
//                "    \"message\": \"交易成功\"\n" +
//                "}";
//        JSONObject jsonObject = JSONObject.parseObject(responseJson);
//        String sign = jsonObject.getString("sign");
//        String data = jsonObject.getString("data");
//        String randomKey = jsonObject.getString("randomKey");
//        PKCS8EncodedKeySpec skSpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(sk));
//        KeyFactory kf = KeyFactory.getInstance("RSA");
//        PrivateKey sbk = kf.generatePrivate(skSpec);
//        Cipher decrypt = Cipher.getInstance("RSA");
//        decrypt.init(Cipher.DECRYPT_MODE, sbk);
//        byte[] sm4Key = decrypt.doFinal(Base64.getDecoder().decode(randomKey));
//        data = sm4Decrypt(data, sm4Key);
//        System.out.printf("data解密后数据:%s\n", data);
//        String nsyPK = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/FPJFAOwB91FBx3qqtmua5+GlG9DiuXFjhF9FPwaV4cb4FHKP0hmQyNrzjWhWxX3NMkCcxGkxkUdriScbZL00ebEi0IffRJvinD3KG9GegX8DYzO1p1pLUYch3mS8c8GkqAVvcEL1it1muTd8hbTRipOZKGRAoI0bddIEZ0uNuwIDAQAB";
//        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
//        X509EncodedKeySpec pkSpec = new X509EncodedKeySpec(Base64.getDecoder().decode(nsyPK));
//        PublicKey pbk = keyFactory.generatePublic(pkSpec);
//        String appSecret = "900511_TEST";
//        data = data + appSecret;
//        boolean verify = verifyByPK(data.getBytes(StandardCharsets.UTF_8), Base64.getDecoder().decode(sign), pbk, "SHA1withRSA");
//        System.out.printf("验签结果:%s\n", verify);
    }
}
