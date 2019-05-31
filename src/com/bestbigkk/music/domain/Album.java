package com.bestbigkk.music.domain;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Date;

@Component
@Scope(value="prototype")
public class Album implements Serializable {
    private Integer id;
    private String name;
    private String cover;
    private Date createTime;
    private Integer musicCount;

    //游客账户对该歌单对象的可见性 ： true = 可见  | false = 不可见
    // 针对管理员账户，将始终返回所有歌单对象
    private Boolean accessLevel;

    private String introduce;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover == null ? null : cover.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getMusicCount() {
        return musicCount;
    }

    public void setMusicCount(Integer musicCount) {
        this.musicCount = musicCount;
    }

    public Boolean getAccessLevel() {
        return accessLevel;
    }

    public void setAccessLevel(Boolean accessLevel) {
        this.accessLevel = accessLevel;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce == null ? null : introduce.trim();
    }

    @Override
    public String toString() {
        return "Album{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", cover='" + cover + '\'' +
                ", createTime=" + createTime +
                ", musicCount=" + musicCount +
                ", accessLevel=" + accessLevel +
                ", introduce='" + introduce + '\'' +
                '}';
    }
}