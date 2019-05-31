package com.bestbigkk.music.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.AppConfig;
import com.bestbigkk.music.KeyStore;
import com.bestbigkk.music.dao.AlbumMapper;
import com.bestbigkk.music.dao.MusicMapper;
import com.bestbigkk.music.domain.Album;
import com.bestbigkk.music.domain.Music;
import com.bestbigkk.music.po.AlbumExample;
import com.bestbigkk.music.po.MusicExample;
import com.bestbigkk.music.service.AlbumService;
import com.bestbigkk.music.service.common.FileStore;
import com.bestbigkk.music.service.common.RequestIdentity;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.AlbumListPage;
import com.bestbigkk.music.vo.PageNotice;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;

import static com.bestbigkk.music.KeyStore.*;

@Service
public class AlbumServiceImpl implements AlbumService{

    private final SpringContextUtil springContextUtil;
    private final RequestIdentity requestIdentity;
    private final AlbumMapper albumMapper;
    private final MusicMapper musicMapper;
    private final FileStore fileStore;
    private final MusicServiceImpl musicService;

    @Autowired
    public AlbumServiceImpl(SpringContextUtil springContextUtil, RequestIdentity requestIdentity, AlbumMapper albumMapper, MusicMapper musicMapper, FileStore fileStore, MusicServiceImpl musicService) {
        this.springContextUtil = springContextUtil;
        this.requestIdentity = requestIdentity;
        this.albumMapper = albumMapper;
        this.musicMapper = musicMapper;
        this.fileStore = fileStore;
        this.musicService = musicService;
    }

    @Override
    public AlbumListPage getAlbumList(Pagination pagination, HttpServletRequest request, HttpServletResponse response) {
        String identity = this.requestIdentity.getRequestIdentity(request);
        AlbumExample albumExample = springContextUtil.getApplicationContext().getBean("albumExample", AlbumExample.class);
        AlbumListPage albumListPage = springContextUtil.getApplicationContext().getBean("albumListPage", AlbumListPage.class);
        Pagination pg = albumListPage.getPagination();
        PageNotice pageNotice = albumListPage.getPageNotice();

        pageNotice.setLevel(PageNotice.INFO);

        if (pagination.getPageSize() == null || pagination.getCurrentPage() == null) {
            pageNotice.setMsg("未指定分页请求参数currentPage/pageSize");
            return albumListPage;
        }


        albumExample.loadPagination(pagination);
        albumExample.setOrderByClause("create_time");
        if (identity.equals(RequestIdentity.GUEST)) {
            albumExample.createCriteria().andAccessLevelEqualTo(true);
        }

        pg.setPageSize(pagination.getPageSize());
        pg.setCurrentPage(pagination.getCurrentPage());
        albumListPage.setPagination(pg);

        int albumCount = albumMapper.countByExample(albumExample);
        if(albumCount==0){
            albumListPage.setAlbumList(new ArrayList<>(0));
            pageNotice.setMsg("未查询到任何歌单信息");
            pg.setTotal(0);
            return albumListPage;
        }

        pg.setTotal(albumCount);
        List<Album> albumList = albumMapper.selectByExample(albumExample);
        albumListPage.setAlbumList(albumList);
        pageNotice.setStatus(false);
        pageNotice.setMsg("");
        albumListPage.setPageNotice(pageNotice);

        return albumListPage;
    }

    @Override
    public JSONObject createAlbumList(Album album, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        AlbumExample albumExample = springContextUtil.getApplicationContext().getBean("albumExample", AlbumExample.class);
        jsonObject.put("status", false);

        if (album == null || album.getName().length() > 16 || album.getName().length() <= 0 || album.getIntroduce().length() > 100) {
            jsonObject.put("msg", "提交的参数不合法");
            return jsonObject;
        }

        albumExample.createCriteria().andNameEqualTo(album.getName());
        List<Album> albumList = albumMapper.selectByExample(albumExample);
        if(albumList!=null && albumList.size()>0){
            jsonObject.put("msg", "已经存在一个同名的歌单，请更换名称");
            return jsonObject;
        }

        if(album.getCover()==null || album.getCover().equals("")){
            String path = AppConfig.getInstance().getDefaultImagePath();
            System.out.println(path);
            album.setCover(path);
        }else{
            if(!fileStore.exist(album.getCover())){
                jsonObject.put("msg", "提交的封面路径在服务器未找到，这说明您之前上传的图片已经失效，请重新上传");
                return jsonObject;
            }
            String move = fileStore.move(album.getCover(), "images", ".jpg");
            if (move == null) {
                jsonObject.put("msg", "封面设置失败，请稍后重新尝试建立歌单");
                return jsonObject;
            }
            album.setCover(move);
        }


        album.setCreateTime(new Date());
        album.setMusicCount(0);

        int i = albumMapper.insertSelective(album);
        if (i != 1) {
            jsonObject.put("msg", "创建歌单失败，请稍后重新建立");
            return jsonObject;
        }

        jsonObject.put("status", true);
        jsonObject.put("msg", "创建完成");
        return jsonObject;
    }

