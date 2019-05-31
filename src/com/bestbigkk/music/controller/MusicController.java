package com.bestbigkk.music.controller;

import com.alibaba.fastjson.JSON;
import com.bestbigkk.music.domain.Music;
import com.bestbigkk.music.service.common.FileStoreService;
import com.bestbigkk.music.service.impl.MusicServiceImpl;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.MusicListPage;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@Controller
@RequestMapping("/music")
public class MusicController {
    private final MusicServiceImpl musicService;
    private final SpringContextUtil springContextUtil;

    @Autowired
    public MusicController(MusicServiceImpl musicService, SpringContextUtil springContextUtil) {
        this.musicService = musicService;
        this.springContextUtil = springContextUtil;
    }

    @ResponseBody
    @RequestMapping(value = "/new", method = RequestMethod.POST)
    public JSON addMusic(HttpServletRequest request, HttpServletResponse response, Music music) {
        return musicService.uploadMusic(request, response, music);
    }

    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public MusicListPage queryMusicList(Integer albumId, Pagination pagination, HttpServletRequest request, HttpServletResponse response) {
         return musicService.queryMusicList(albumId, pagination, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/delete/{albumId}/{musicId}", method = RequestMethod.POST)
    public JSON deleteMusic(@PathVariable(value = "albumId") Integer albumId, @PathVariable(value = "musicId") Integer musicId, HttpServletRequest request, HttpServletResponse response){
        Music music = springContextUtil.getApplicationContext().getBean("music", Music.class);
        music.setAlbumId(albumId);
        music.setId(musicId);
        return musicService.deleteMusic(music, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JSON updateMusic(Music music, HttpServletRequest request, HttpServletResponse response) {
       return musicService.updateMusic(music, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public JSON upload(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return musicService.upload(file, request, response);
    }
}
