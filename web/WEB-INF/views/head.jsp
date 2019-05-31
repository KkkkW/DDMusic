<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header>
    <h1>DD音乐控制台</h1>
    <div id="op">
        <el-link type="danger" href="http://bestbigkk.com" target="_self" :underline="false">
            <el-button size="small" type="primary" round>进入主站</el-button>
        </el-link>
        <el-link type="danger" href="/account/logout" target="_self" :underline="false">
            <el-button size="small" type="danger" round>退出登录</el-button>
        </el-link>
    </div>
</header>