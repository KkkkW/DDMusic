<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="/resource/css/index.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/copyRight.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/common.css"/>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <title>DD音乐</title>
  </head>
  <body>
    <div id="app">
      <el-dialog title="图形验证" :visible.sync="imageVerifyVisible" width="20%">
          <div id="imageVerify">
            <img :src="imageVerify" alt="图形验证码" @click="reGetImageCode()" />
            <el-divider>输入结果</el-divider>
            <el-input v-model="form.imageCode" prefix-icon="el-icon-lollipop"></el-input>
            <el-button type="primary" @click="verify()" size="mini" round>确 定</el-button>
          </div>
      </el-dialog>
      <div id="form">
        <el-tabs type="border-card" :stretch="true" @tab-click="resetForm">
          <el-tab-pane label="账户密码登录">
            <el-form label-width="80px" :model="form" ref="loginModel_1">
              <el-form-item label="账户" prop="account" :rules="[ { required: true, message: '请输入您的账户', trigger: 'blur' },  { min : 6, max : 12,  message: '账户长度在 6 到 12 个字符', trigger: 'blur' } ]">
                <el-input v-model="form.account" prefix-icon="el-icon-user-solid" autofocus></el-input>
              </el-form-item>
              <el-form-item label="密码" prop="password" :rules="[ { required: true, message: '请输入密码', trigger: 'blur' }]">
                <el-input v-model="form.password" type="password" prefix-icon="el-icon-place"></el-input>
              </el-form-item>
              <el-form-item label="验证码" prop="imageCode" :rules="[ { required: true, message: '请输入图形验证码', trigger: 'blur' }]">
                <el-input v-model="form.imageCode" prefix-icon="el-icon-place"></el-input>
                <img :src="imageVerify" alt="图形验证码" @click="reGetImageCode()"/>
              </el-form-item>
              <el-form-item>
                <%--<el-checkbox v-model="form.remember">记住密码</el-checkbox>--%>
                <small style="color: red">* 后台管理仅对管理员开放！</small>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" round class="btn_login" @click="login()">登 录</el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>
          <el-tab-pane label="验证码登录">
            <el-form label-width="80px" :model="form" ref="loginModel_2" :disabled="true">
              <el-form-item label="手机号码" prop="phoneNumber" :rules="[ { required: true, message: '请输入您的手机号码', trigger: 'blur' }]">
                <el-input v-model="form.phoneNumber" prefix-icon="el-icon-user-solid"></el-input>
              </el-form-item>
              <el-form-item label="验证码" v-show="loginBtnVisible"  prop="phoneCode" :rules="[ { required: true, message: '请输入手机收到的短信验证码', trigger: 'blur' }]">
                <el-input v-model="form.phoneCode" prefix-icon="el-icon-user-solid"></el-input>
              </el-form-item>
              <el-form-item v-if="false">
                <el-button type="success" round size="mini" class="btn_login" @click="imageVerifyVisible=true" v-show="!loginBtnVisible">获取验证码</el-button>
                <el-button type="primary" round size="mini" class="btn_login" v-show="loginBtnVisible" @click="login()">登 录</el-button>
              </el-form-item>
              <el-form-item>
                <p style="color: red;">* 该登陆方式被禁用，暂不可用！</p>
              </el-form-item>
            </el-form>
          </el-tab-pane>
        </el-tabs>
      </div>
      <div id="copyRight">
        <div class="content" ref="b">
          <p>DD音乐 | <span id="btn" @click="showCopyRight()">版权声明</span> | <a href="http://www.beian.miit.gov.cn" target="_blank">豫ICP备- 19006530 号</a></p>
          <p>若您对本站发布的资源等形式的内容存在版权疑问，请先查阅版权声明，确认问题后可以联系本站并进行后续处理</p>
          <p>Copyright © 2018-2019  www.music.BestBigKK.com All Rights Reserved <span id="version"> | Source code version:1.0</span></p>
        </div>
      </div>
    </div>
  </body>
  <%--<script src="/resource/js/jquery_v3.4.1.js"></script>--%>
  <script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
  <%--<script src="https://unpkg.com/vue/dist/vue.js"></script>--%>
  <script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
  <script src="https://unpkg.com/element-ui/lib/index.js"></script>
  <script>
    new Vue({
      el: '#app',
      data: function() {
        return {
          //交互域
          imageVerifyVisible : false,
          loginBtnVisible : false,
          clientEnv : "pc",
          baseImageVerify : "/account/verifyImage",
          imageVerify : "/account/verifyImage",
          //数据域
          form : {
            loginModel : 1,
            account : "",
            password : "",
            remember : false,
            phoneNumber : "",
            phoneCode : "",
            imageCode : "",
          }
        }
      },
      mounted(){
        this.envListener();
        this.clientForbid();
        <c:if test="${sessionScope.pageInfo.status}">
          this.$alert("${sessionScope.pageInfo.msg}", "提示：", {
              type : "error",
              showClose : false,
          });
        </c:if>
      },
      watch : {
        clientEnv(nV, oV){
          if (nV=== "mobile") {
              this.clientForbid();
          }
        }
      },
      methods : {
        //显示版权
       <jsp:include page="$methods.jsp"/>
        //重新获取验证码
        reGetImageCode(){
          this.imageVerify = this.baseImageVerify+"?flag="+Math.random();
        },
        //在点击tab切换登录方式之后，清空数据
        resetForm(model){
          this.reGetImageCode();
          if(model.label==="账户密码登录"){
            this.form.loginModel = 1;
            this.form.phoneNumber = this.form.imageCode = this.form.phoneCode =  "";
            this.loginBtnVisible = false;
            return;
          }
          this.form.loginModel = 2;
          this.form.account = this.form.password = "";
          this.form.remember = false;
        },
        //输入图形验证码之后，进行验证
        verify(){
          const _this = this;
          if(this.form.phoneNumber==null || !(/^1[3|4|5|8][0-9]\d{4,8}$/.test(this.form.phoneNumber))){
            this.$alert("请输入有效的手机号码以验证！", "校验失败", {
              showClose: false,
              type : "error"
            });
            this.imageVerifyVisible = false;
            return;
          }

          if(this.form.imageCode===undefined || this.form.imageCode===""){
            this.$alert("请输入验证码以验证你的身份！", "校验失败", {
              showClose: false,
              type : "error"
            });
            return;
          }
          $.ajax({
            url : "/account/phoneVerifyCode",
            data : {
              phoneNumber: this.form.phoneNumber,
              imageCode : this.form.imageCode,
            },
            success : (res)=>{
              console.log(res);
              _this.reGetImageCode();
              _this.imageVerifyVisible = false;
              _this.$alert(res.msg, "请求结果：", {type : "info"});
              if(res.status){
                _this.loginBtnVisible = true;
              }
            },
            error : (e)=>{
              _this.reGetImageCode();
              _this.imageVerifyVisible = false;
              _this.$alert("请求手机验证码失败，请稍后重试！", "网络错误", {type : "error"});
            }
          });
        },
        //登录
        login(){
          //账户密码登录
          if(this.form.loginModel===1){
            this.$refs["loginModel_1"].validate((valid) => {
              if (valid) {
                this._login({
                  account : this.form.account,
                  password : this.form.password,
                  verifyCode : this.form.imageCode,
                  remember : this.form.remember,
                  loginModel: this.form.loginModel
                });
              }
            });
            return;
          }else if(this.form.loginModel===2){//验证码登录
            this.$refs["loginModel_2"].validate((valid) => {
              if (valid) {
                this._login({
                  account : this.form.phoneNumber,
                  verifyCode : this.form.phoneCode,
                  loginModel: this.form.loginModel
                });
              }
            });
            return;
          }
          this.$alert("无法判定您的登录方式，请刷新页面重试！", "校验错误", {type : "error"});
        },
        _login(params){
          $.ajax({
            url : "/account/login",
            data : params,
            success : (res) =>{
              if (res.status) {
                window.open(res.url, "_self");
                return;
              }
              this.$alert(res.msg, "请求结果：", {type : "info"});
            },
            error : (e)=>{
              this.$alert("请求登录失败，请稍后重试", "网络错误", {type : "error"});
            }
          });
        }
      }
    });
  </script>
</html>
