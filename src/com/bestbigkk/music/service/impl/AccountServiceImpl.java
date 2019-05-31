package com.bestbigkk.music.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.KeyStore;
import com.bestbigkk.music.dao.UserMapper;
import com.bestbigkk.music.domain.LoginUser;
import com.bestbigkk.music.domain.ModifyUser;
import com.bestbigkk.music.domain.User;
import com.bestbigkk.music.po.UserExample;
import com.bestbigkk.music.service.AccountService;
import com.bestbigkk.music.service.common.SmsService;
import com.bestbigkk.music.service.common.VerifyImage;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.AccountPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.Key;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

@Service
public class AccountServiceImpl implements AccountService {
    private final Integer SMS_TIME_THRESHOLD = 60000;

    private final VerifyImage verifyImage;
    private final JSONObject jsonObject;
    private final SmsService smsService;
    private final UserMapper userMapper;
    private final SpringContextUtil springContextUtil;

    @Autowired
    public AccountServiceImpl(VerifyImage verifyImage, JSONObject jsonObject, SmsService smsService, UserMapper userMapper, SpringContextUtil springContextUtil) {
        this.verifyImage = verifyImage;
        this.jsonObject = jsonObject;
        this.smsService = smsService;
        this.userMapper = userMapper;
        this.springContextUtil = springContextUtil;
    }


    @Override
    public void createImageVerify(HttpServletRequest request, HttpServletResponse response){
        verifyImage.createVerifyImage(request, response);
    }
    @Override
    public JSONObject getPhoneVerifyCode(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String imageCodeResult = (String) session.getAttribute(KeyStore.imageVerifyCode);
        Date lastRequestTime = (Date) session.getAttribute(KeyStore.lastRequestTime);
        jsonObject.put("status", false);
        if(lastRequestTime!=null && lastRequestTime.getTime()+SMS_TIME_THRESHOLD>new Date().getTime()){
            jsonObject.put("msg", "请求过于频繁，请"+(SMS_TIME_THRESHOLD/1000-(new Date().getTime()-lastRequestTime.getTime())/1000)+"秒之后再试");
            return jsonObject;
        }
        session.setAttribute(KeyStore.lastRequestTime, new Date());
        if(imageCodeResult==null){
            jsonObject.put("msg", "请先发送验证码!");
            return jsonObject;
        }
        String phoneNumber = request.getParameter("phoneNumber");
        String imageCode = request.getParameter("imageCode");

        if(phoneNumber==null || !Pattern.matches("^1[3|4|5|8][0-9]\\d{4,8}$", phoneNumber) || imageCode==null || imageCode.length()!=5){
            jsonObject.put("msg", "手机号码或图形验证码不符合要求");
            return jsonObject;
        }

        if (!imageCodeResult.equalsIgnoreCase(imageCode)) {
            jsonObject.put("msg", "验证码错误，请重试");
            session.removeAttribute(KeyStore.imageVerifyCode);
            return jsonObject;
        }

        String smsCode = smsService.sendSMS(phoneNumber);
        if (smsCode == null) {
            jsonObject.put("msg", "验证码发送失败，请稍后重试");
            return jsonObject;
        }

        jsonObject.put("status", true);
        jsonObject.put("msg", "发送短信验证码到手机："+phoneNumber+"成功，请查验并进行后续流程");
        session.setAttribute(KeyStore.phoneCode, smsCode+"#"+phoneNumber);
        session.removeAttribute(KeyStore.imageVerifyCode);

        return jsonObject;
    }

