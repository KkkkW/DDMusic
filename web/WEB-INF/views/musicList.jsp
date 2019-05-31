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
    <link rel="stylesheet" type="text/css" href="/resource/css/musicList.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/copyRight.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/common.css"/>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <title>DD音乐控制台</title>
</head>
<body>
    <div id="app">
        <jsp:include page="head.jsp"/>
        <div>
            <transition name="el-zoom-in-top">
                <div id="miniPlayer" v-show="isPlaying">
                    <span><small>正在播放：</small>
                        <el-tag type="primary" size="small" id="name" :title="playingMusicName">{{playingMusicName}}</el-tag>
                    </span>
                    <audio ref="audio" loop></audio>
                    <el-button size="mini" round type="primary" @click="stopMusic">
                        <i class="el-icon-switch-button"></i>
                        停止播放
                    </el-button>
                </div>
            </transition>
            <el-dialog title="编辑音乐信息" :visible.sync="updateVisible" width="30%" :show-close=false :append-to-body="true" :close-on-click-modal="false">
                <div id="updateForm">
                    <el-form :model="update" status-icon ref="updateForm" label-width="100px" >
                        <el-form-item label="歌曲名称" prop="name" :rules="[{required : true, message : '请输入歌曲名称', trigger : 'blur'}, {min : 1, max : 16, message : '歌曲名称在1-16个字符之间', trigger : 'blur'}]">
                            <el-input  v-model="update.name" size="small"></el-input>
                        </el-form-item>
                        <el-form-item label="歌手" prop="singer" :rules="[{required : true, message : '请输入歌手名称', trigger : 'blur'}, {min : 1, max : 16, message : '歌手名称在1-16个字符之间', trigger : 'blur'}]">
                            <el-input  v-model="update.singer" size="small"></el-input>
                        </el-form-item>
                        <el-form-item label="持续时间" prop="time" :rules="[{required : true, message : '请输入歌曲持续时间(示例：05:20) ', trigger : 'blur'}, {min : 1, max : 8, message : '歌曲持续时间在1-8个字符之间', trigger : 'blur'}]">
                            <el-input size="small" v-model="update.time"></el-input>
                        </el-form-item>
                        <el-form-item label="歌词文件" prop="lyric">
                            <template slot-scope="scope">
                                <el-button type="danger" size="mini" v-show="checkLyric(update.lyric)" @click="lrcDelete">删除已上传歌词</el-button>
                                <el-upload action="/music/upload" :limit="1" :on-success="updateLrcSuccess" :on-exceed="exceed">
                                    <el-button size="mini" type="primary"><i class="el-icon-plus"></i> 选取歌词文件 (*.lrc)</el-button>
                                </el-upload>
                            </template>
                        </el-form-item>
                        <el-form-item label="封面" prop="cover">
                            <template slot-scope="scope">
                                <div class="formCover">
                                    <el-image v-if="update.cover!==undefined && update.cover!==''" :src="update.cover"></el-image>
                                    <el-upload action="/music/upload" :limit="1" accept="image/jpeg" :on-success="updateImageSuccess" :on-exceed="exceed">
                                        <el-button size="mini" type="primary">选取封面</el-button>
                                    </el-upload>
                                </div>
                            </template>
                        </el-form-item>
                    </el-form>
                   <span slot="footer" class="dialog-footer">
                         <el-divider></el-divider>
                        <el-button @click="cancelUpdate" size="small" round>取 消</el-button>
                        <el-button type="primary" @click="submitUpdate" size="small" round>确 定</el-button>
                    </span>
                </div>
            </el-dialog>
            <el-dialog title="上传音乐" :visible.sync="uploadMusicVisible" width="60%"  @closed="cancelSubmit">
                <div id="uploadForm">
                    <el-steps :active=activeStep finish-status="success" simple style="margin-top: 20px">
                        <el-step title="1.上传歌曲文件" ></el-step>
                        <el-step title="2.上传歌词文件" ></el-step>
                        <el-step title="3.上传歌曲封面" ></el-step>
                        <el-step title="4.确认信息" ></el-step>
                    </el-steps>
                    <div id="u_music" v-show="activeStep==0" class="uploader">
                        <%--音乐上传--%>
                        <el-upload drag
                                   action="/music/upload"
                                   ref="musicUploader"
                                   accept="audio/mp3"
                                   :before-upload="verifyMusic"
                                   :multiple="false"
                                   :limit="1"
                                   :before-remove="removeMusic"
                                   :on-exceed="exceed"
                                   :on-success="addMusicSuccess"
                        >
                            <i class="el-icon-upload"></i>
                            <div class="el-upload__text">拖动音乐文件到此处，或<em>点击上传</em></div>
                            <div class="el-upload__tip" slot="tip">只能上传mp3文件，且不超过10Mb</div>
                            <div class="el-upload__tip" slot="tip">请保持歌曲命名格式为：<span><b>歌手名称 - 歌曲名.mp3</b></span>, 后续将自动解析出歌曲相关信息</div>
                        </el-upload>
                    </div>
                    <div id="u_lyric" v-show="activeStep==1" class="uploader">
                        <%--歌词文件上传--%>
                        <el-upload drag
                                   action="/music/upload"
                                   ref="musicUploader"
                                   :multiple="false"
                                   :on-exceed="exceed"
                                   :limit="1"
                                   :before-remove="removeLyric"
                                   :before-upload="verifyLyric"
                                   :on-success="addLrcSuccess"
                        >
                            <i class="el-icon-upload"></i>
                            <div class="el-upload__text">将歌词文件拖到此处，或<em>点击上传</em></div>
                            <div class="el-upload__tip" slot="tip"><span>* 如果该歌曲没有歌词，可跳过此步骤</span></div>
                            <div class="el-upload__tip" slot="tip">只能上传lrc文件, 请控制文件大小在512Kb以内</div>
                            <div class="el-upload__tip" slot="tip">解析工作将以 <span><b>网易云音乐</b></span> 下载的歌词为准，请注意歌词来源</div>
                        </el-upload>
                    </div>
                    <div id="u_cover" v-show="activeStep==2" class="uploader" >
                        <%--封面文件上传--%>
                        <el-upload
                                action="/music/upload"
                                list-type="picture-card"
                                :multiple="false"
                                :limit="1"
                                :on-exceed="exceed"
                                :before-upload="verifyCover"
                                accept="image/jpeg"
                                :before-remove="removeCover"
                                :on-success="addCoverSuccess"
                        >
                            <i class="el-icon-plus"></i>
                            <div class="el-upload__tip" slot="tip"><span>* 如果该歌曲不包含封面，可跳过此步骤</span></div>
                            <div class="el-upload__tip" slot="tip">请为该歌曲选择封面，后续该图片将用作背景图及缩略图</div>
                            <div class="el-upload__tip" slot="tip">请控制封面大小在2Mb以内</div>
                        </el-upload>
                    </div>
                    <div id="u_info" v-show="activeStep==3">
                        <el-form label-width="120px" :model="upload" ref="addMusicForm">
                            <el-form-item label="所属歌单名称">
                                <el-input :disabled="true" v-model="currentAlbumName" size="small"></el-input>
                            </el-form-item>
                            <el-form-item label="所属歌单ID" prop="albumId" :rules="[{required : true, message : '上传的音乐必须隶属于某一歌单，请先在页面顶部选择歌单', trigger : 'blue'}]">
                                <el-input v-model="upload.albumId" size="small" :disabled="true"></el-input>
                            </el-form-item>
                            <el-form-item label="歌曲名" prop="name" :rules="[{required : true, message : '必须输入歌曲名称', trigger : 'blur'}, {min : 1, max : 32, message : '歌曲名称在1-32个字符区间', trigger : 'blue'}]">
                                <el-input v-model="upload.name" size="small"></el-input>
                            </el-form-item>
                            <el-form-item label="歌手" prop="singer" :rules="[{required : true, message : '必须输入歌手名称，否则请输入未知'}, {min : 1, max : 32, message : '歌手名称在1-32个字符区间', trigger:'blur'}]">
                                <el-input v-model="upload.singer" size="small"></el-input>
                            </el-form-item>
                            <el-form-item label="持续时间" prop="time" :rules="[{required : true, message : '必须输入歌曲的持续时间，示例：05:20', trigger : 'blur'}, {min : 1, max : 8, message: '示例：05:20', trigger : 'blur'}]">
                                <el-input v-model="upload.time" size="small"></el-input>
                            </el-form-item>
                            <el-form-item label="是否包含歌词">
                                <el-tag type="success" v-show="upload.lrcStatus">包含歌词</el-tag>
                                <el-tag type="danger" v-show="!upload.lrcStatus">没有歌词</el-tag>
                            </el-form-item>
                            <el-form-item label="是否包含封面">
                                <el-tag type="success" v-show="upload.coverStatus">包含封面文件</el-tag>
                                <el-tag type="danger" v-show="!upload.coverStatus">没有封面</el-tag>
                            </el-form-item>
                            <el-button round type="success" @click="submitMusic">提交信息</el-button>
                            <el-divider></el-divider>
                            <p>请检查信息是否有误，确认后将进行提交工作</p>
                        </el-form>
                    </div>
                    <div class="uploader">
                        <el-button type="primary" @click="activeStep--" size="mini" v-show="activeStep>0"><i class="el-icon-arrow-left"></i>上一步 </el-button>
                        <el-button @click="activeStep++" type="primary" size="mini" v-show="activeStep<3">下一步 <i class="el-icon-arrow-right"></i></el-button>
                    </div>
                </div>
            </el-dialog>
            <jsp:include page="aside.jsp"/>
            <div id="content">
                <div id="content-op" v-if="opVisible">
                    <el-button type="success" round size="small" v-show="currentAlbumName!==''" id="uploadBtn" title="上传音乐" @click="uploadMusicVisible=true">+</el-button>
                    <el-tag type="primary" v-show="currentAlbumName!=''">
                        歌单内歌曲数目：<b>{{currentAlbum.musicCount}}</b>
                    </el-tag>
                    <el-divider direction="vertical"></el-divider>
                    <el-select v-model="currentAlbumName" placeholder="请选择歌单以查看" size="small" @change="selectAlbum">
                        <el-option v-for="item in albumList" :key="item.id" :label="item.name" :value="item.name"></el-option>
                    </el-select>
                    <el-divider direction="vertical"></el-divider>
                    <el-button type="primary" size="mini" v-show="albumTotalPage>1&&albumCurrentPage>1" @click="queryAlbumList(1, albumPageSize)">首页歌单</el-button>
                    <el-button type="warning" size="mini" v-show="albumTotalPage>1&&albumCurrentPage>1" @click="queryAlbumList(--albumCurrentPage, albumPageSize)" round>上一页歌单</el-button>
                    <el-button type="warning" size="mini" v-show="albumTotalPage>1&&albumCurrentPage<albumTotalPage" @click="queryAlbumList(++albumCurrentPage, albumPageSize)" round>下一页歌单</el-button>
                    <el-button type="primary" size="mini" v-show="albumTotalPage>1" @click="queryAlbumList(albumTotalPage, albumPageSize)">末页歌单</el-button>
                    <el-divider direction="vertical"></el-divider>
                    <el-switch v-model="thumbVisible" active-text="预览封面" inactive-text="关闭预览"></el-switch>
                </div>
                <div id="empty" v-show="currentAlbumName=='' && opVisible">
                    <i class="el-icon-info"></i>
                    <el-divider></el-divider>
                    <p>请选择具体歌单以管理</p>
                </div>
                <el-table :data="musicList" stripe style="width: 100%" v-show="!opVisible || currentAlbumName!=''" ref="table">
                    <el-table-column type="index" width="50" align="center"></el-table-column>
                    <el-table-column prop="name" label="歌曲名" width="380" align="center"></el-table-column>
                    <el-table-column prop="singer" label="歌手" width="100" align="center"></el-table-column>
                    <el-table-column label="封面" width="100" align="center">
                        <template slot-scope="scope">
                            <el-popover title="歌曲封面" width="300" trigger="hover" placement="right">
                                <div class="preview_cover">
                                    <img :src="scope.row.cover" alt="歌曲封面预览"/>
                                </div>
                                <i class="el-icon-picture-outline-round" slot="reference" title="查看歌曲封面" v-show="!thumbVisible"></i>
                            </el-popover>
                            <img :src="scope.row.cover" alt="歌曲封面预览" class="thumbImg" v-show="thumbVisible" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="time" label="持续时间" width="80" align="center"></el-table-column>
                    <el-table-column prop="lyric" label="歌词" width="80" align="center">
                        <template slot-scope="scope">
                            <el-tag type="success" size="small" v-if="checkLyric(scope.row.lyric)">已上传</el-tag>
                            <el-tag type="danger" size="small" v-if="!checkLyric(scope.row.lyric)">无歌词</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column label="操作" align="center">
                        <template slot-scope="scope">
                            <el-button size="small" type="info" circle @click="playMusic(scope.row)" v-show="!isPlaying">
                                <i class="el-icon-video-play"></i>
                            </el-button>
                            <el-button size="small" type="danger" round size="mini" @click="deleteMusic(scope.row)">删除</el-button>
                            <el-button size="small" type="primary" round size="mini" @click="updateMusicInfo(scope.row)">编辑</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div id="pagination" v-if="musicList!=null && musicList.length>0">
                    <el-pagination background layout="prev, pager, next" :total=total :page-size="pageSize"  :current-page.sync="currentPage" @current-change="handleCurrentChange"></el-pagination>
                </div>
            </div>
        </div>
        <jsp:include page="copyright.jsp"/>
    </div>
