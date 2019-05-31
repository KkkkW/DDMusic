<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: 小感触
  Date: 2019/5/16
  Time: 22:00
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/resource/css/albumList.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/copyRight.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/common.css"/>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <title>DD音乐控制台</title>
</head>
<body>
    <div id="app">
        <el-dialog title="新建歌单" :visible.sync="newAlbumVisible" width="30%" :append-to-body="true" :show-close="false" center :close-on-click-modal="false">
            <div id="newAlbum">
                <el-form label-width="80px" :model="newAlbumInfo" ref="newAlbumForm">
                    <el-form-item prop="name" label="歌单名称" :rules="[{required: true, message : '请输入歌单名称', trigger : 'blur'}, {min :1, max : 16, message : '歌单长度限制在1-16个字符', trigger : 'blur'}]">
                        <el-input v-model="newAlbumInfo.name" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="歌单封面">
                        <el-upload action="/album/cover" list-type="picture-card" :multiple="false" :limit="1" :on-exceed="imageExceed" :before-upload="beforeAvatarUpload" :on-success="imgUploadSuccess" :on-error="imgUploadFailed">
                            <i class="el-icon-plus"></i>
                        </el-upload>
                    </el-form-item>
                    <el-form-item label="可访问性">
                        <el-switch v-model="newAlbumInfo.accessLevel" active-text="公开" inactive-text="加密" inactive-color="red"></el-switch>
                    </el-form-item>
                    <el-form-item label="歌单简介">
                        <el-input v-model="newAlbumInfo.introduce" type="textarea" :autosize="{ minRows: 4, maxRows: 6 }" maxlength="100" show-word-limit clearable></el-input>
                    </el-form-item>
                </el-form>
                <el-tag size="mini" id="tips" type="danger">* 歌单封面可以不设置，此时将使用默认图片作为封面</el-tag>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="cancelCreateAlbum" size="mini">取 消</el-button>
                <el-button type="primary" @click="submitNewAlbum" size="mini">确 定</el-button>
            </span>
        </el-dialog>
        <el-dialog title="设置新封面" :visible.sync="coverUpdateVisible" width="30%" :append-to-body="true" :show-close="false" center :close-on-click-modal="false">
            <div id="coverUpdateUploader">
                <el-upload drag action="/album/cover" :limit="1" accept="image/jpeg" :on-error="imgUploadFailed" :on-success="updateCoverSuccess" :on-exceed="imageExceed" :multiple="false">
                    <i class="el-icon-upload"></i>
                    <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    <div class="el-upload__tip" slot="tip">只能上传jpg图片，且大小不超过2Mb</div>
                </el-upload>
                <el-divider></el-divider>
                <el-button type="danger" size="mini" @click="cancelUpdateCover">取消</el-button>
            </div>
        </el-dialog>
        <jsp:include page="head.jsp"/>
        <div>
            <jsp:include page="aside.jsp"/>
            <div id="content">
                <div id="content-op">
                    <el-tag type="warning">
                        歌单总量:<b>{{total}}</b>
                    </el-tag>
                    <el-divider direction="vertical"></el-divider>
                    <el-button type="primary" size="small" round @click="newAlbumVisible=true">+ 新建歌单</el-button>
                    <el-divider direction="vertical"></el-divider>
                    <el-button type="info" size="small" round @click="toggleLock" v-show="lock"><i class="el-icon-edit-outline"></i> 编辑歌单</el-button>
                    <el-button type="danger" size="small" round @click="toggleLock" v-show="!lock"><i class="el-icon-edit-outline"></i> 锁定编辑</el-button>
                </div>
                <el-table :data="albumList" style="width: 100%"  id="albumList" :stripe="true" v-if="albumList!=null && albumList.length>0">
                    <el-table-column label="歌单名称" width="180" align="center">
                        <template slot-scope="scope">
                            <el-tag type="primary" v-show="lock">{{scope.row.name}}</el-tag>
                            <el-input type="text" size="small" v-model="scope.row.name" v-show="!lock" clearable></el-input>
                        </template>
                    </el-table-column>
                    <el-table-column label="封面" width="150" align="center">
                        <template slot-scope="scope">
                            <el-popover :title="scope.row.name" width="300" trigger="click" placement="right">
                                <div class="preview_cover">
                                    <img :src="scope.row.cover" alt="歌单封面预览"/>
                                    <div>
                                        <el-button size="mini" type="primary" round @click="updateCover(scope.$index)" v-show="!lock">更换封面</el-button>
                                    </div>
                                </div>
                                <img :src="scope.row.cover" alt="" class="cover" slot="reference"/>
                            </el-popover>
                        </template>
                    </el-table-column>
                    <el-table-column  label="创建日期" width="180" align="center">
                        <template slot-scope="scope">
                            <span v-text="new Date(scope.row.createTime).format('yyyy-MM-dd hh:mm')"></span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="musicCount" label="包含歌曲数" width="130" align="center"></el-table-column>
                    <el-table-column label="可访问性" width="150" align="center">
                        <template slot-scope="scope">
                            <el-switch v-model="scope.row.accessLevel" active-text="公开" inactive-text="加密" inactive-color="red" :disabled="lock"></el-switch>
                        </template>
                    </el-table-column>
                    <el-table-column label="歌单简介" width="250">
                        <template slot-scope="scope">
                            <span v-show="lock">{{scope.row.introduce}}</span>
                            <el-input v-model="scope.row.introduce" type="textarea" :autosize="{ minRows: 4, maxRows: 6 }" maxlength="100" show-word-limit v-show="!lock" clearable></el-input>
                        </template>
                    </el-table-column>
                    <el-table-column label="操作">
                        <template slot-scope="scope">
                            <el-link :href=buildRouter(scope.row.id) target="_self" :underline="false">
                                <el-button type="info" circle size="small" title="查看该歌单内的音乐"><i class="el-icon-s-grid"></i></el-button>
                            </el-link>
                            <el-button type="danger" round size="small" title="删除该歌单" v-show="!lock" @click="deleteAlbum(scope.row)"><i class="el-icon-delete-solid"></i> 删除</el-button>
                            <el-button type="success" round size="small" title="提交更改" v-show="!lock" @click="updateAlbum(scope.row)"><i class="el-icon-success"></i> 提交</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div id="emptyList" v-if="albumList==null || albumList.length<=0">
                    <h1>Empty...</h1>
                    <el-divider></el-divider>
                    <p>暂无已创建的歌单</p>
                </div>
            </div>
            <el-pagination background layout="prev, pager, next" :total=total :page-size="pageSize"  :current-page.sync="currentPage" v-if="albumList!=null && albumList.length>0"  @current-change="currentChange"></el-pagination>
        </div>
        <jsp:include page="copyright.jsp"/>
    </div>
