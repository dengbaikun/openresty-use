package com.dk.openresty.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
