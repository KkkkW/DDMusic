package com.bestbigkk.music.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.domain.Album;
import com.bestbigkk.music.service.common.FileStoreService;
import com.bestbigkk.music.service.impl.AlbumServiceImpl;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.AlbumListPage;
import com.bestbigkk.music.vo.PageNotice;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;

@Controller
@RequestMapping(value = "/album")
public class AlbumController {
    private final AlbumServiceImpl albumService;
    private final FileStoreService fileStoreService;

    @Autowired
    public AlbumController(AlbumServiceImpl albumService, FileStoreService fileStoreService) {
        this.albumService = albumService;
        this.fileStoreService = fileStoreService;
    }

    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public AlbumListPage getAlbumList(Pagination pagination, HttpServletRequest request, HttpServletResponse response){
        return albumService.getAlbumList(pagination, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/cover", method = RequestMethod.POST)
    public JSON uploadImage(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return fileStoreService.fileUpload(request, response, file.getInputStream(), "jpg");
    }

    @ResponseBody
    @RequestMapping(method = RequestMethod.POST)
    public JSON createAlbum(Album album, HttpServletRequest request, HttpServletResponse response) {
        return albumService.createAlbumList(album, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JSON updateAlbum(Album album, HttpServletRequest request, HttpServletResponse response){
        return albumService.updateAlbum(album, request, response);
    }

    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public JSONObject deleteAlbum(Integer id, HttpServletRequest request, HttpServletResponse response) {
        return albumService.deleteAlbum(id, request, response);
    }
}
