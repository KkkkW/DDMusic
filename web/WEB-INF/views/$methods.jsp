<%@ page contentType="text/html;charset=UTF-8" language="java" %>
showCopyRight(){
    this.$alert(" <p style='text-indent: 2rem;'>本站(<b>www.music.bestBigKK.com</b>)所发布的部分资源来自于网络，本站仅对其进行收集，整理，发布并仅用于学习交流之用途。" +
        "除原创性质的内容外，本站不对各板块所发布的其余内容持有版权！本站重视并尊重资源所有者的权益，亦承诺不会将此类资源用于具有商业以及盈利性质的行为中。作为访问者，您需要明确并认同：<b>本站" +
            "提供的内容或服务仅用于个人学习、研究或欣赏及其他非商业性，非盈利性的用途。</b>同时您应遵守著作权法及其他相关法律的规定，不得侵犯本站及相关权利人的合法权利。不得私自对本站进行包括但不限于：" +
        "盗链，非法爬取或转载网站内容，非法获取页面板式及源代码等非法操作！对于所有不持版权的资源本站在引用时均已注明其出处。</p>"+
    "<p style='text-indent: 2rem; '>如您是本站所引用资源的权利人且并不认同本站对您所有资源的使用行为，请您及时联系本站。本站将在确认问题后，对资源及时做出处理。反馈邮箱：KK980827@163.com</p>", "版权须知", {showClose: false, type:"info",center : true, dangerouslyUseHTMLString: true, confirmButtonText: '我已知悉并认同以上说明',});
},
envListener(callBack){
    this.clientEnv = $(window).innerWidth()>1024 ? "pc" : "mobile";
        $(window).resize(()=>{
            if ($(window).innerWidth() <= 1024) {
                this.clientEnv = "mobile";
                console.log("to Mobile");
            }else{
                this.clientEnv = "pc";
                console.log("to PC");
            }
            if(callBack!==undefined){
                callBack($(window).innerWidth(), $(window).innerHeight());
            }
    });
},
clientForbid(){
    if (this.clientEnv === 'mobile') {
        $("#app").css("filter", "blur(10px)");
        this.$confirm('当前页是针对后台管理功能而设立的，未提供对移动端(width<1024px)的适配，请使用电脑访问本页面, 如您因意外调整电脑窗口而触发了该提示，请重新调整窗口至宽度大于1024px。', '提示', {
                confirmButtonText: '确定',
                type: 'error',
                showClose : false,
                center : true
            }).then(() => {
                if(this.clientEnv==="pc"){
                    $("#app").css("filter", "blur(0)");
                    return;
                }
                window.open("/", "_self");
            }).catch(() => {
                if(this.clientEnv==="pc"){
                    $("#app").css("filter", "blur(0)");
                    return;
                }
                window.open("/", "_self");
        });
    }
},