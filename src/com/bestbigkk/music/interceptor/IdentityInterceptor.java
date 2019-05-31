package com.bestbigkk.music.interceptor;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.KeyStore;
import com.bestbigkk.music.domain.User;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.PageNotice;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Aspect
@Component
public class IdentityInterceptor {
    private final PageNotice pageNotice;
    private final SpringContextUtil springContextUtil;

    @Autowired
    public IdentityInterceptor(PageNotice pageNotice, SpringContextUtil springContextUtil) {
        this.pageNotice = pageNotice;
        this.springContextUtil = springContextUtil;
    }

    /*
    * 切入所有管理页面，判断用户权限
    * */
    @Around(value = "execution(* com.bestbigkk.music.controller.ManageController.*(..))")
    public Object identityCheck(ProceedingJoinPoint joinPoint) throws Throwable {
        Object[] args = joinPoint.getArgs();
        HttpServletRequest request = (HttpServletRequest) args[0];
        HttpServletResponse response = (HttpServletResponse) args[1];

        pageNotice.setLevel(PageNotice.ERROR);
        pageNotice.setStatus(true);

        Object attribute = request.getSession().getAttribute(KeyStore.currentLoginUser);
        if (attribute == null) {
            pageNotice.setMsg("你还未登录，请先进行登录操作");
            request.getSession().setAttribute("pageInfo", pageNotice);
            response.sendRedirect("/login");
            return null;
        }
        return joinPoint.proceed();
    }

    @ResponseBody
    @Around(value = "execution(* com.bestbigkk.music.service.common.FileStoreService.*Upload(..))")
    public Object identityCheckByJson(ProceedingJoinPoint joinPoint) throws Throwable{
        Object[] args = joinPoint.getArgs();
        HttpServletRequest request = (HttpServletRequest) args[0];
        Object attribute = request.getSession().getAttribute(KeyStore.currentLoginUser);
        if (attribute == null) {
            JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
            jsonObject.put("status", false);
            jsonObject.put("msg", "未找到有效登录用户，请先进行登录操作");
            return jsonObject;
        }
        return joinPoint.proceed();
    }
}
