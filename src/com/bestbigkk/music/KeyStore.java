package com.bestbigkk.music;

import org.springframework.stereotype.Component;

import java.io.Serializable;

@Component
public final class KeyStore implements Serializable {
    public static final  String imageVerifyCode = "图形验证码结果";
    public static final String lastRequestTime= "上次请求发送短信验证码时间";
    public static final String phoneCode = "发送到手机的验证码";
    public static final String currentLoginUser = "当前登录用户";

    public static final String MSG = "msg"; // JSON模式下响应的信息
    public static final String STATUS = "status"; //JSON模式下，响应状态
}