    @Override
    public JSONObject updateAlbum(Album album, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        jsonObject.put("status", false);

        if (album == null || album.getId()==null || album.getName()!=null && album.getName().length()>16 || album.getIntroduce()!=null && album.getIntroduce().length()>100) {
            jsonObject.put("msg", "提交参不符合要求，无法进行歌单的信息更新工作");
            return jsonObject;
        }

        Album aimAlbum = albumMapper.selectByPrimaryKey(album.getId());
        if (aimAlbum == null) {
            jsonObject.put("msg", "提交修改的歌单不存在，请刷新页面并重试");
            return jsonObject;
        }

        String newName = album.getName();
        if (newName != null && !newName.equals(aimAlbum.getName())) {
            AlbumExample albumExample = springContextUtil.getApplicationContext().getBean("albumExample", AlbumExample.class);
            albumExample.createCriteria().andNameEqualTo(newName);
            List<Album> albums = albumMapper.selectByExample(albumExample);
            if (albums != null && albums.size() > 0) {
                jsonObject.put("msg", "您提交的新歌单名称已经存在");
                return jsonObject;
            }
        }

        String newCover = album.getCover();
        String oldCover = aimAlbum.getCover();
        album.setCover(null);
        if (newCover != null && !newCover.equals("") && !newCover.equals(aimAlbum.getCover())) {
            if (!fileStore.exist(newCover)) {
                jsonObject.put("msg", "提交的新封面在服务器未找到，请重新上传");
                return jsonObject;
            }

            String movePath = fileStore.move(newCover, "images", ".jpg");
            if (movePath == null) {
                jsonObject.put("msg", "封面修改操作失败，歌单未成功修改，请稍后重试");
                return jsonObject;
            }
            album.setCover(movePath);

            //旧封面如果是默认图片，不删除
            Boolean deleteOldCover = oldCover!=null && oldCover.equals(AppConfig.getInstance().getDefaultImagePath());
            if (!deleteOldCover) {
                fileStore.deleteByMappingPath(oldCover);
            }
        }

        album.setCreateTime(null);
        album.setMusicCount(null);

        int result = albumMapper.updateByPrimaryKeySelective(album);
        if (result != 1) {
            jsonObject.put("msg", "歌单信息修改失败，请稍后重试");
            return jsonObject;
        }

        jsonObject.put("status", true);
        jsonObject.put("msg", "歌单信息修改完成，刷新页面可以查看修改后的信息");
        return jsonObject;

    }

    @Override
    public JSONObject deleteAlbum(Integer id, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        jsonObject.put(STATUS, false);

        if (id == null) {
            jsonObject.put(MSG, "未指定被删除歌单，请刷新页面并重试");
            return jsonObject;
        }

        Album album = albumMapper.selectByPrimaryKey(id);
        if (album == null) {
            jsonObject.put(MSG, "请求删除的歌单不存在，您可能已经在之前的某个时间进行了删除操作，请刷新页面获取最新列表");
            return jsonObject;
        }

        //歌单内存在音乐，同步删除音乐资源
        if (album.getMusicCount() != 0) {
            MusicExample musicExample = springContextUtil.getApplicationContext().getBean("musicExample", MusicExample.class);
            musicExample.createCriteria().andAlbumIdEqualTo(album.getId());
            List<Music> musicList = musicMapper.selectByExample(musicExample);

            musicService.deleteMultiple(new ConcurrentLinkedQueue<>(musicList));
        }

        //删除歌单之前需要删除所有与之相关的音乐：歌单id是作为外键存在于音乐表中的
        int delete = albumMapper.deleteByPrimaryKey(album.getId());

        if (delete != 1) {
            jsonObject.put(MSG, "歌单删除失败，请稍后重试");
            return jsonObject;
        }

        //如果歌单封面不是默认图片，删除
        String cover = album.getCover();
        if (cover != null && !cover.equals(AppConfig.getInstance().getDefaultImagePath())) {
            fileStore.deleteByMappingPath(cover);
        }

        jsonObject.put(STATUS, true);
        jsonObject.put(MSG, "删除成功，与该歌单相关的音乐资源也删除完成");
        return jsonObject;
    }
}
