package com.dk.openresty.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * @author DK
 * @version V1.0.0
 * @date 2023/10/8 16:56
 */
@RestController
@Slf4j
public class TestController {

    @RequestMapping(value = "/{appId}/{tradeCode}/{productCode}/{version}/{piping}", method = RequestMethod.POST)
    Object talentCardAuthorizationResultReview(
            @PathVariable("appId") String appId,
            @PathVariable("tradeCode") String tradeCode,
            @PathVariable("productCode") String productCode,
            @PathVariable("version") String version,
            @PathVariable("piping") String piping,
            HttpServletRequest request) throws IOException {
        int len = request.getContentLength();
        ServletInputStream inputStream = request.getInputStream();
        byte[] buffer = new byte[len];
        inputStream.read(buffer, 0, len);
        String requestBody = new String(buffer, StandardCharsets.UTF_8);
        log.info("requestBody=[{}]", requestBody);
        log.info("appId=[{}],tradeCode=[{}],productCode=[{}],version=[{}],piping=[{}]", appId,tradeCode,productCode,version,piping);
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            log.info("headerName={},value={}", headerName, request.getHeader(headerName));
        }

        Map<String, Object> map = new HashMap<>();
        map.put("code", 200);
        map.put("msg", "SUCCESS");
        map.put("data", requestBody);
        return map;
    }
    @RequestMapping("/test")
    public Object index(@RequestBody String body) {
        log.info("body=[{}]", body);
        Map<String, Object> map = new HashMap<>();
        map.put("code", 200);
        map.put("msg", "SUCCESS");
        map.put("data", body);
        return map;
    }

}
