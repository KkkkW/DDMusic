package com.bestbigkk.music.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

@Component
@RequestMapping(value = "/")
public class PageController {
    
    @RequestMapping(method = RequestMethod.GET)
    public String toIndexPage(){
        return "main";
    }

    @RequestMapping(value = "/about")
    public String toAbout(){ return "about"; }

    @RequestMapping(value = "404", method = RequestMethod.GET)
    public String to404(){ return "404"; }

    @RequestMapping(value = "50X", method = RequestMethod.GET)
    public String to50x() {
        return "50X";
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String toLogin(){ return "index"; }

}
