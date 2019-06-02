package com.bestbigkk.music.test;

import org.junit.Test;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Random;

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
        System.out.println(new Random().nextInt(1111)+8888+"");
    }
}
