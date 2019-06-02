<%--
  Created by IntelliJ IDEA.
  User: 小感触
  Date: 2019/5/24
  Time: 11:35
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/resource/css/main.css"/>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/common.css"/>
    <link rel="stylesheet" type="text/css" href="/resource/css/animate.css"/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <title>DD音乐</title>
</head>
<body>
    <div id="app">
        <el-dialog title="菜单" :visible.sync="showMobileMenu" width="90%" :show-close="false" :center="true">
            <ul id="mobileMenu">
                <el-button @click="activeTag='album'; showMobileMenu=false" round>
                    <svg class="icon" aria-hidden="true">
                        <use xlink:href="#kk-tucengshunxu"></use>
                    </svg>
                    歌单列表
                </el-button>
                <el-button @click="activeTag='playlist'; showMobileMenu=false" round>
                    <svg class="icon" aria-hidden="true">
                        <use xlink:href="#kk-wenben"></use>
                    </svg>
                    播放列表
                </el-button>
                <el-button @click="activeTag='lrc; showMobileMenu=false'" round>
                    <svg class="icon" aria-hidden="true">
                        <use xlink:href="#kk-wenben_huaban"></use>
                    </svg>
                    LRC界面
                </el-button>
                <el-link href="/about" :underline="false">
                    <el-button round>
                        <svg class="icon" aria-hidden="true" >
                            <use xlink:href="#kk-guanyu"></use>
                        </svg>
                        关于应用
                    </el-button>
                </el-link>
                <el-link href="#" :underline="false">
                    <el-button round @click="showTips=!showTips; showMobileMenu=false">
                        <svg class="icon" aria-hidden="true" >
                            <use xlink:href="#kk-yichuqiapian"></use>
                        </svg>
                        <span v-show="!showTips" style="color: limegreen;">打开</span><span v-show="showTips" style="color: red">关闭</span>提示
                    </el-button>
                </el-link>
                <el-link href="http://www.bestbigkk.com" :underline="false">
                    <el-button round>
                        <svg class="icon" aria-hidden="true" >
                            <use xlink:href="#kk-as-zhuzhandian"></use>
                        </svg>
                        进入主站
                    </el-button>
                </el-link>
            </ul>
            <span slot="footer" class="dialog-footer">
                <el-button @click="showMobileMenu = false" size="mini" round type="primary">取 消</el-button>
              </span>
        </el-dialog>
        <div id="bg">
            <img  src="/resource/app-images/logo.png" v-show="music.current.cover===undefined"></img>
            <img  :src="music.current.cover" v-show="music.current.cover!==undefined"></img>
        </div>
        <div id="shade"></div>
        <header>
            <div>
                <img src="/resource/app-images/logo.png" alt="Logo">
                <span>DD音乐</span>
            </div>
            <el-button circle v-if="clientEnv==='mobile'" id="menusBtn" size="mini" @click="showMobileMenu=true">
                <svg class="icon" aria-hidden="true">
                    <use xlink:href="#kk-quanbu"></use>
                </svg>
            </el-button>
            <ul v-if="clientEnv==='pc'">
                <li>
                    <el-link :underline="false">
                        <el-button round size="small" @click="showTips=!showTips">
                            <svg class="icon" aria-hidden="true">
                                <use xlink:href="#kk-guanyu"></use>
                            </svg>
                            操作提示：已<span v-show="!showTips">关闭</span><span v-show="showTips">打开</span>
                        </el-button>
                    </el-link>
                </li>
                <el-divider direction="vertical"></el-divider>
                <li>
                    <el-link :underline="false" href="http://bestbigkk.com" target="_blank">
                        <el-button round size="small">
                            <svg class="icon" aria-hidden="true">
                                <use xlink:href="#kk-as-zhuzhandian"></use>
                            </svg>
                            进入主站
                        </el-button>
                    </el-link>
                </li>
                <el-divider direction="vertical"></el-divider>
                <li>
                    <el-link :underline="false" href="/login" target="_blank">
                        <el-button round size="small">
                            <svg class="icon" aria-hidden="true">
                                <use xlink:href="#kk-houtaiguanli"></use>
                            </svg>
                            后台登录
                        </el-button>
                    </el-link>
                </li>
                <el-divider direction="vertical"></el-divider>
                <li>
                    <el-link :underline="false" href="/about" target="_blank">
                        <el-button round size="small">
                            <svg class="icon" aria-hidden="true">
                                <use xlink:href="#kk-guanyu"></use>
                            </svg>
                            关于
                        </el-button>
                    </el-link>
                </li>
            </ul>
        </header>
        <div id="mainTabs">
            <el-tabs v-model="activeTag" :stretch="true">
                <el-tab-pane label="歌单" name="album">
