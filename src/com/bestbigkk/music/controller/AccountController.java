package com.bestbigkk.music.controller;

import com.alibaba.fastjson.JSON;
import com.bestbigkk.music.AppConfig;
import com.bestbigkk.music.domain.LoginUser;
import com.bestbigkk.music.domain.ModifyUser;
import com.bestbigkk.music.service.AccountService;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.PageNotice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping(value = "/account")
public class AccountController {

    private final AccountService accountService;
    private final SpringContextUtil springContextUtil;

    @Autowired
    public AccountController(AccountService accountService, SpringContextUtil springContextUtil) {
        this.accountService = accountService;
        this.springContextUtil = springContextUtil;
    }

    @ResponseBody
    @RequestMapping(value = "/verifyImage", method = RequestMethod.GET)
    public void imageVerify(HttpServletRequest request, HttpServletResponse response){
        accountService.createImageVerify(request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/phoneVerifyCode", method = RequestMethod.GET)
    public JSON getPhoneVerifyCode(HttpServletRequest request, HttpServletResponse response){
        return accountService.getPhoneVerifyCode(request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public JSON login(LoginUser user, HttpServletRequest request, HttpServletResponse response){
        return accountService.login(user, request, response);
    }

    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    public String modifyAccount(ModifyUser modifyUser, HttpServletRequest request, HttpServletResponse response){
        PageNotice pageNotice = springContextUtil.getApplicationContext().getBean("pageNotice", PageNotice.class);
        HttpSession session = request.getSession();
        pageNotice.setStatus(true);

        String result =  accountService.modifyAccountInfo(modifyUser, request, response);
        if (result == null) {
            pageNotice.setLevel(PageNotice.SUCCESS);
            pageNotice.setMsg("修改账户密码成功，下次登录时需要使用新密码");
            session.setAttribute("pageNotice", pageNotice);
            return "redirect:/manage/account";
        }

        pageNotice.setMsg(result);
        pageNotice.setLevel(PageNotice.ERROR);
        session.setAttribute("pageNotice", pageNotice);
        return "redirect:/manage/account";
    }

    @RequestMapping(value="/logout", method = RequestMethod.GET)
    public String logOut(HttpServletRequest request, HttpServletResponse response){
        accountService.logout(request, response);
        return "redirect:/";
    }
}
