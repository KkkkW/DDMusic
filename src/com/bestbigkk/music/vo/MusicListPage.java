package com.bestbigkk.music.vo;

import com.bestbigkk.music.domain.Music;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.List;

@Component()
@Scope(value = "prototype")
public class MusicListPage {
    @Autowired
    private Pagination pagination;
    @Autowired
    private PageNotice pageNotice;
    @Autowired
    private List musicList;

    @Override
    public String toString() {
        return "MusicListPage{" +
                "pagination=" + pagination +
                ", pageNotice=" + pageNotice +
                ", musicList=" + musicList +
                '}';
    }

    public Pagination getPagination() {
        return pagination;
    }

    public void setPagination(Pagination pagination) {
        this.pagination = pagination;
    }

    public PageNotice getPageNotice() {
        return pageNotice;
    }

    public void setPageNotice(PageNotice pageNotice) {
        this.pageNotice = pageNotice;
    }

    public List<Music> getMusicList() {
        return musicList;
    }

    public void setMusicList(List<Music> musicList) {
        this.musicList = musicList;
    }
}
