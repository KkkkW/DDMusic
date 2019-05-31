package com.bestbigkk.music.service;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.domain.Music;
import com.bestbigkk.music.vo.MusicListPage;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.concurrent.ConcurrentLinkedQueue;

@Service
public interface MusicService {

    /*
    * 上传文件到服务器。返回上传结果
    *
    * 该方法仅接收满足以下条件的文件：
    *   1.格式为LRC 最大大小512KB
    *   2.格式为JPG 最大大小为2MB
    *   3.格式为MP3 最大大小为5MB
    * */
    JSONObject upload(MultipartFile file, HttpServletRequest request, HttpServletResponse response);


    /*
    * 根据传递的歌单id以及分页信息
    *
    * 获取指定分页区间内的歌曲信息
    *
    * 如果请求身份不是管理员，且被请求歌单未加密歌单
    *
    * 则不返回任何歌曲信息。在返回结果的pageNotice中会进行说明，页面此时用该信息进行提示
    *
    * */
    MusicListPage queryMusicList(Integer albumId, Pagination pagination, HttpServletRequest request, HttpServletResponse response);

    /*
    * 删除一个音乐对象，同时更新所属歌单的音乐数量
    *
    * 返回执行结果
    * */
    JSONObject deleteMusic(Music music, HttpServletRequest request, HttpServletResponse response);

    /*
    * 根据id确认被修改的音乐对象
    * 可修改项包含：
    *   name : 歌曲名
    *   singer：歌手名
    *   time : 持续时间
    *   lyric : 歌词文件
    *   cover : 封面文件
    *
    *   其余项目不可更改
    * */
    JSONObject updateMusic(Music music, HttpServletRequest request, HttpServletResponse response);

    /*
    * 删除给定列表中的所有音乐对象，
    * 该方法执行前默认调用者已经进行了所有的必要检查。
    * 所以该方法不会进行任何的校验措施而是直接进行删除操作。
    * 最终返回成功删除的个数
    * */
    Integer deleteMultiple(ConcurrentLinkedQueue<Music> musics);

    /*
    * 上传新音乐到歌单
    *
    * */
    JSONObject uploadMusic(HttpServletRequest request, HttpServletResponse response, Music music);
}