    @Override
    public JSONObject login(LoginUser user, HttpServletRequest request, HttpServletResponse response) {
        jsonObject.put("status", false);
        jsonObject.put("url", "/manage/album-list");
        if(user==null){
            jsonObject.put("msg", "登录信息不完成，拒绝登录");
            return jsonObject;
        }
        Integer model = user.getLoginModel();
        if (model == null || (model != 1 && model != 2)) {
            jsonObject.put("msg", "未指定登录方式。如您不明白上述含义，请尝试刷新页面并重试");
            return jsonObject;
        }
        HttpSession session = request.getSession();
        String account = user.getAccount();
        String pwd = user.getPassword();
        String code = user.getVerifyCode();

        //账户密码登录
        if (model == 1) {
            String result = (String) session.getAttribute(KeyStore.imageVerifyCode);
            //登录失败
            if (account == null || pwd == null) {
                jsonObject.put("msg", "账户或密码错误，请重试");
                return jsonObject;
            }

            if(!result.equalsIgnoreCase(code)){
                jsonObject.put("msg", "图形验证码错误");
                return jsonObject;
            }

            User u = this.login(account, pwd);
            if(u==null){
                jsonObject.put("msg", "账户或者密码不匹配");
                return jsonObject;
            }
            //登录成功
            jsonObject.put("msg", "登录成功");
            jsonObject.put("status", true);
            session.setAttribute(KeyStore.currentLoginUser, u);
            return jsonObject;
        }

        String codeAndPhone = (String) session.getAttribute(KeyStore.phoneCode);
        if (codeAndPhone == null) {
            jsonObject.put("msg", "请先发送验证码到手机");
            return jsonObject;
        }
        String realCode = codeAndPhone.split("#")[0];
        String phone = codeAndPhone.split("#")[1];

        if(!phone.equals(account)){
            jsonObject.put("msg", "您提交的账户与之前发送的手机号码不一致");
            return jsonObject;
        }
        if(!code.equalsIgnoreCase(realCode)){
            jsonObject.put("msg", "验证码错误");
            return jsonObject;
        }

        User u = this.login(account, null);
        if(u==null){
            jsonObject.put("msg", "未找到相关用户，请确认该账户已注册");
            return jsonObject;
        }

        session.setAttribute(KeyStore.currentLoginUser, u);
        jsonObject.put("status", true);
        jsonObject.put("msg", "登录成功");
        return jsonObject;
    }

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response){
        request.getSession().invalidate();
    }

    @Override
    public String modifyAccountInfo(ModifyUser modifyUser, HttpServletRequest request, HttpServletResponse response){
        if(modifyUser==null || modifyUser.getAccount()==null || modifyUser.getOldPwd()==null || modifyUser.getPhoneVerifyCode()==null){
            return "提交信息有误，无法修改";
        }

        HttpSession session = request.getSession();
        String phoneAndCode = (String) session.getAttribute(KeyStore.phoneCode);
        User loginUser = (User) session.getAttribute(KeyStore.currentLoginUser);

        if (phoneAndCode == null) {
            return "请先发送手机验证码";
        }

        String phoneCode = phoneAndCode.split("#")[0];

        if (!loginUser.getAccount().equals(modifyUser.getAccount())) {
            return "您无权修改该账户";
        }

        if(!loginUser.getPassword().equals(modifyUser.getOldPwd())){
            return "旧密码输入错误";
        }

        if(!Pattern.matches("^\\w{6,12}$", modifyUser.getPassword())){
            return "新密码格式错误：6-12字符长度，数字或字母组成";
        }

        if(!modifyUser.getPhoneVerifyCode().equals(phoneCode)){
            return "你提交的手机验证码错误，请稍后重试";
        }
        session.removeAttribute(KeyStore.phoneCode);

        User user = springContextUtil.getApplicationContext().getBean("user", User.class);
        user.setId(loginUser.getId());
        user.setPassword(modifyUser.getPassword());
        int result = userMapper.updateByPrimaryKeySelective(user);

        if (result == 1) {
            loginUser.setPassword(modifyUser.getPassword());
            return null;
        }

        return "密码修改失败，请稍后重试";
    }

    @Override
    public AccountPage getAccountInfo(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(KeyStore.currentLoginUser);
        AccountPage accountPage = springContextUtil.getApplicationContext().getBean("accountPage", AccountPage.class);
        accountPage.setAccount(user.getAccount());
        return accountPage;
    }


    /*
    * 给出账户account或密码password，在数据库中查询匹配用户
    *
    * 找到：返回该用户，否则返回null
    * */
    private User login(String account, String password){
        UserExample userExample = springContextUtil.getApplicationContext().getBean("userExample", UserExample.class);
        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andAccountEqualTo(account);
        if (password != null) {
            criteria.andPasswordEqualTo(password);
        }

        List<User> userList = userMapper.selectByExample(userExample);
        if (userList == null || userList.size() != 1) {
            return null;
        }
        return userList.get(0);
    }
}