</body>
<script src="/resource/js/kutils.js"></script>
<%--注意脚本引入顺序！--%>
<%--<script src="https://unpkg.com/vue/dist/vue.js"></script>--%>
<script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
<%--<script src="/resource/js/jquery_v3.4.1.js"></script>--%>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    new Vue({
        el: '#app',
        data: function() {
            return {
                //交互
                lock : true,//是否锁定歌单
                newAlbumVisible : false,
                coverUpdateVisible : false,
                clientEnv : "pc",
                //数据域
                albumList : [],//歌单列表
                currentUpdateCoverIndex : undefined,//当前编辑歌单封面索引位置
                newAlbumInfo : {
                    name : "",
                    cover : "",
                    accessLevel : true,
                    introduce : "",
                },
                //分页
                totalPage : 0,
                currentPage : 0,
                pageSize : 0,
                total : 0,
            }
        },
        mounted(){
            this.envListener();
            this.clientForbid();
            <c:if test="${pagination!=null}">
                this.currentPage = ${pagination.currentPage};
               this.pageSize = ${pagination.pageSize};
            </c:if>
            this.queryAlbumList(this.currentPage, this.pageSize);
        },
        watch : {
            clientEnv(nV, oV){
                if (nV=== "mobile") {
                    this.clientForbid();
                }
            }
        },
        methods : {
            <jsp:include page="$methods.jsp"/>
            buildRouter(id){
                return "/manage/music-list?albumId="+id;
            },
            toggleLock(){
                if (!this.lock) {
                    this.lock = true;
                }else{
                    this.lock = false;
                    this.$alert("您现在可以编辑每个歌单的相关信息了，在对应歌单后面点击提交按钮即可提交新信息", "提示", {type : "info", showClose : false});
                }
            },
            deleteAlbum(obj){
                const _this = this;
                this.$confirm('您确认要删除歌单：'+obj.name+" 以及歌单内的所有相关的音乐资源吗？此操作无法撤销！", '提示：', {
                    confirmButtonText: '确定删除',
                    cancelButtonText: '取消',
                    type:"warning"
                }).then(({}) => {
                    $.ajax({
                        url : "/album/delete",
                        type : "post",
                        data : {
                            id : obj.id
                        },
                        success : (res)=>{
                            if (res.status) {
                                _this.currentPage = 1;
                                _this.queryAlbumList(_this.currentPage, _this.pageSize);
                            }
                            this.$alert(res.msg, "提示：", {type : "info", showClose: false});
                        },
                        error : (e)=>{
                            this.$alert("删除歌单失败，请稍后重试", "服务器无响应", { type : "error", showClose : false});
                        }
                    })
                }).catch(() => {});
            },
            updateAlbum(obj){
                const _this = this;
                if(obj.id===undefined){
                    this.$alert("数据校验错误，请尝试重新刷新页面", "提示：", {type : "error"});
                    return;
                }
                if(obj.name===undefined || obj.name==="" || obj.name.length>16){
                    this.$alert("歌单名称校验不通过：1-16字符，请确认问题并重试！", "提示：", {type : "error"});
                    return;
                }
                var copy = JSON.parse(JSON.stringify(obj));
                copy.createTime = undefined;
                $.ajax({
                    url : "/album/update",
                    type : "post",
                    data : copy,
                    success : (res)=>{
                        _this.$alert(res.msg, "提示：", { type : "info", showClose : false});
                        if (res.status) {
                            _this.$message({message : "提交成功。若退出编辑模式，请点击顶部 '锁定编辑' 按钮，否则请继续进行编辑工作", type : "success", duration : 8000});
                        }
                    },
                    error : (e)=>{
                        _this.$alert("歌单信息提交失败，请稍后重试", "提交失败",  { type : "error", showClose : false});
                    }
                });
            },
            imageExceed(){
                this.$alert("相册封面仅允许上传一张, 如果要更换图片，请先删除之前上传完成的图片。", "提示", {type : "info", showClose : false});
            },
            beforeAvatarUpload(file) {
                const isJPG = file.type === 'image/jpeg';
                const isLt2M = file.size / 1024 / 1024 < 2;
                if (!isJPG) {
                    this.$message.error('上传头像图片只能是 JPG 格式!');
                }
                if (!isLt2M) {
                    this.$message.error('上传头像图片大小不能超过 2MB!');
                }
                return isJPG && isLt2M;
            },
            queryAlbumList(currentPage, pageSize){
                $.ajax({
                    url : "/album/list",
                    data : {
                        currentPage : currentPage,
                        pageSize : pageSize,
                    },
                    success : (res)=>{
                        if(res.status){
                            this.$alert(res.pageNotice.msg, "提示：", {type: res.pageNotice.level})
                            return;
                        }
                        this.totalPage = res.pagination.totalPage;
                        this.currentPage = res.pagination.currentPage;
                        this.pageSize = res.pagination.pageSize;
                        this.total = res.pagination.total;
                        this.albumList = res.albumList;
                    },
                    error : (e)=>{
                        this.$alert("获取歌单列表失败，请稍后重试！", "请求失败", {type : "error", showClose : false});
                    }
                });
            },
            currentChange(val){
                this.currentPage = val;
                this.queryAlbumList(this.currentPage, this.pageSize);
            },
            cancelCreateAlbum(){
                this.newAlbumVisible = false;
                this.newAlbumInfo =  {
                    name : "",
                    cover : "",
                    accessLevel : true,
                    introduce : "",
                }
            },
            submitNewAlbum(){
                this.$refs['newAlbumForm'].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url : "/album",
                            type : "post",
                            data : {
                                accessLevel: this.newAlbumInfo.accessLevel,
                                cover: this.newAlbumInfo.cover,
                                introduce: this.newAlbumInfo.introduce,
                                name: this.newAlbumInfo.name
                            },
                            success : (res)=>{
                                this.$alert(res.msg, "提示", { type : "info", showClose : false});
                                if(res.status){
                                    this.cancelCreateAlbum();
                                    this.currentPage = 1;
                                    this.queryAlbumList(this.currentPage, this.pageSize)
                                }
                            },
                            error : (e)=>{
                                this.$alert("新建歌单失败，请稍后重试", "服务器无响应", { type : "error", showClose : false});
                                this.cancelCreateAlbum();
                            }
                        });
                        return;
                    }
                    this.$alert("数据校验不通过，请检查", "提示", {
                        type : "error",
                        showClose : false
                    });
                });
            },
            imgUploadSuccess(res){
                if (res.status) {
                    this.$message({message: "图片上传成功，请继续其他操作", type : "success"});
                    this.newAlbumInfo.cover = res.url;
                    return;
                }
                this.$message({message: res.msg, type : "error"});
            },
            updateCover(index){
                this.currentUpdateCoverIndex = index;
                this.coverUpdateVisible = true;
            },
            cancelUpdateCover(){
              this.coverUpdateVisible = false;
              this.currentUpdateCoverIndex = undefined;
            },
            updateCoverSuccess(res){
                if (res.status) {
                    this.$message({message: "图片上传成功，请继续其他操作", type : "success"});
                    this.albumList[this.currentUpdateCoverIndex].cover = res.url;
                }else{
                    this.$message({message: res.msg, type : "error"});
                }
                this.currentUpdateCoverIndex = undefined;
                this.coverUpdateVisible = false;
            },
            imgUploadFailed(err) {
                this.newAlbumInfo.cover = "";
                this.$alert("图片上传失败，", "提示", {type : "error", showClose : false});
            }
        }
    })
</script>
</html>
