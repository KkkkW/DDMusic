package com.bestbigkk.music.vo;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.Serializable;

@Component
@Scope(value = "prototype")
public class PageNotice implements Serializable {
    public static final String ERROR = "error";
    public static final String WARNING = "warning";
    public static final String SUCCESS = "success";
    public static final String INFO = "info";

    private String level;
    private String msg;
    private Boolean status = true;

    @Override
    public String toString() {
        return "PageNotice{" +
                "level='" + level + '\'' +
                ", msg='" + msg + '\'' +
                ", status=" + status +
                '}';
    }

    public String getLevel() {
        return level;
    }
    public void setLevel(String level) {
        this.level = level;
    }
    public String getMsg() {
        return msg;
    }
    public void setMsg(String msg) {
        this.msg = msg;
    }
    public Boolean getStatus() {
        boolean flag = status;
        status = false;
        return flag;
    }
    public void setStatus(Boolean status) {
        this.status = status;
    }
}
