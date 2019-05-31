package com.bestbigkk.music.utils;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class SpringContextUtil implements ApplicationContextAware {
    private static ApplicationContext applicationContext;
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        System.out.println("成功加载Spring容器");
        SpringContextUtil.applicationContext = applicationContext;
    }
    public ApplicationContext getApplicationContext(){
        return applicationContext;
    }
}