<%--歌单--%>
                    <div id="albumContent">
                        <div class="empty" v-show="album.albumList==undefined || album.albumList.length==0">
                            <i class="el-icon-folder-opened"></i>
                            <el-divider></el-divider>
                            <p>暂无发布任何歌单</p>
                        </div>
                        <el-tag id="albumTips" type="info" v-show="album.albumList!=undefined && album.albumList.length>0">
                            <span>歌单总数：{{album.total}}</span>
                            <el-divider direction="vertical" v-if="album.current!==undefined"></el-divider>
                            <span v-if="album.current!==undefined">当前选择歌单：{{album.current.name}}</span>
                        </el-tag>
                        <ul v-show="album.albumList!=undefined && album.albumList.length>0" id="albumList">
                            <li v-for="item in album.albumList" @click="selectAlbum(item)">
                                <div class="albumCover">
                                    <img :src="item.cover" alt="封面">
                                </div>
                                <div class="albumInfo">
                                    <p class="albumName" :title="item.name"><i class="el-icon-collection-tag"></i>{{item.name}}</p>
                                    <p class="albumIntroduce" v-show="clientEnv==='mobile'">{{item.introduce}}</p>
                                    <el-popover placement="top-start" title="歌单简介" width="200" trigger="hover" :content="item.introduce">
                                        <p class="albumIntroduce"  slot="reference" title="歌单简介" v-show="clientEnv==='pc'"><i class="el-icon-menu"></i></p>
                                    </el-popover>
                                    <span class="albumCreateTime"  title="发布时间"><i class="el-icon-time"></i>{{new Date(item.createTime).format('yyyy-MM-dd')}}</span>
                                    <span class="albumMusicCount" title="歌单内关联音乐数量"><i class="el-icon-link" ></i>{{item.musicCount}}</span>
                                </div>
                            </li>
                        </ul>
                        <el-pagination  :hide-on-single-page=true v-show="album.albumList!=undefined && album.albumList.length>0" background layout="prev, pager, next" :total="album.total" :page-size="album.pageSize" :current-page.sync="album.currentPage"  @current-change="albumPaginationChange"></el-pagination>
                    </div>
                </el-tab-pane>
                <el-tab-pane label="播放列表" name="playlist">
<%--播放列表--%>
                    <div id="musicContent">
                        <div class="empty" v-if="music.musicList===undefined || music.musicList.length==0">
                            <i class="el-icon-folder-opened"></i>
                            <el-divider></el-divider>
                            <p>未选择歌单或该当前播放列表为空</p>
                        </div>
                        <div id="lrcContent">
                            <div id="op">
                                <el-button type="danger" size="small" round @click="clearMusicList">
                                    清空播放列表
                                </el-button>
                                <el-divider direction="vertical"></el-divider>
                                <el-tag v-if="album.current!==undefined" size="medium"><small>播放歌单：</small>{{album.current.name}}</el-tag>
                            </div>
                            <div id="cover">
                                <img src="/resource/app-images/logo.png" v-show="music.current.cover===undefined"/>
                                <img  :src="music.current.cover" v-show="music.current.cover!==undefined"/>
                            </div>
                            <ul id="lrc">
                                <p v-show="!music.current.lrcState">该曲目不包含歌词</p>
                                <div  v-show="music.current.lrcState" id="lrcs" ref="lrcContainer" style="top: 0;">
                                    <li v-for="(lrc, index) in music.current.lrcStatement" :class="[{'currentLRC' : music.current.lrcIndex===index}]">{{lrc}}</li>
                                </div>
                            </ul>
                        </div>
                        <div id="musicList">
                            <el-table v-show="music.musicList!==undefined && music.musicList.length>0" :data="music.musicList" style="width: 100%" empty-text="当前播放列表为空" >
                                <el-table-column type="index" width="50" :index="getListIndex" label="序号" align="center"></el-table-column>
                                <el-table-column prop="name" label="歌曲名"  align="center"></el-table-column>
                                <el-table-column prop="singer" label="歌手" :width="clientEnv==='pc' ? 150 : 130" align="center" ></el-table-column>
                                <el-table-column v-if="clientEnv==='pc'" prop="time" label="持续时间" width="90" align="center" ></el-table-column>
                                <el-table-column label="操作" align="center"  :width="clientEnv==='pc' ? 400 : 220">
                                    <template slot-scope="scope">
                                        <div class="musicListBtn">
                                            <el-button round type="success" size="medium"  title="暂停" @click="toPause" v-show="music.current.index===scope.$index && player.status===-1">
                                                <svg class="icon" aria-hidden="true">
                                                    <use xlink:href="#kk-zanting"></use>
                                                </svg>
                                                <small v-show="clientEnv==='pc'">
                                                    <el-divider direction="vertical" ></el-divider>
                                                    暂停
                                                </small>
                                            </el-button>

                                            <el-button round size="medium"  title="播放" @click="toAssignIndex(scope.$index)" v-show="!(music.current.index===scope.$index && player.status===-1)">
                                                <svg class="icon" aria-hidden="true">
                                                    <use xlink:href="#kk-bofang"></use>
                                                </svg>
                                                <small v-show="clientEnv==='pc'">
                                                    <el-divider direction="vertical"></el-divider>
                                                    播放
                                                </small>
                                            </el-button>

                                            <el-button round size="medium"  title="从当前播放列表移除该音乐" @click="removeMusicFromList(scope.row, scope.$index)">
                                                <svg class="icon" aria-hidden="true">
                                                    <use xlink:href="#kk-yichuqiapian"></use>
                                                </svg>
                                                <small v-show="clientEnv==='pc'">
                                                    <el-divider direction="vertical"></el-divider>
                                                    从播放列表移除
                                                </small>
                                            </el-button>

                                            <el-link :href="scope.row.file" target="_blank" :underline="false" download class="link">
                                                <el-button round  size="medium"  title="下载该音乐">
                                                    <svg class="icon" aria-hidden="true">
                                                        <use xlink:href="#kk-icon-"></use>
                                                    </svg>
                                                </el-button>
                                            </el-link>
                                        </div>
                                    </template>
                                </el-table-column>
                            </el-table>
                        </div>
                        <el-pagination :hide-on-single-page=true v-show="music.musicList!=undefined && music.musicList.length>0" background layout="prev, pager, next" :total="music.total" :page-size="music.pageSize" :current-page.sync="music.currentPage"  @current-change="musicPaginationChange"></el-pagination>
                    </div>
                </el-tab-pane>
                <el-tab-pane label="Lrc" name="lrc">
                    <div id="mainLrcContent">
                        <p v-show="!music.current.lrcState">该曲目不包含歌词</p>
                        <div v-show="music.current.lrcState"  id="mainLrcs" ref="mainLrcContainer" style="top: 0;">
                            <li v-for="(lrc, index) in music.current.lrcStatement" :class="[{'mainCurrentLRC' : music.current.lrcIndex===index}]">{{lrc}}</li>
                        </div>
                    </div>
                </el-tab-pane>
            </el-tabs>
