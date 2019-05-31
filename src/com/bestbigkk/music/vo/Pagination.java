package com.bestbigkk.music.vo;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.Serializable;

/*
* 数据分页对象
*   当由 客户端->服务器 时 currentPage表示请求第几页内容
*   当由 服务器->客户端 时 currentPage表示当前返回的内容属于第几页
*   针对当前页currentPage以及页容量pageSize 已自动完成范围校正
*
*   当设置总量total的时，必须保证已经在之正确设置了pageSIze对象，否则无法根据pageSize解析出总页数
*   在pageSIze正确设置的前提下，传入total的时候，将自动计算出总页数
*
*   在设置currentPage以及pageSize的时候，会同步设置起始范围区间startRange，该值主要用于Dao查询时，作为Limit 值传入
*   所有xxxExample类均扩展了此类，用于支持分页查询操作，主要使用到值：startRange，pageSize
*
* */
@Component
@Scope(value = "prototype")
public class Pagination implements Serializable {
    private Integer currentPage;
    private Integer pageSize;
    private Integer totalPage;
    private Integer total;
    private Integer startRange;

    @Override
    public String toString() {
        return "Pagination{" +
                "currentPage=" + currentPage +
                ", pageSize=" + pageSize +
                ", totalPage=" + totalPage +
                ", total=" + total +
                '}';
    }

    /*
    *加载一个外部分页对象到本对象，
    * 一般用于：
    *   客户端传递分页对象，校验完成之后，将分页数据传递给 xxxExample 作为分页查询条件进行Dao操作
    * */
    public void loadPagination(Pagination pagination){
        if (pagination == null) {
            return;
        }
        setCurrentPage(pagination.getCurrentPage());
        setPageSize(pagination.getPageSize());
    }

    public Integer getStartRange() {
        return startRange;
    }

    public Integer getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(Integer currentPage) {
        this.currentPage =  currentPage==null || currentPage<=0 ? 1 : currentPage;
        if (pageSize != null) {
            this.startRange = (this.currentPage-1) * pageSize;
        }
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize==null || pageSize<=0 ? 1 : pageSize;
        if (currentPage != null) {
            this.startRange = (this.currentPage-1) * pageSize;
        }
    }

    public Integer getTotalPage() {
        return totalPage;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
        if (this.pageSize == null) {
            throw new NullPointerException("pageSize can not be null!");
        }
        pageSize = pageSize==0 ? 1 : pageSize;
        this.totalPage = total%pageSize==0 ? total/pageSize : total/pageSize+1;
    }
}
