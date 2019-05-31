<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/resource/css/account.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/copyRight.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/common.css"/>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css"/>
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <title>DD音乐控制台</title>
</head>
<body>
    <div id="app">
        <jsp:include page="head.jsp"/>
        <div>
            <jsp:include page="aside.jsp"/>
            <div id="content">
                <el-card id="accountInfo" shadow="hover">
                    <form action="/account/modify" method="post" ref="hiddenForm" id="hiddenForm">
                        <input name="oldPwd" v-model="form.oldPwd"/>
                        <input name="phoneVerifyCode" v-model="form.verifyCode"/>
                        <input name="account" v-model="form.account"/>
                        <input name="password" v-model="form.newPwd"/>
                    </form>
                    <el-form label-width="100px" :model="form" ref="form">
                        <el-form-item label="账户" prop="account">
                            <el-input v-model="form.account" :disabled="true" size="small" title="账户一经建立即不可修改"></el-input>
                        </el-form-item>
                        <el-form-item label="旧密码" prop="oldPwd" :rules="[{required : true, message : '请输入旧密码', trigger : 'blur'}]">
                            <el-input v-model="form.oldPwd" type="password" size="small"></el-input>
                        </el-form-item>
                        <el-form-item label="新密码" prop="newPwd" :rules="[{required : true, message : '请输入新密码', trigger : 'blur'}, {required : true, min : 6, max : 12, message : '密码长度限制于6-12个字符长度', trigger : 'blur'}]">
                            <el-input v-model="form.newPwd" type="password" size="small" title="6-12个字符"></el-input>
                        </el-form-item>
                        <el-form-item label="确认新密码" prop="reNewPwd" :rules="[{required : true, message : '请输入新密码', trigger : 'blur'}, {required : true, min : 6, max : 12, message : '密码长度限制于6-12个字符长度', trigger : 'blur'}]">
                            <el-input v-model="form.reNewPwd" type="password" size="small" title="6-12个字符"></el-input>
                        </el-form-item>
                        <el-form-item label="手机验证码" prop="verifyCode" :rules="[{required : true, message : '请输入验证码', trigger : 'blur'}]">
                            <div id="code">
                                <el-input v-model="form.verifyCode" size="small"></el-input>
                                <el-popover placement="top" width="300" trigger="hover">
                                    <div id="verifyCode">
                                        <img :src="imageVerify" alt="" @click="reGetImageCode">
                                        <el-input size="small" placeholder="输入图形验证码" v-model="form.imageCode"></el-input>
                                        <el-button size="mini" type="primary" @click="sendVerifyCode">发送验证码</el-button>
                                    </div>
                                    <el-button size="mini" slot="reference" type="info" :disabled="btnLock">{{btnText}}</el-button>
                                </el-popover>
                            </div>
                        </el-form-item>
                        <el-form-item>
                            <el-divider></el-divider>
                            <el-button round size="mini" type="primary" @click="updateAccountInfo">确认修改</el-button>
                        </el-form-item>
                    </el-form>
                </el-card>
            </div>
        </div>
        <jsp:include page="copyright.jsp"/>
    </div>
</body>
<%--<script src="https://unpkg.com/vue/dist/vue.js"></script>--%>
<script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
<%--<script src="/resource/js/jquery_v3.4.1.js"></script>--%>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    new Vue({
        el: '#app',
        data(){
            return {
                btnLock : false,
                btnText : "获取",
                btnCountDown : 60,
                baseImageVerify : "/account/verifyImage",
                imageVerify : "/account/verifyImage",
                clientEnv : "pc",
                form : {
                    account : ${accountPage.account},
                    oldPwd : "",
                    newPwd: "",
                    reNewPwd : "",
                    verifyCode : "",
                    imageCode : "",
                }
            }
        },
        methods : {
            <jsp:include page="$methods.jsp"/>
            //重新获取验证码
            reGetImageCode(){
                this.imageVerify = this.baseImageVerify+"?flag="+Math.random();
            },
            sendVerifyCode(){
                const _this = this;
                if (this.form.imageCode === undefined || this.form.imageCode === '') {
                    this.$alert("请输入图形验证码以验证你的身份", "提示：", {type : "warning", showClose : false});
                    return;
                }
                $.ajax({
                    url : "/account/phoneVerifyCode",
                    data : {
                        phoneNumber : _this.form.account,
                        imageCode : _this.form.imageCode,
                    },
                    success : (res)=>{
                        if (res.status) {
                            _this.btnLock = true;
                            const timer = setInterval(function () {
                                if(_this.btnCountDown<=0){
                                    _this.btnLock = false;
                                    _this.btnText = "发送验证码";
                                    _this.btnCountDown = 60;
                                    clearInterval(timer);
                                    return;
                                }
                                _this.btnText = --_this.btnCountDown+"秒后重试";
                            },1000);
                        }
                        _this.$alert(res.msg, "提示", { type : "info", showClose : false});
                    },
                    error : (e)=>{
                        _this.$alert("发送验证码失败，请稍后重试", "网络错误", { type : "error", showClose : false});
                    }
                });
            },
            updateAccountInfo(){
                const _this = this;
                this.$refs['form'].validate((valid) => {
                    if (valid) {
                        if (_this.form.newPwd !== _this.form.reNewPwd) {
                            _this.form.newPwd = _this.form.reNewPwd = "";
                            _this.$alert("两次输入的新密码不一致，请重新输入", "校验不通过", { type : "warning", showClose : false});
                            return;
                        }
                        this.$refs['hiddenForm'].submit();
                    }
                });
            }
        },
        watch : {
            clientEnv(nV, oV){
                if (nV=== "mobile") {
                    this.clientForbid();
                }
            }
        },
        mounted() {
            this.envListener();
            this.clientForbid();
            <c:if test="${sessionScope.pageNotice!=null && sessionScope.pageNotice.status}">
                this.$alert("${sessionScope.pageNotice.msg}", "提示：", {
                    type : "${sessionScope.pageNotice.level}",
                    showClose : false,
                });
            </c:if>
        }
    })
</script>
</html>
