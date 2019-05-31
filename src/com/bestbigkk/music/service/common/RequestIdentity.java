package com.bestbigkk.music.service.common;

import com.bestbigkk.music.KeyStore;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class RequestIdentity {
    public static final String ADMIN = "ADMIN";
    public static final String GUEST = "GUEST";

    public String getRequestIdentity(HttpServletRequest request){
         return request.getSession().getAttribute(KeyStore.currentLoginUser)==null ? GUEST : ADMIN;
    }
}
