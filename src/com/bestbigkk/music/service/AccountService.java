package com.bestbigkk.music.service;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.domain.LoginUser;
import com.bestbigkk.music.domain.ModifyUser;
import com.bestbigkk.music.vo.AccountPage;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Service
public interface AccountService {
    /*
    * 为当前用户创建图片验证码，并将结果存储于session中
    *
    * 直接返回图片对象
    * */
    void createImageVerify(HttpServletRequest request, HttpServletResponse response);

    /*
    * 为当前用户发送一次手机验证码，60s允许发送一次
    *
    * 需提供参数：
    *       phoneNumber ： 发送短信验证码的目标手机号码
    *       imageCode ： 用户输入的图形验证码结果
    *
    * 返回JSON对象，包含执行结果以及原因
    * */
    JSONObject getPhoneVerifyCode(HttpServletRequest request, HttpServletResponse response);

    /*
    * 根据当前用户传递的信息进行登录操作
    * 需提供参数：
    *   model : 指定登录方式，可选值：【1 =账户，密码登录| 2 = 验证码登录】
    *   account ：被登录账户
    *   password ： 登录密码
    *   verifyCode ： 验证码
    *
    *   如果指定：
    *       model=1， 登录成功条件：账户密码正确，验证码正确
    *       model=2，登录成功条件：账户（手机号码）以及验证码（发送到手机的验证码）匹配
    *
    *   登录成功之后，将在用户的Session域存储当前用户信息
    *
    *   返回JSON对象，包含执行结果以及原因
    * */
    JSONObject login(LoginUser user, HttpServletRequest request, HttpServletResponse response);

    /*
    * 退出操作，清空当前用户的session信息
    *
    * 对外，该操作永远正常执行完成，客户端将始终收到正常响应结果
    * */
    void logout(HttpServletRequest request, HttpServletResponse response);

    /*
    * 给出被修改账户对象，需要提供：
    *   被修改账户account
    *   旧密码 oldPwd
    *   新密码password
    *   手机验证码phoneVerifyCode
    *
    *   返回：
    *       null : 修改成功
    *       否则返回具体失败原因
    *
    * */
    String modifyAccountInfo(ModifyUser user, HttpServletRequest request, HttpServletResponse response);

    /*
    * 得到当前用户在： 账户管理页面  所需要的数据信息
    * */
    AccountPage getAccountInfo(HttpServletRequest request, HttpServletResponse response);
}
