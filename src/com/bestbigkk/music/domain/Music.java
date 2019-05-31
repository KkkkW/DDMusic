package com.bestbigkk.music.domain;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value="prototype")
public class Music {
    private Integer id;

    private Integer albumId;

    private String name;

    private String time;

    private String singer;

    private String cover;

    private String file;

    private String lyric;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Integer albumId) {
        this.albumId = albumId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time == null ? null : time.trim();
    }

    public String getSinger() {
        return singer;
    }

    public void setSinger(String singer) {
        this.singer = singer == null ? null : singer.trim();
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover == null ? null : cover.trim();
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file == null ? null : file.trim();
    }

    public String getLyric() {
        return lyric;
    }

    public void setLyric(String lyric) {
        this.lyric = lyric == null ? null : lyric.trim();
    }

    @Override
    public String toString() {
        return "Music{" +
                "id=" + id +
                ", albumId=" + albumId +
                ", name='" + name + '\'' +
                ", time='" + time + '\'' +
                ", singer='" + singer + '\'' +
                ", cover='" + cover + '\'' +
                ", file='" + file + '\'' +
                ", lyric='" + lyric + '\'' +
                '}';
    }
}