<%--播放器--%>
            <div id="hiddenControl">
                <el-switch v-model="showControl" active-color="#13ce66" inactive-color="#ff4949"></el-switch>
            </div>
            <audio src="" ref="playerObj" style="display: none !important;"></audio>
            <div id="player" v-show="showControl">
                    <div id="control">
                        <div class="mobileControl" v-if="clientEnv==='mobile'">
                            <el-popover placement="top-start" title="播放模式" width="100" trigger="click" >
                            <div class="playModel">
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(3)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===3"></i>
                                    随机播放
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(2)" >
                                    <i class="el-icon-location-outline" v-show="c_playModel===2"></i>
                                    单曲循环
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(1)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===1"></i>
                                    循环播放
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(0)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===0"></i>
                                    顺序播放
                                </el-button>
                            </div>
                            <el-button type="success" size="mini"circle  slot="reference" v-if="clientEnv==='mobile'">
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===3">
                                    <use xlink:href="#kk-suijibofang"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===2">
                                    <use xlink:href="#kk-danquxunhuan"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===1">
                                    <use xlink:href="#kk-nongmuxunhuan"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===0">
                                    <use xlink:href="#kk-tucengshunxu"></use>
                                </svg>
                            </el-button>
                        </el-popover>
                        </div>
                        <el-button circle size="medium" title="上一曲" @click="toPrev">
                            <svg class="iconLarge" aria-hidden="true">
                                <use xlink:href="#kk-you"></use>
                            </svg>
                        </el-button>
                        <el-button circle title="播放/暂停" @click="toPlay" v-show="player.status===-2">
                            <svg class="iconLarge" aria-hidden="true" >
                                <use xlink:href="#kk-bofang"></use>
                            </svg>
                        </el-button>
                        <el-button circle title="播放/暂停" @click="toPause" v-show="player.status===-1">
                            <svg class="iconLarge" aria-hidden="true" >
                                <use xlink:href="#kk-zanting"></use>
                            </svg>
                        </el-button>
                        <el-button circle size="medium" title="下一曲" @click="toNext">
                            <svg class="iconLarge" aria-hidden="true" >
                                <use xlink:href="#kk-zuo"></use>
                            </svg>
                        </el-button>
                        <div class="mobileControl" v-if="clientEnv==='mobile'">
                            <el-popover placement="top-start" title="音量" trigger="click" >
                                <el-slider :min=0 :step="0.01" :max=1 v-model="player.volume" @change="volumeChange" :show-tooltip="clientEnv==='mobile'"></el-slider>
                                <el-button size="mini" circle slot="reference" type="danger">
                                    <svg class="iconLarge" aria-hidden="true">
                                        <use xlink:href="#kk-yinliang"></use>
                                    </svg>
                                </el-button>
                            </el-popover>
                        </div>
                    </div>
                    <div id="process">
                        <p><span>{{music.current.singer}}</span> - <span>{{music.current.name}}</span></p>
                        <p><span>{{player.process}}S</span>/<span>{{player.totalTime}}S</span></p>
                        <div @mouseenter="toggleProcessLock(false)" @mouseleave="toggleProcessLock(true)">
                            <el-slider :min="0" :max="player.totalTime" v-model="player.process" @change="processChange" :show-tooltip="false" ></el-slider>
                        </div>
                    </div>
                    <div id="operate" v-if="clientEnv==='pc'">
                        <el-link :href="music.current.file" target="_blank" :underline="false" download>
                            <el-button circle title="下载该音乐">
                                <svg class="icon" aria-hidden="true">
                                    <use xlink:href="#kk-icon-"></use>
                                </svg>
                            </el-button>
                        </el-link>
                        <el-popover placement="top-start" title="播放模式" width="100" trigger="click" >
                            <div class="playModel">
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(3)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===3"></i>
                                    随机播放
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(2)" >
                                    <i class="el-icon-location-outline" v-show="c_playModel===2"></i>
                                    单曲循环
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(1)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===1"></i>
                                    循环播放
                                </el-button>
                                <el-button size="mini" type="primary" @click="player.obj.setPlayModel(0)">
                                    <i class="el-icon-location-outline" v-show="c_playModel===0"></i>
                                    顺序播放
                                </el-button>
                            </div>
                            <el-button size="small"circle  slot="reference">
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===3">
                                    <use xlink:href="#kk-suijibofang"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===2">
                                    <use xlink:href="#kk-danquxunhuan"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===1">
                                    <use xlink:href="#kk-nongmuxunhuan"></use>
                                </svg>
                                <svg class="iconLarge" aria-hidden="true" v-show="c_playModel===0">
                                    <use xlink:href="#kk-tucengshunxu"></use>
                                </svg>
                            </el-button>
                        </el-popover>
                        <el-popover placement="top-start" title="音量" trigger="click" >
                            <el-slider :min=0 :step="0.01" :max=1 v-model="player.volume" @change="volumeChange" :show-tooltip="false"></el-slider>
                            <el-button size="small" circle slot="reference">
                                <svg class="iconLarge" aria-hidden="true">
                                    <use xlink:href="#kk-yinliang"></use>
                                </svg>
                            </el-button>
                        </el-popover>
                        <el-button size="small" circle @click="activeTag='lrc'" title="切换到LRC主界面">
                            <svg class="iconLarge" aria-hidden="true">
                                <use xlink:href="#kk-wenben"></use>
                            </svg>
                        </el-button>
                    </div>
                </div>
        </div>
    </div>
