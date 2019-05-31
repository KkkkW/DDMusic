package com.bestbigkk.music.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;


public class RequestInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws UnsupportedEncodingException {

        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE, PUT");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type,Access-Token");
        // 如果要把Cookie发到服务器，需要指定Access-Control-Allow-Credentials字段为true
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Expose-Headers", "*");

        //缓存
        response.setHeader("Cache-Control", "public"); // 支持HTTP 1.1.

        //跨域Session不一致的问题，设置这个头之后前端在发起请求的时候还需要设置xhrFields:{withCredentials:true},属性
        response.setHeader("Access-Control-Allow-Credentials", "true");//允许跨域携带Cookie

        //响应头
        response.setHeader("copyRight", "music.bestBigKK.com");

        //编码
        request.setCharacterEncoding("UTF8");
        response.setCharacterEncoding("UTF8");
        response.setHeader("Content-type", "text/html;charset=UTF8");

        return true;
    }
}
