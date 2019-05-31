package com.bestbigkk.music.service.common;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.utils.SpringContextUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;

@Service
public class FileStoreService {
    private final FileStore fileStore;
    private final SpringContextUtil springContextUtil;

    @Autowired
    public FileStoreService(FileStore fileStore, SpringContextUtil springContextUtil) {
        this.fileStore = fileStore;
        this.springContextUtil = springContextUtil;
    }

    public JSONObject fileUpload(HttpServletRequest request, HttpServletResponse response, InputStream inputStream, String format){
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        jsonObject.put("status", false);

        if (inputStream == null) {
            jsonObject.put("msg", "未找到要上传的文件");
            return jsonObject;
        }

        String path = fileStore.save(inputStream, "."+format, "temp");
        if (path == null) {
            jsonObject.put("msg", "图片上传失败，请稍后重试");
            return jsonObject;
        }
        jsonObject.put("status", true);
        jsonObject.put("url", path);
        return jsonObject;
    }
}
