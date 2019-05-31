package com.bestbigkk.music.test;

import com.bestbigkk.music.service.common.FileStore;
import org.junit.Test;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;

public class FileStoreTest {

    public void fun(){
        FileStore fileStore = new FileStore();
        try(
                FileInputStream fileInputStream = new FileInputStream("D:\\waterPic.png")
        ){
            String save = fileStore.save(fileInputStream, ".jpg");
            System.out.println(save);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    public void fun1(){
        FileStore fileStore = new FileStore();
        try(
            FileInputStream fileInputStream = new FileInputStream("D:\\waterPic.png")
        ){
            String save = fileStore.save(fileInputStream, ".mp4", new String[]{"v1", "v2", "v3"});
            System.out.println(save);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    @Test
    public void fun2(){
        String s = "\\static\\resources";
        String str = "E:\\Project\\IntelliJ IDEA\\music_best_big_kk\\out\\artifacts\\music_best_big_kk_war_exploded\\static\\resources\\temp\\5af2854b-5e51-4fd9-8b9b-f8e44d6262b8.jpg";
        System.out.println(str.substring(str.indexOf(s)+s.length()));
    }
}
