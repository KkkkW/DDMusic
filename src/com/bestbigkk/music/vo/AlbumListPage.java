package com.bestbigkk.music.vo;

import com.bestbigkk.music.domain.Album;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.List;

@Component
@Scope(value="prototype")
public class AlbumListPage implements Serializable{
    @Autowired
    private PageNotice pageNotice;
    @Autowired
    private Pagination pagination;
    @Autowired
    private List AlbumList;

    @Override
    public String toString() {
        return "AlbumListPage{" +
                "pageNotice=" + pageNotice +
                ", AlbumList=" + AlbumList +
                ", pagination=" + pagination +
                '}';
    }

    public PageNotice getPageNotice() {
        return pageNotice;
    }

    public void setPageNotice(PageNotice pageNotice) {
        this.pageNotice = pageNotice;
    }

    public List<Album> getAlbumList() {
        return AlbumList;
    }

    public void setAlbumList(List<Album> albumList) {
        AlbumList = albumList;
    }

    public Pagination getPagination() {
        return pagination;
    }

    public void setPagination(Pagination pagination) {
        this.pagination = pagination;
    }
}
