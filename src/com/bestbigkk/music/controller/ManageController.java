package com.bestbigkk.music.controller;

import com.bestbigkk.music.service.impl.AccountServiceImpl;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
@RequestMapping(value = "/manage")
public class ManageController {

    private final SpringContextUtil springContextUtil;
    private final AccountServiceImpl accountService;

    @Autowired
    public ManageController(SpringContextUtil springContextUtil, AccountServiceImpl accountService) {
        this.springContextUtil = springContextUtil;
        this.accountService = accountService;
    }

    @RequestMapping("/album-list")
    public ModelAndView adminAlbumManage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ModelAndView modelAndView = new ModelAndView();
        Pagination pagination = springContextUtil.getApplicationContext().getBean("pagination", Pagination.class);

        pagination.setCurrentPage(1);
        pagination.setPageSize(10);

        modelAndView.addObject("pagination", pagination);
        modelAndView.setViewName("albumList");

        return modelAndView;
    }

    @RequestMapping(value = "/account")
    public ModelAndView adminAccountManage(HttpServletRequest request, HttpServletResponse response){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("account");

        AccountPage accountPage = accountService.getAccountInfo(request, response);
        modelAndView.addObject("accountPage", accountPage);
        return modelAndView;
    }

    @RequestMapping(value = "/music-list")
    public ModelAndView adminMusicManage(HttpServletRequest request, HttpServletResponse response, Integer albumId){
        ModelAndView modelAndView = new ModelAndView();
        Pagination pagination = springContextUtil.getApplicationContext().getBean("pagination", Pagination.class);

        pagination.setCurrentPage(1);
        pagination.setPageSize(20);

        if (albumId != null) {
            modelAndView.addObject("albumId", albumId);
        }

        modelAndView.addObject("pagination", pagination);
        modelAndView.setViewName("musicList");
        return modelAndView;
    }
}
