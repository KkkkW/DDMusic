package com.bestbigkk.music.domain;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value = "prototype")
public class ModifyUser extends User {
    private String oldPwd;
    private String phoneVerifyCode;

    @Override
    public String toString() {
        return "ModifyUser{" +
                "oldPwd='" + oldPwd + '\'' +
                ", phoneVerifyCode='" + phoneVerifyCode + '\'' +
                "} " + super.toString();
    }

    public String getOldPwd() {
        return oldPwd;
    }

    public void setOldPwd(String oldPwd) {
        this.oldPwd = oldPwd;
    }

    public String getPhoneVerifyCode() {
        return phoneVerifyCode;
    }

    public void setPhoneVerifyCode(String phoneVerifyCode) {
        this.phoneVerifyCode = phoneVerifyCode;
    }
}
