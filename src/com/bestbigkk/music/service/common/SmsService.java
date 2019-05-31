package com.bestbigkk.music.service.common;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/*
* 短信发送服务
* */
@Component
public class SmsService {
    //短信日发送总量阈值，超过该阈值将拒绝发送
    private final Integer SMS_NUMBER_THRESHOLD = 100;
    private Integer count = 0;

    //每天凌晨一点重置
    //@Scheduled(cron = "0 0 1 * ? ?")
    private synchronized void resetThreshold(){
        count = 0;
    }

    /*
    * 为目标手机发送验证码，
    * 方法返回发送验证码内容，当发送失败，将返回null
    * */
    public String sendSMS(String phone){
       return "1314";
    }
}
