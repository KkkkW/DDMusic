package com.bestbigkk.music.service;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.domain.Album;
import com.bestbigkk.music.vo.AlbumListPage;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Service
public interface AlbumService {
    /*
    * 根据传递的分页信息，获取指定区间内的歌单列表
    * 如果当前请求用户非管理员，返回结果将不会包含私密歌单
    * */
    AlbumListPage getAlbumList(Pagination pagination, HttpServletRequest request, HttpServletResponse response);

    /*
    *创建一个新的歌单，需要传递：
    *  name : 歌单名称
    *  accessLevel : 访问权限
    *  introduce ： 歌单介绍
    *  cover : 提交的封面路径。该路径表示一个暂时存在于服务器的资源，如果不设置，将使用默认的图片作为封面
    * */
    JSONObject createAlbumList(Album album, HttpServletRequest request, HttpServletResponse response);

    /*
    * 更新一个歌单
    * 将以传递的id确认要修改的歌单对象
    * 可修改项：
    *   name : 名称
    *   cover : 新的封面, 该值表示一个在之前某个时间成功上传到服务器的图片资源
    *   accessLevel : 访问控制
    *   introduce : 歌单介绍
    *
    * */
    JSONObject updateAlbum(Album album, HttpServletRequest request, HttpServletResponse response);

    /*
    * 给出id确认歌单，将其删除
    * 当一个歌单被成功删除之后。所有与之相关的资源也会被移除
    *请求需要具有管理员身份
    *
    * */
    JSONObject deleteAlbum(Integer id, HttpServletRequest request, HttpServletResponse response);
}