</body>
<%--<script src="/resource/js/jquery_v3.4.1.js"></script>--%>
<%--<script src="https://unpkg.com/vue/dist/vue.js"></script>--%>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://cdn.bootcss.com/animate.css/3.7.0/animate.min.css"></script>
<script>
    new Vue({
        el: '#app',
        data: function() {
            return {
//交互
                opVisible : true,//操作面板是否可见，当从歌单面板，点击了某个歌单从而直接跳转到音乐面板时，将因此操作面板
                updateVisible : false,//编辑音乐窗口可见性
                isPlaying : false,//是否正在播放
                playingMusicName : "",//正在播放的音乐名称
                thumbVisible : false,//列表缩略图可见性
                uploadMusicVisible : false,//上传新音乐窗口可见性
                activeStep : 0,//当前上传步骤
                stepError : [true, false, false, false],//上传过程中某一步操作不符合要求，置为true
                clientEnv : "pc",
//数据域
                currentAlbumName : "",
                currentAlbum : {},

                //歌单操作，分页数据
                albumTotal : 0,
                albumTotalPage : 0,
                albumPageSize : 20,
                albumCurrentPage : 0,
                albumList : [],

                musicList : [],
                totalPage :0,
                total : 0,
                currentPage : 0,
                pageSize : 0,

                //新创建音乐对象
                defaultUpload : {
                    name : "",
                    singer : "",
                    lrcStatus : false,
                    coverStatus : false,
                    time : "",
                    musicFile : undefined,
                    lyricFile : undefined,
                    coverFile : undefined,
                },
                upload : {
                    name : "",
                    singer : "",
                    time : "",
                    albumId : undefined,
                    lrcStatus : false,
                    coverStatus : false,
                    musicFile : undefined,
                    lyricFile : undefined,
                    coverFile : undefined,
                },

                //被更新音乐对象
                defaultUpdate : {
                    name : "",
                    singer : "",
                    cover : "",
                    time : "",
                },
                update : {
                    lrcUpdate : false,
                    cover : "",
                    lyric : "",
                }
            }
        },
        watch : {
            clientEnv(nV, oV){
                if (nV=== "mobile") {
                    this.clientForbid();
                }
            }
        },
        mounted(){
            this.envListener();
            this.clientForbid();
            <c:if test="${pagination!=null}">
                this.currentPage = ${pagination.currentPage};
                this.pageSize = ${pagination.pageSize};
            </c:if>
            <c:if test="${albumId==null}">
                this.queryAlbumList(this.albumCurrentPage, this.albumPageSize);
            </c:if>
            <c:if test="${albumId!=null}">
                this.opVisible = false;
                this.currentAlbum.id = ${albumId};
                this.queryMusicList(${albumId}, this.currentPage, this.pageSize);
            </c:if>
        },
        methods : {
            <jsp:include page="$methods.jsp"/>
            checkLyric(lrc){
                const reg = new RegExp("^KK#@#@.+");
                return lrc===undefined ? false : reg.test(lrc)
            },
            getAlbumFromList(name){
                for(var index = 0; index<this.albumList.length; index++){
                    if (this.albumList[index].name === name) {
                        return this.albumList[index];
                    }
                }
                return undefined;
            },
            queryMusicList(id, currentPage, pageSize){
                const _this = this;
                $.ajax({
                    url : "/music/list",
                    data : {
                        albumId : id,
                        currentPage : currentPage,
                        pageSize : pageSize
                    },
                    success : (res)=>{
                        console.log(res);
                        if(!res.pageNotice.status){
                            this.$alert(res.pageNotice.msg, "提示：", {type : res.pageNotice.level, showClose : false});
                        }else{
                            _this.musicList = res.musicList;
                            _this.total = res.pagination.total;
                            _this.totalPage = res.pagination.totalPage;
                            _this.currentPage = res.pagination.currentPage;
                            _this.pageSize = res.pagination.pageSize;
                        }
                    },
                    error : (e)=>{
                        this.$alert("加载音乐列表失败，请稍后重试", "服务器无响应", { type : "error", showClose :false});
                    }
                });
            },
            selectAlbum(obj){
                this.currentAlbum  = this.getAlbumFromList(obj);
                this.currentPage = 1;
                this.upload.albumId = this.currentAlbum.id;
                this.queryMusicList(this.currentAlbum.id, this.currentPage, this.pageSize);
            },
            queryAlbumList(currentPage, pageSize) {
                $.ajax({
                    url: "/album/list",
                    data: {
                        currentPage: currentPage,
                        pageSize: pageSize,
                    },
                    success: (res) => {
                        if (res.status) {
                            this.$alert(res.pageNotice.msg, "提示：", {type: res.pageNotice.level})
                            return;
                        }
                        this.albumTotalPage = res.pagination.totalPage;
                        this.albumCurrentPage = res.pagination.currentPage;
                        this.albumPageSize = res.pagination.pageSize;
                        this.albumTotal = res.pagination.total;
                        this.albumList = res.albumList;
                    },
                    error: (e) => {
                        this.$alert("获取歌单列表失败，请稍后重试！", "请求失败", {type: "error", showClose: false});
                    }
                });
            },
            playMusic(music){
                this.isPlaying = true;
                this.playingMusicName = music.name;
                this.$refs.audio.src = music.file;
                this.$refs.audio.play();
            },
            stopMusic(){
                this.isPlaying = false;
                this.$refs.audio.pause();
                this.$refs.audio.src = undefined;
                this.playingMusicName = undefined;
            },
            exceed(){
                this.$alert("文件仅允许上传一个，如要更换，请先删除之前上传完成的文件。", "提示", {type : "info", showClose : false});
            },
//上传新音乐
            //上传音乐文件之前，对音乐类型，大小进行校验
            verifyMusic(file){
                if(file.type!=="audio/mp3" || file.size / 1024 / 1024 > 100 ){
                    this.stepError[0] = true;
                    this.$alert("选择的歌曲文件不符合要求，请重新选择", "提示：", { type : "error", showClose : false});
                    return false;
                }
                const arr = file.name.split("-");
                this.upload.singer = arr[0]===undefined || arr[0]=="" ? "未知歌手" : arr[0];
                this.upload.name = arr[1]===undefined || arr[1]=="" ? "未知歌曲名" : arr[1].split(".")[0];
                return true;
            },
            //移除已经上传完成的音乐文件
            removeMusic(){
                this.upload.name = this.upload.singer = this.upload.musicFile = undefined;
                this.stepError[0] = true;
            },
            //音乐文件上传成功回调
            addMusicSuccess(res){
                if (res.status) {
                    this.upload.musicFile = res.url;
                    this.stepError[0] = false;
                    this.$message({message : "歌曲文件上传完成，请继续其他操作", type : "success"});
                }else{
                    this.upload.musicFile = undefined;
                    this.stepError[0] = true;
                    this.$message({message :res.msg, type : "error", duration : 5000});
                }
            },
            //上传歌词文件之前，对歌词文件进行验证
            verifyLyric(file){
                console.log(new RegExp("^.+\.lrc$").test(file.name));
                if(!new RegExp("^.+\.[lrc|LRC]$").test(file.name) || file.size / 1024 > 512 ){
                    this.stepError[1] = true;
                    this.$alert("选择的歌词文件不符合要求，请重新选择", "提示：", { type : "error", showClose : false});
                    return false;
                }
                this.upload.lrcStatus = true;
                return true;
            },
            //移除已经上传的歌词文件
            removeLyric(){
                this.upload.lyricFile = undefined,
                this.upload.lrcStatus = this.stepError[1] = false;
            },
            //歌词文件上传成功回调
            addLrcSuccess(res){
                if (res.status) {
                    this.upload.lyricFile = res.url;
                    this.stepError[1] = false;
                    this.$message({message : "歌词文件上传完成，请继续其他操作", type : "success"});
                }else{
                    this.upload.lyricFile = undefined;
                    this.stepError[1] = true;
                    this.$message({message :res.msg, type : "error", duration : 5000});
                }
            },
            //上传封面之前，验证封面的类型以及大小
            verifyCover(file){
                if(file.type!=="image/jpeg" || file.size / 1024 / 1024 > 2 ){
                    this.stepError[2] = true;
                    this.$alert("选择的封面文件不符合要求，请重新选择", "提示：", { type : "error", showClose : false});
                    return false;
                }
                this.upload.coverStatus = true;
                return true;
            },
            //移除已经上传的封面
            removeCover(){
                this.upload.coverFile = undefined,
                this.upload.coverStatus = this.stepError[2] = false;
            },
            //封面文件上传成功回调
            addCoverSuccess(res){
                if (res.status) {
                    this.upload.coverFile = res.url;
                    this.stepError[2] = false;
                    this.$message({message : "歌曲封面文件上传完成，请继续其他操作", type : "success"});
                }else{
                    this.upload.coverFile = undefined;
                    this.stepError[2] = true;
                    this.$message({message :res.msg, type : "error", duration : 5000});
                }
            },
            //取消上传新音乐
            cancelSubmit(){
                this.upload = this.defaultUpload;
                this.upload.albumId = this.currentAlbum.id;
                this.upload.time = "";
                this.uploadMusicVisible = false;
                this.stepError = [true, false, false, false];
                this.activeStep = 0;
            },
            //上传提交新音乐信息
            submitMusic(){
                const _this = this;
                this.$refs['addMusicForm'].validate((valid) => {
                    this.stepError[3] = !valid;
                });
                for(var i=0; i<this.stepError.length; i++){
                    if(this.stepError[i]){
                        this.$alert("上传过程中的第"+(i+1)+"步不符合要求，请解决后再次提交！", "校验不通过", {type : "error", showClose : false});
                        return;
                    }
                }
                $.ajax({
                    url : "/music/new",
                    type : 'post',
                    data : {
                        singer : _this.upload.singer,
                        name : _this.upload.name,
                        time : _this.upload.time,
                        cover : _this.upload.coverFile,
                        lyric : _this.upload.lyricFile,
                        file : _this.upload.musicFile,
                        albumId : _this.upload.albumId
                    },
                    success : (res)=>{
                        if (res.status) {
                            _this.$alert(res.msg, "提示：", {type : "info", showClose : false});
                            _this.cancelSubmit();
                            //上传音乐完成自动加载最新列表，当前选择的歌单信息仍旧是旧值，不再请求最新信息，前台直接对数值+1，
                            _this.currentAlbum.musicCount++;
                            _this.queryMusicList(_this.currentAlbum.id, _this.currentPage, _this.pageSize);
                            return;
                        }
                        _this.$alert(res.msg, "提示：", {type : "error", showClose : false});
                    },
                    error : (e)=>{
                        _this.$alert("上传新音乐失败，请稍后重试", "服务器无响应", {type : "error", showClose : false});
                    }
                });
            },
//删除音乐
            deleteMusic(obj){
                const _this = this;
                this.$confirm('将从歌单内删除该音乐及其相关内容, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    console.log(obj);
                    $.ajax({
                        url : "/music/delete/"+obj.albumId+"/"+obj.id,
                        type : "post",
                        success : (res)=>{
                            this.$alert(res.msg, "提示：", {type : "info", showClose : false});
                            if (res.status) {
                                this.queryMusicList(this.currentAlbum.id, this.currentPage, this.pageSize);
                            }
                        },
                        error : (e)=>{
                            this.$alert("删除音乐失败，请稍后重试！", "服务器无响应", {type : "error", showClose : false});
                        }
                    })
                }).catch(() => {});
            },
//编辑音乐信息
            //在对应表格中点击编辑按钮，触发编辑窗口，传递被编辑的值
            updateMusicInfo(file){
                this.updateVisible = true;
                this.update = JSON.parse(JSON.stringify(file));
            },
            //编辑音乐信息面板，点击了删除歌词按钮
            lrcDelete(){
                this.$message({message : "最终提交修改后，该歌曲的歌词将被删除", type : "info"});
                this.update.lyric = "MM#@#@";
                this.update.lrcUpdate = true;
            },
            //编辑音乐信息窗口，上传图片成功回调函数
            updateImageSuccess(res){
                if (res.status) {
                    this.update.cover = res.url;
                    this.$message({message : "歌曲封面文件上传完成，请继续其他操作", type : "success"});
                }else{
                    this.$message({message :res.msg, type : "error", duration : 5000});
                }
            },
            //编辑音乐信息窗口，上传歌词成功回调函数
            updateLrcSuccess(res){
                if (res.status) {
                    this.update.lyric = res.url;
                    this.update.lrcUpdate = true;
                    this.$message({message : "歌词文件上传完成，将在最终提交之后进行解析工作", type : "success"});
                }else{
                    this.$message({
                        message :res.msg,
                        type : "error",
                        duration : 8000
                    });
                }
            },
            //放弃编辑音乐信息
            cancelUpdate(){
                this.updateVisible = false;
                this.update = this.defaultUpdate;
            },
            //提交更新音乐信息
            submitUpdate(){
                const _this = this;
                if (!this.update.lrcUpdate) {
                    this.update.lyric = undefined;
                }
                this.$refs['updateForm'].validate((valid) => {
                    if (valid) {
                        $.ajax({
                            url : "/music/update",
                            type : "post",
                            data : _this.update,
                            success : (res)=>{
                               this.$alert(res.msg, "提示：", {type : "info", showClose : false,});
                                if (res.status) {
                                    _this.updateVisible = false;
                                    _this.queryMusicList(this.currentAlbum.id, _this.currentPage, _this.pageSize);
                                }
                            },
                            error : (e)=>{
                                this.$alert("更新音乐信息失败，请稍后重试", "服务器无响应", {type : "error", showClose: false,});
                            }
                        })
                    }
                });
            },
//分页器，点击回调函数
            handleCurrentChange(val) {
                this.currentPage = val;
                this.queryMusicList(this.currentAlbum.id, this.currentPage, this.pageSize);
            },
        },
    })
</script>
</html>