</body>
<script src="/resource/icon/iconfont.js"></script>
<%--<script src="/resource/js/jquery_v3.4.1.js"></script>--%>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="/resource/js/kutils.js"></script>
<%--<script src="https://unpkg.com/vue/dist/vue.js"></script>--%>
<script src="https://cdn.bootcss.com/vue/2.6.10/vue.min.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
        class Player {
            constructor(player) {
                this.playModel = 1;   // 0=顺序播放  |  1=循环播放 | 2=单曲循环 | 3=随机播放
                this.player = player;
                this.playList = [];
                this.playingMusicIndex = -1;
                this.status = false;
                if (this.player !== undefined) {
                    this.player.volume=0.5;
                }
            }
            getNextPlayIndex(){
                const listLength =  this.playList.length;
                if(this.playList===undefined ||listLength===0){
                    return -1;
                }
                switch(this.playModel){
                    case 0 :
                        //当前未播放
                        if(this.playingMusicIndex===-1){
                            this.playingMusicIndex = 0;
                            return 0;
                        }
                        //已经播放到列表的最后一首，顺序播放，已经到底
                        if(this.playingMusicIndex+1===listLength){
                            this.playingMusicIndex = -1;
                            return -1;
                        }
                        return ++this.playingMusicIndex;
                    case 1:
                        if(this.playingMusicIndex+1<listLength){
                            return ++this.playingMusicIndex;
                        }
                        //循环播放模式。播放到底，重新定位到列表头部
                        this.playingMusicIndex=0;
                        return 0;
                    case 2 :
                        //单曲循环，永远返回当前索引
                        return this.playingMusicIndex;
                    case 3 :
                        this.playingMusicIndex = Math.floor(Math.random()*listLength);
                        return this.playingMusicIndex;
                    default :
                        this.playingMusicIndex = -1;
                        return -1;
                }
            }
            getPrevPlayIndex(){
                const listLength =  this.playList.length;
                if(this.playList===undefined ||listLength===0){
                    return -1;
                }
                switch(this.playModel){
                    case 0 :
                        //当前未播放
                        if(this.playingMusicIndex===-1){
                            this.playingMusicIndex = 0;
                            return 0;
                        }
                        //已经播放到列表的第一首，向上无法获取
                        if(this.playingMusicIndex-1===-1){
                            this.playingMusicIndex = -1;
                            return -1;
                        }
                        return --this.playingMusicIndex;
                    case 1:
                        if(this.playingMusicIndex-1===-1){
                            this.playingMusicIndex = listLength-1;
                            return this.playingMusicIndex;
                        }
                        //循环播放模式。播放到底，重新定位到列表头部
                        return --this.playingMusicIndex;
                    case 2 :
                        //单曲循环，永远返回当前索引
                        return this.playingMusicIndex;
                    case 3 :
                        this.playingMusicIndex = Math.floor(Math.random()*listLength);
                        return this.playingMusicIndex;
                    default :
                        this.playingMusicIndex = -1;
                        return -1;
                }
            }

            assignIndex(index, callBack) {
                this.play(callBack, index);
            }
            next(callBack){
                const index = this.getNextPlayIndex();
                this.play(callBack, index);
            }
            prev(callBack){
                const index = this.getPrevPlayIndex();
                this.play(callBack, index);
            }

            play(callBack, index){
                //由上一曲下一曲点击后已经获取到了索引
                if(index!==undefined){
                    this.playingMusicIndex = index;
                    this.pause(()=>{});
                }else{
                    this.playingMusicIndex = this.playingMusicIndex===-1 ? this.getNextPlayIndex() : this.playingMusicIndex;
                }
                if (!this.status){
                    /*触发条件：
                    *1.当前播放地址不是以.mp3结尾，就重新加载播放器对象进行播放，否则认为是之前暂停了播放，需要恢复播放，而不需要重新设置播放源
                    * 2.本次方法的调用，主动传递进来了index，认为是要执行上一曲，下一曲操作，需要重新加载播放源
                    */
                    if(!new RegExp(".+\.mp3$").test(this.player.src) || index!==undefined){
                       this.player.load();
                       this.player.src = this.playList[this.playingMusicIndex].file;
                    }
                    this.player.play().then(()=>{
                        this.status = true;
                        callBack(this.playingMusicIndex);
                    }).catch((e)=>{
                        // console.log(e.message)
                        this.status = false;
                        this.playingMusicIndex=-1;
                        callBack(-3);
                    });
                }
            }
            pause(callBack){
                if(this.status){
                    this.status = false;
                    this.player.pause();
                    callBack(-2);
                }
            }

            seek(second){
                if(this.player===undefined){return;}
                this.player.currentTime = second<0 ? 0 : second;
                if(this.player.ended || this.player.paused){
                }
            }

            processListener(callBack){
                if (this.player !== undefined) {
                    this.player.addEventListener( 'timeupdate', (p)=>{
                        callBack(p);
                    });
                }
            }
            statusListener(callBack){
                this.player.addEventListener( 'play', (p)=>{
                    callBack(-1, this.playingMusicIndex);
                });
                this.player.addEventListener( 'pause', (p)=>{
                    callBack(-2, undefined);
                });
                this.player.addEventListener( 'ended', (p)=>{
                    this.next((index)=>{
                        if(index!==-2 && index!==-1){
                            callBack(-1, index);
                        }else{
                            callBack(-3, index);
                        }
                    });
                });
            }

            remove(index, callBack){
                if (index >this.playingMusicIndex) {
                    callBack(this.playingMusicIndex);
                    return;
                }
                if (index < this.playingMusicIndex) {
                    callBack(--this.playingMusicIndex);
                    return;
                }
                if(index===this.playList.length){
                    this.playingMusicIndex = -1;
                    callBack(-1);
                    return;
                }
                --this.playingMusicIndex;
                this.next((index)=>{
                    callBack(index);
                });
            }
            getPlayingMusic(){return this.playingMusic;}
            setPlayList(list){
                if (!(list instanceof Array)) {
                    this.playList = [];
                    return;
                }
                this.playList  = list;
            }
            setVolume(v){this.player.volume=v;}
            getPlayModel(){return this.playModel;}
            getStatus(){return this.status;}
            toString(){
                return this;
            }
        }
        new Vue({
            el: '#app',
            data(){
                return{
                    //交互
                    showTips : true,
                    showControl : true,//显示下方控制面板
                    activeTag : "album",  // album | playlist | lrc
                    clientEnv : "pc",  // pc : width >1024px  mobile: width<=1024  在调整窗口大小时候，自动触发
                    showMobileMenu : false,

                    player : {
                       obj : undefined,
                       status : -2, // -1=播放  -2=暂停  -3=停止
                        /*
                        *由于播放器对象实时更新进度条以显示播放进度，如果此时人工干预进行进度调整就会失败，
                        * 为了解决问题，需要引入标识，在鼠标进入到进度条范围内的时候，切断播放器与进度条的关联。
                        *当该标识为真的时候，表示播放器与滑块关联，实时更新进度
                         */
                       processLock : true,
                       process : 0,
                       totalTime : 0,
                       volume : 0.5,
                    },

                    defaultAlbum : { currentPage : 1, totalPage : 0, total : 0, pageSize : 15, albumList : [], current : undefined},
                    album:{
                        currentPage : 1,
                        totalPage : 0,
                        total : 0,
                        pageSize : 0,
                        albumList : [],
                        current : undefined,
                    },

                    defaultMusic : {currentPage : 1, totalPage: 0, total : 0, pageSize : 15, musicList : [], current : {name : "未知歌曲", singer : "未知歌手", cover : undefined, lrcState: false, lrcState : false, lrcTime : [], lrcStatement:  []}},
                    music : {
                        currentPage : 1,
                        totalPage: 0,
                        total : 0,
                        pageSize : 15,
                        musicList : [],
                        //当前正在播放的音乐对象
                        current : {
                            index : -1,//当前播放索引
                            name : "未知歌曲",
                            singer : "未知歌手",
                            cover : undefined,
                            lrcIndex : -1,//指定当前播放进度匹配到歌词的哪个索引位置, 在每次更改进度之后，都将复位到初始值-1重新匹配
                            lrcState : false,
                            lrcTime : [],
                            lrcStatement : [],
                        },
                    },
                }
            },
            methods : {
                <jsp:include page="$methods.jsp"/>
//COMMON
                showNotice(msg, noticetype, timeout){
                    if (this.clientEnv === 'pc') {
                        this.$notify({ title: '操作提示:', message: msg, position: 'bottom-left', type : noticetype});
                        return;
                    }
                    this.$message({message: msg, showClose : true, type: noticetype, duration: timeout === undefined ? 3000 : timeout});
                },
//歌单页面
                queryAlbumList(currentPage, pageSize){
                    $.ajax({
                        url : "/album/list",
                        data : {
                            currentPage : currentPage,
                            pageSize : pageSize,
                        },
                        success : (res)=>{
                            this.album.totalPage = res.pagination.totalPage;
                            this.album.currentPage = res.pagination.currentPage;
                            this.album.pageSize = res.pagination.pageSize;
                            this.album.total = res.pagination.total;
                            this.album.albumList = res.albumList;
                        },
                        error : (e)=>{
                            this.$alert("获取歌单列表失败，请稍后重试！", "请求失败", {type : "error", showClose : false});
                        }
                    });
                },
                albumPaginationChange(val){
                    this.album.currentPage = val;
                    this.queryAlbumList(this.album.currentPage, this.album.pageSize);
                },
                musicPaginationChange(val){
                    this.music.currentPage = val;
                    this.queryMusicList(this.album.current.id, this.music.currentPage, this.music.pageSize, ()=>{
                        if (this.music.musicList.length > 0 && this.showTips) {
                            this.showNotice("获取第"+val+"页音乐成功，后续播放器将自动播放当前页歌曲","success");
                        }
                    });
                },
                loadMusicFromAlbum(){
                    this.activeTag = "playlist";
                    this.music = JSON.parse(JSON.stringify(this.defaultMusic));
                    this.queryMusicList(this.album.current.id, this.music.currentPage, this.music.pageSize, ()=>{
                        if (this.music.musicList.length > 0 && this.showTips) {
                            this.showNotice("成功添加音乐到播放列表，点击音乐列表中的播放按钮可播放歌单内的音乐", "info");
                        }
                    });
                },
                selectAlbum(obj) {
                    const _this = this;
                    //点击的播放列表与正在播放的列表相同，不进行任何操作，仅切换面板
                    if(this.album.current!==undefined && this.album.current.id === obj.id){
                        this.activeTag = "playlist";
                        return;
                    }
                    this.album.current = obj;
                    if (this.music.musicList.length > 0) {
                        this.$confirm('当前播放列表不为空，继续将清空现有播放列表并加载新歌单内的音乐数据，是否继续？', '操作提示', {
                            confirmButtonText: '继续 | 加载刚才点击歌单数据',
                            cancelButtonText: '取消 | 使用之前歌单内的数据',
                            type: 'warning'
                        }).then(() => {
                            _this.loadMusicFromAlbum();
                        }).catch(() => {});
                    }else{
                        _this.loadMusicFromAlbum();
                    }
                },
//播放列表
                queryMusicList(id, currentPage, pageSize, callBack){
                    const _this = this;
                    $.ajax({
                        url : "/music/list",
                        data : {
                            albumId : id,
                            currentPage : currentPage,
                            pageSize : pageSize
                        },
                        success : (res)=>{
                            if(!res.pageNotice.status){
                                this.$alert(res.pageNotice.msg, "提示：", {type : res.pageNotice.level, showClose : false});
                            }else{
                                _this.music.musicList = res.musicList;
                                _this.music.total = res.pagination.total;
                                _this.music.totalPage = res.pagination.totalPage;
                                _this.music.currentPage = res.pagination.currentPage;
                                _this.music.pageSize = res.pagination.pageSize;
                            }
                            callBack();
                        },
                        error : (e)=>{
                            this.$alert("加载音乐列表失败，请稍后重试", "服务器无响应", { type : "error", showClose :false});
                        }
                    });
                },
                getListIndex(index){
                    return (this.music.currentPage-1) * this.music.pageSize+index+1;
                },
                removeMusicFromList(obj, index){
                    if(this.music.musicList===undefined){
                        this.showNotice("当前播放列表已经为空，无需执行移除操作", "info");
                        return;
                    }
                    if(index>this.music.musicList.length){
                        this.showNotice("操作错误，无效的音乐移除索引参数！如您不知上述语句的含义，请尝试刷新页面", "error");
                        return;
                    }
                    for(var a=index; a<this.music.musicList.length; a++){
                        if(a===this.music.musicList.length-1){
                            Vue.set(this.music.musicList, a, undefined);
                        }else{
                            Vue.set(this.music.musicList, a, this.music.musicList[a+1]);
                        }
                    }
                    this.music.musicList.length--;
                    this.player.obj.remove(index, (index)=>{
                        this.music.current.index = index;
                        this.loadMusicInfo(index);
                    });
                },
                clearMusicList() {
                    const _this = this;
                    if (this.music.musicList === undefined || this.music.musicList.length == 0) {
                        this.showNotice("当前播放列表为空，无需进行清空操作", "info");
                        return;
                    }
                    if (this.showTips) {
                        this.$confirm("清空当前播放列表并停止播放吗？您稍后可以再次选择新的歌单进行播放", '操作提示', {
                            confirmButtonText: '确定',
                            cancelButtonText: '取消',
                            type: 'warning'
                        }).then(() => {
                            _this.music.musicList = [];
                        }).catch(() => {});
                    }
                },
//播放器对象
                processChange(nV){
                    if(this.player.obj===undefined){
                        return;
                    }
                    this.music.current.lrcIndex = -1;
                    this.player.obj.seek(nV);
                },
                volumeChange(nV){
                    if(this.player.obj===undefined){return;}
                    this.player.obj.setVolume(nV);
                },
                toNext(){
                    if (this.music.musicList === undefined || this.music.musicList.length === 0) {
                        this.showNotice("当前播放列表为空，无法获取下一首音乐, 请先向播放列表添加音乐", "error");
                        return;
                    }
                    this.player.obj.next((index)=>{
                        this.loadMusicInfo(index)
                    });
                },
                toPrev(){
                    if (this.music.musicList === undefined || this.music.musicList.length === 0) {
                        this.showNotice("当前播放列表为空，无法获取下一首音乐, 请先向播放列表添加音乐", "error");
                        return;
                    }
                    this.player.obj.prev((index)=>{
                        this.loadMusicInfo(index)
                    });
                },
                toPlay(){
                    if (this.music.musicList === undefined || this.music.musicList.length === 0) {
                        this.showNotice("当前播放列表为空, 请先向播放列表添加音乐", "error");
                        return;
                    }
                    this.player.obj.play((index)=>{
                        this.loadMusicInfo(index);
                    },undefined);
                },
                toPause(){
                    if(this.player.obj.getStatus()){
                        this.player.obj.pause((status)=>{
                            this.player.status = status;
                        });
                    }
                },
                toAssignIndex(index){
                    if (this.music.musicList === undefined || this.music.musicList.length === 0) {
                        this.showNotice("当前播放列表为空，请先添加音乐到播放列表","info");
                        return;
                    }
                    if(index+1>this.music.musicList.length){
                        this.showNotice("指定的播放列表索引参数发生越界！如你不知道上述语句的含义，请尝试刷新页面", "error");
                        return;
                    }
                    const i = index === this.music.current.index ? undefined : index;
                    this.player.obj.assignIndex(i, (index)=>{
                        this.loadMusicInfo(index);
                    });
                },
                loadMusicInfo(index){
                    //歌词容器复位
                    this.music.current.lrcIndex = -1;
                    this.$refs["lrcContainer"].style.top = "0px";
                    this.$refs["mainLrcContainer"].style.top = "0px";

                    if(index===-2){
                        this.showNotice("播放失败，该音乐资源暂时不可用", "error");
                        return;
                    }
                    if (index === -1 || index===-2 || index===-3) {
                        this.music.current.name = "未知歌曲";
                        this.music.current.singer = "未知歌手";
                        this.player.totalTime = 0;
                        this.music.current = this.defaultMusic.current;
                        this.music.current.lrcState = [];
                        this.music.current.lrcTime = [];
                        this.music.current.lrcStatement = [];
                        return;
                    }
                    this.music.current = this.music.musicList[index];
                    this.music.current.index = index;
                    if(this.music.current.lyric!==undefined && new RegExp("^KK#@#@.+").test(this.music.current.lyric)){
                        const result = this.parseLrc(this.music.current.lyric);
                        this.music.current.lrcState = result[0];
                        this.music.current.lrcTime = result[1];
                        this.music.current.lrcStatement = result[2];
                    }else{
                        this.music.current.lrcState = false;
                    }
                },
                loadMusicTime(second){
                    if (second === undefined || second === 0) {
                        return "--:--";
                    }
                    if(second%60===0){
                        return second/60+":00";
                    }else{
                        return second/60+":"+second%60;
                    }
                },
                toggleProcessLock(status){
                    this.player.processLock = status;
                },
                parseLrc(lrc){
                    if(lrc===undefined){return [false];}
                    const timeAndLrc = lrc.split("#@#@");
                    var lyric = [];
                    var time = [];
                    const regx = new RegExp("^\\[.+\\].+$");
                    for(var a=0; a<timeAndLrc.length; a++){
                        if(regx.test(timeAndLrc[a])){
                            var tmp = timeAndLrc[a].split("]");
                            var t = tmp[0];
                            var l = tmp[1];
                            var strT = t.split("[")[1].split(":");
                            var minute = parseInt(strT[0]);
                            var strTT = strT[1].split(".");
                            var second = parseInt(strTT[0]);
                            var millisecond = parseInt(strTT[1]);
                            time.push(minute*60+second+(millisecond/1000));
                            lyric.push(l);
                        }
                    }
                    return [true, time, lyric];
                },
                lrcListener(p){
                    if(!this.music.current.lrcState){return;}
                    var a = this.music.current.lrcIndex===-1 ? 0 : this.music.current.lrcIndex;
                    for(; a<this.music.current.lrcTime.length; a++){
                        if(Math.abs(this.music.current.lrcTime[a]-p)<0.5){
                            this.music.current.lrcIndex = a;
                            console.info( "D："+this.music.current.lrcStatement[a]);
                            if(a>7 && a<this.music.current.lrcTime.length-1){
                                this.$refs["lrcContainer"].style.top = -25 * (a-7) +"px";
                                if(this.clientEnv==='pc'){
                                    this.$refs["mainLrcContainer"].style.top = -38 * (a-7) +"px";
                                }else{
                                    this.$refs["mainLrcContainer"].style.top = -26 * (a-7) +"px";
                                }
                            }
                        }
                        if(this.music.current.lrcTime[a]>p){
                            return;
                        }
                    }
                },
            },
            computed: {
                c_playModel(){
                    return this.player.obj===undefined ? 0 : this.player.obj.getPlayModel();
                },
            },
            watch :{
                "music.musicList" : {
                    handler(nV){
                        this.player.obj.setPlayList(this.music.musicList);
                    }
                },
                "clientEnv" : {
                    handler(nV) {
                        console.log("页面环境：" + nV);
                    }
                },
                "showTips" :{
                    handler(nV){
                        if (nV) {
                            this.$message({message : "操作提示已打开！程序将在页面给予你适当的提醒。",type : "success"})
                            return;
                        }
                        this.$message({message : "操作提示已关闭！你可以通过面板再次打开",type : "success"})
                    }
                }
             },
            mounted(){
                this.envListener((w, h)=>{
                    if(parseInt($("#mainLrcContent").css("min-height"))>=560){
                        $("#mainLrcContent").css("height", h-250+"px");
                    }
                });
                if(parseInt($("#mainLrcContent").css("min-height"))>=560){
                    $("#mainLrcContent").css("height", $(window).innerHeight()-250+"px");
                }
                this.showNotice("欢迎访问DD音乐平台，你可以通过页面顶部提供的：| 歌单 | 播放列表 | LRC | 选择你要使用的功能。", "info",6666);
                this.album.pageSize = this.clientEnv==='pc' ? 15 : 5;
                this.queryAlbumList(this.album.currentPage, this.album.pageSize);
                this.player.obj = new Player(this.$refs["playerObj"]);
                this.player.obj.processListener((p)=>{
                    if(this.player.processLock){
                        this.player.process = parseInt(p.target.currentTime.toFixed(0));
                        this.lrcListener(parseInt(p.target.currentTime.toFixed(2)));
                    }
                    this.player.totalTime = Math.floor(p.target.duration);
                });
                this.player.obj.statusListener((status, index)=>{
                    this.player.status = status;
                    if(index!==undefined){
                        this.loadMusicInfo(index);
                        if (this.clientEnv === 'mobile') {
                            this.activeTag = "lrc";
                        }
                    }
                });
            }
        });
</script>
</html>
