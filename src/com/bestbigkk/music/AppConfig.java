package com.bestbigkk.music;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class AppConfig implements ApplicationContextAware {
    private String defaultImagePath;
    private static  ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        AppConfig.applicationContext = applicationContext;
    }
    public String getDefaultImagePath() { return defaultImagePath; }
    public void setDefaultImagePath(String defaultImagePath) { this.defaultImagePath = defaultImagePath; }
    public static AppConfig getInstance(){ return applicationContext.getBean("appConfig", AppConfig.class); }
}
