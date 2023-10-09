import lombok.extern.slf4j.Slf4j;
import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemWriter;

import javax.crypto.Cipher;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.*;
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
        String pk = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCFjHWH+u1ScOANrI6L7z9MpSJYr0/WzCKLPvAan1F3UzYpMxsoXlT8ba7hhmo9xX5wdjhmRyD9rNcwGT09hyC8eJ7hQsKPkvBx9kUoS4pkpEPU9PCXEBFHCVMD5c7LUlPXNqo+ch/BA/c+OdPOWdwIcK++ZhmlRSg5ocYgXCvNgwIDAQAB";
        String sk = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIWMdYf67VJw4A2sjovvP0ylIlivT9bMIos+8BqfUXdTNikzGyheVPxtruGGaj3FfnB2OGZHIP2s1zAZPT2HILx4nuFCwo+S8HH2RShLimSkQ9T08JcQEUcJUwPlzstSU9c2qj5yH8ED9z45085Z3Ahwr75mGaVFKDmhxiBcK82DAgMBAAECgYAVExNBACIPTmys+7wK7RhKGg0PfarVtKUG4Em3icirUeBMJBp3BlvW8eAVCscdNFs9mApSaYsVPP9AQdteKELL/olohQIjCd+T/Dd/w8J4iTMXIv8pvaf1X3ZdhWaUhglaitIkNGnOCotq1GlFbX4t2QzuB/UQkCu18BfGc2KmMQJBAPPeyhgtKLr28n4EC7drYKBSxNlEcHLdi0t0nPDaU5d/aub7+cmwbBI0mrLxF8nQOr5EE1jWXe7SoNp79Rpajr8CQQCMMPCjwpmv29jJA0csP/rdYpLnMBGA/ZjN3a9KzB8Y5VcRiF67/We/kuFQ0lSR1ozpWpxs4gjHjL6n9X+v5LY9AkEA4u2VsRmUpSXWUF0DahKJP6bFdkexO7HcRMKmp5kB4B+5Imem8H8ykV5R9eFS+YDCqPo/5pLTpcBp3eUrFvLdkQJAD16aM0n1cXtH1Bng5rAI/9Z7xo7VjG/BHejM/AVO73rNReXOhQuuISmoPCUjEm4UOs0tUx6g2cfLazyWCCGp/QJAT+GOl2ojCNupIGWuVXUwyNitXil3BTTyuSi/edSoUCqDW0iYWXC2QppHGznejjn3EpROz8NG+pYWDndJ9xMYXw==";
        String appSecret= "900511_TEST";
        X509EncodedKeySpec pkSpec = new X509EncodedKeySpec(Base64.getDecoder().decode(pk));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey pbk = keyFactory.generatePublic(pkSpec);
        Cipher encrypt = Cipher.getInstance("RSA");
        encrypt.init(Cipher.ENCRYPT_MODE, pbk);
        String encodeToString =Base64.getEncoder().encodeToString(encrypt.doFinal(str.getBytes()));
        String sign = sign(str+appSecret, sk);
        System.out.printf("加密字符串:%s\n", encodeToString);
        System.out.printf("sign:%s\n", sign);


        PKCS8EncodedKeySpec skSpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(sk));
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PrivateKey sbk = kf.generatePrivate(skSpec);
        //RSA解密
        Cipher decrypt = Cipher.getInstance("RSA");
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
