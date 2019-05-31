package com.bestbigkk.music.domain;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value = "prototype")
public class LoginUser extends User{
    private String verifyCode;
    private Integer loginModel;
    private Boolean remember;

    @Override
    public String toString() {
        return "LoginUser{" +
                "verifyCode='" + verifyCode + '\'' +
                ", loginModel=" + loginModel +
                ", remember=" + remember +
                "} " + super.toString();
    }

    public String getVerifyCode() {
        return verifyCode;
    }

    public void setVerifyCode(String verifyCode) {
        this.verifyCode = verifyCode;
    }

    public Integer getLoginModel() {
        return loginModel;
    }

    public void setLoginModel(Integer loginModel) {
        this.loginModel = loginModel;
    }

    public Boolean getRemember() {
        return remember;
    }

    public void setRemember(Boolean remember) {
        this.remember = remember;
    }
}
