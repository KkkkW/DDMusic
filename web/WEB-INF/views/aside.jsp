<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside>
    <img src="/resource/app-images/logo.png" alt="Logo" id="logo">
    <ul id="menus">
        <li>
            <el-link type="primary" :underline="false" href="/manage/album-list" target="_self">
                歌单管理
                <el-divider direction="vertical"></el-divider>
                <i class="el-icon-menu"></i>
            </el-link>
        </li>
        <li>
            <el-link type="primary" :underline="false" href="/manage/music-list" target="_self">
                歌曲管理
                <el-divider direction="vertical"></el-divider>
                <i class="el-icon-menu"></i>
            </el-link>
        </li>
        <li>
            <el-link type="primary" :underline="false" href="/manage/account" target="_self">
                账户管理
                <el-divider direction="vertical"></el-divider>
                <i class="el-icon-menu"></i>
            </el-link>
        </li>
    </ul>
</aside>