package com.bestbigkk.music.test;

import org.junit.Test;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

public class CommonTest {
    @Test
    public void fun() throws InterruptedException{
        File file = new File("D:\\lrc.txt");
        try(
                FileReader fileReader = new FileReader(file);
        ){
            StringBuilder sb = new StringBuilder();
            int len;
            char[] buff = new char[2048];
            while (fileReader.ready()) {
                len = fileReader.read(buff);
                System.out.println(new String(buff, 0, len));
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void fun1() throws Exception{
//        FileReader fileReader = new FileReader(new File("D:\\2.lrc"));
//        BufferedReader bufferedReader = new BufferedReader(fileReader);
//        while (bufferedReader.ready()) {
//            System.out.println(bufferedReader.readLine());
//        }
//        bufferedReader.close();
//        fileReader.close();
        String s = "[00:06.166]#@#@#[00:16.793]作曲 : 许嵩#@#@#[00:26.201]作词 : 许嵩#@#@#[00:34.220]你走之后 一个夏季熬成一个秋#@#@#[00:37.298]我的书上你的正楷眉清目秀#@#@#[00:40.753]一字一字宣告我们和平分手#@#@#[00:44.440]好委婉的交流 还带一点征求#@#@#[00:47.778]你已成风 幻化的雨下错了季候#@#@#[00:50.823]明媚的眼眸里温柔化为了乌有#@#@#[00:54.320]一层一层院墙把你的心困守#@#@#[00:57.959]如果没法回头 这样也没不妥#@#@#[01:01.271]你的城府有多深#@#@#[01:04.629]我爱的有多蠢 是我太笨#@#@#[01:08.528]还是太认真 幻想和你过一生#@#@#[01:14.812]你的城府有多深#@#@#[01:18.145]我爱的有多蠢 不想再问#@#@#[01:22.230]也无法去恨 毕竟你是我最爱的人#@#@#[01:31.748]曾经你的眼神 看起来那么单纯#@#@#[01:35.177]嗯 指向你干净的灵魂#@#@#[01:38.134]什么时候开始变得满是伤痕#@#@#[01:41.913]戴上假面也好 如果不会疼#@#@#[01:45.252]爱情这个世界 有那么多的悖论#@#@#[01:48.655]小心翼翼不见得就会获得满分#@#@#[01:51.847]我们之间缺少了那么多信任#@#@#[01:55.439]最后还是没有 打开那扇心门#@#@#[01:58.783]你的城府有多深#@#@#[02:02.140]我爱的有多蠢 是我太笨#@#@#[02:06.177]还是太认真 幻想和你过一生#@#@#[02:12.306]你的城府有多深#@#@#[02:15.659]我爱的有多蠢 不想再问#@#@#[02:19.788]也无法去恨 毕竟你是我最爱的人#@#@#[02:29.611]我曾经苦笑着问过我自己#@#@#[02:35.513]在某个夜里 卸下伪装的你#@#@#[02:38.535]是不是也会哭泣#@#@#[02:42.732]你的城府有多深#@#@#[02:46.067]我爱的有多蠢 是我太笨#@#@#[02:50.150]还是太认真 幻想和你过一生#@#@#[02:56.180]你的城府有多深#@#@#[02:59.513]我爱的有多蠢 不想再问#@#@#[03:03.648]也无法去恨 毕竟你是爱过我的人#@#@#[03:14.6";
        System.out.println(s.length());
    }
}
