package com.bestbigkk.music.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class ApplicationListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (
            InputStream stream = this.getClass().getResourceAsStream("/app-config.properties");
        ) {
            Properties properties = new Properties();
            properties.load(stream);
            Set<Map.Entry<Object, Object>> entrySet = properties.entrySet();
            for (Map.Entry<Object, Object> entry : entrySet) {
                sce.getServletContext().setAttribute(entry.getKey()+"", entry.getValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("销毁");
    }
}
