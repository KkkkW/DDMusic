package com.bestbigkk.music.service.common;

import com.bestbigkk.music.KeyStore;
import org.springframework.stereotype.Component;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

@Component
public class VerifyImage{
    private static final Integer WEIGHT = 480;
    private static final Integer HEIGHT = 120;
    private static final Color[] colors = {Color.CYAN, Color.yellow, Color.red, Color.pink, Color.white};
    private static final Random random = new Random();

    public String createVerifyImage(HttpServletRequest request, HttpServletResponse response){
        response.setContentType("image/jpeg");
        response.setDateHeader("expries", -1);
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        BufferedImage bi = new BufferedImage(WEIGHT,HEIGHT,BufferedImage.TYPE_INT_RGB);
        Graphics g = bi.getGraphics();
        setBackGround(g);
        String result = setText((Graphics2D)g);
        setRandomLine(g);
        try {
            request.getSession().setAttribute(KeyStore.imageVerifyCode, result);
            ImageIO.write(bi, "jpg", response.getOutputStream());
            return result;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    private void setBackGround(Graphics g){
        g.setColor(Color.BLACK);
        g.fillRect(0, 0, WEIGHT, HEIGHT);
    }
    private void setRandomLine(Graphics g){
        g.setColor(Color.WHITE);
        for(int a=0; a<10;a++){
            g.setColor(colors[random.nextInt(colors.length)]);
            int y1 = new Random().nextInt(HEIGHT);
            int y2 = new Random().nextInt(HEIGHT);
            g.drawLine(0, y1, WEIGHT, y2);
        }
        for(int a=0; a<25;a++) {
            g.setColor(colors[random.nextInt(colors.length)]);
            int y1 = new Random().nextInt(WEIGHT);
            int y2 = new Random().nextInt(WEIGHT);
            g.drawLine(y1, 0, y2, WEIGHT);
        }
    }
    private String setText(Graphics2D g){
        //A-Z:65~90
        //a-z:97~122
        //汉字区间：\u4e00~\u9fa5
        int x = 60;
        StringBuffer stringBuffer = new StringBuffer();
        for(int a=0;a<5;a++){
            g.setColor(colors[random.nextInt(colors.length)]);
            int c = new Random().nextInt('z'+1-'a')+'a';
            double dgree = (new Random().nextInt()%30)*3.14/180;
            g.setFont(new Font("微软雅黑",Font.ITALIC,50));
            g.rotate(dgree, x, 25);
            g.drawString((char)c+"", x, 80);
            stringBuffer.append((char)c);
            g.rotate(-dgree, x, 25);
            x+=70;
        }
        return stringBuffer+"";
    }
}
