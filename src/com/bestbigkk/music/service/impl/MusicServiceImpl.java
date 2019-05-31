package com.bestbigkk.music.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.bestbigkk.music.AppConfig;
import com.bestbigkk.music.dao.AlbumMapper;
import com.bestbigkk.music.dao.MusicMapper;
import com.bestbigkk.music.domain.Album;
import com.bestbigkk.music.domain.Music;
import com.bestbigkk.music.po.MusicExample;
import com.bestbigkk.music.service.MusicService;
import com.bestbigkk.music.service.common.FileStore;
import com.bestbigkk.music.service.common.FileStoreService;
import com.bestbigkk.music.service.common.RequestIdentity;
import com.bestbigkk.music.utils.SpringContextUtil;
import com.bestbigkk.music.vo.MusicListPage;
import com.bestbigkk.music.vo.PageNotice;
import com.bestbigkk.music.vo.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;

import static com.bestbigkk.music.KeyStore.*;

@Service
public class MusicServiceImpl implements MusicService {
    private final SpringContextUtil springContextUtil;
    private final MusicMapper musicMapper;
    private final AlbumMapper albumMapper;
    private final FileStore fileStore;
    private final RequestIdentity requestIdentity;
    private final FileStoreService fileStoreService;

    @Autowired
    public MusicServiceImpl(SpringContextUtil springContextUtil, MusicMapper musicMapper, AlbumMapper albumMapper, FileStore fileStore, RequestIdentity requestIdentity, FileStoreService fileStoreService) {
        this.springContextUtil = springContextUtil;
        this.musicMapper = musicMapper;
        this.albumMapper = albumMapper;
        this.fileStore = fileStore;
        this.requestIdentity = requestIdentity;
        this.fileStoreService = fileStoreService;
    }

    @Override
    public JSONObject upload(MultipartFile file, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        jsonObject.put(STATUS, false);

        if (file == null) {
            jsonObject.put(MSG, "未指定上传的文件");
            return jsonObject;
        }

        String name = file.getOriginalFilename();
        String format = name.endsWith(".jpg") ? "jpg" : name.endsWith(".lrc") ? "lrc" : name.endsWith(".mp3") ? "mp3" : null;

        if (format == null) {
            jsonObject.put(MSG, "上传的文件类型不被允许，仅允许上传：JPG图片文件/LRC歌词文件/MP3音乐文件，请确认上传的文件类型");
            return jsonObject;
        }

        switch (format) {
            case "jpg" :
                if (file.getSize() > 1024 * 1024 * 2) {
                    jsonObject.put(MSG, "上传图片文件，仅允许2Mb以内的图片");
                    return jsonObject;
                }
                break;
            case "lrc":
                if (file.getSize() > 1024 * 512) {
                    jsonObject.put(MSG, "上传歌词文件，大小应控制在512Kb以内");
                    return jsonObject;
                }
                break;
            case "mp3":
                if (file.getSize() > 1024 * 1024 * 100) {
                    jsonObject.put(MSG, "上传音乐文件，大小应控制在100Mb以内");
                    return jsonObject;
                }
                break;
            default:
                jsonObject.put(MSG, "上传文件格式错误");
                return jsonObject;
        }
        try {
            return fileStoreService.fileUpload(request, response, file.getInputStream(), format);
        } catch (IOException e) {
            e.printStackTrace();
            jsonObject.put(MSG, "文件上传失败");
            return jsonObject;
        }
    }

    @Override
    public MusicListPage queryMusicList(Integer albumId, Pagination pagination, HttpServletRequest request, HttpServletResponse response) {
        MusicListPage musicListPage = springContextUtil.getApplicationContext().getBean("musicListPage", MusicListPage.class);
        MusicExample musicExample = springContextUtil.getApplicationContext().getBean("musicExample", MusicExample.class);

        PageNotice pageNotice = musicListPage.getPageNotice();
        Pagination pagePagination = musicListPage.getPagination();

        pageNotice.setStatus(false);
        pageNotice.setLevel(PageNotice.INFO);

        if (albumId == null) {
            pageNotice.setMsg("未指定要请求音乐所属的歌单ID, 请刷新页面重试");
            return musicListPage;
        }

        if (pagination.getCurrentPage() == null || pagination.getPageSize() == null) {
            pageNotice.setMsg("需要指定请求的数据区间currentPage,pageSize");
            return musicListPage;
        }
        pagePagination.setCurrentPage(pagination.getCurrentPage());
        pagePagination.setPageSize(pagination.getPageSize());

        String identity = this.requestIdentity.getRequestIdentity(request);
        Album album = albumMapper.selectByPrimaryKey(albumId);
        if (album == null || (!album.getAccessLevel()&&identity.equals(RequestIdentity.GUEST))) {
            pageNotice.setMsg("请求的歌单不存在，请刷新页面并重试");
            return musicListPage;
        }

        musicExample.setOrderByClause("id DESC");
        musicExample.createCriteria().andAlbumIdEqualTo(albumId);

        int total = musicMapper.countByExample(musicExample);
        if (total == 0) {
            pageNotice.setMsg("请求的歌单为空，不包含任何歌曲");
            return musicListPage;
        }
        pagePagination.setTotal(total);

        musicExample.loadPagination(pagePagination);
        List<Music> musicList = musicMapper.selectByExample(musicExample);

        pageNotice.setStatus(true);
        pageNotice.setLevel(PageNotice.SUCCESS);
        pageNotice.setMsg("请求音乐列表完成");

        musicListPage.setMusicList(musicList);
        return musicListPage;
    }

    @Override
    public JSONObject deleteMusic(Music music, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        MusicExample musicExample = springContextUtil.getApplicationContext().getBean("musicExample", MusicExample.class);
        jsonObject.put(STATUS, false);

        if (music == null || music.getAlbumId() == null || music.getId() == null) {
            jsonObject.put(MSG, "未指定要删除的音乐对象");
            return jsonObject;
        }

        MusicExample.Criteria criteria = musicExample.createCriteria();
        criteria.andAlbumIdEqualTo(music.getAlbumId());
        criteria.andIdEqualTo(music.getId());
        List<Music> list = musicMapper.selectByExample(musicExample);
        if (list == null || list.size() !=1) {
            jsonObject.put(MSG, "未找到被删除的音乐对象");
            return jsonObject;
        }

        Music aimMusic = list.get(0);
        String cover = aimMusic.getCover();
        String lrc = aimMusic.getLyric();
        String file = aimMusic.getFile();

        int deleteMusic = musicMapper.deleteByPrimaryKey(aimMusic.getId());
        if (deleteMusic != 1) {
            jsonObject.put(MSG, "删除歌曲失败，请稍后重试");
            return jsonObject;
        }

        Album aimAlbum = albumMapper.selectByPrimaryKey(aimMusic.getAlbumId());
        aimAlbum.setMusicCount(aimAlbum.getMusicCount()-1);
        albumMapper.updateByPrimaryKeySelective(aimAlbum);

        if (cover != null && !cover.equals(AppConfig.getInstance().getDefaultImagePath())) {
            fileStore.deleteByMappingPath(cover);
        }
        if (lrc != null) {
            fileStore.deleteByMappingPath(lrc);
        }
        if (file != null) {
            fileStore.deleteByMappingPath(file);
        }

        jsonObject.put(STATUS, true);
        jsonObject.put(MSG, "歌曲以及相关的封面，歌词均删除完成");
        return jsonObject;
    }

    @Override
    public JSONObject updateMusic(Music music, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        MusicExample musicExample = springContextUtil.getApplicationContext().getBean("musicExample", MusicExample.class);

        jsonObject.put(STATUS, false);
        if (music == null || music.getId() == null || music.getAlbumId() == null) {
            jsonObject.put(MSG, "未指定被修改的音乐");
            return jsonObject;
        }

        if (music.getName() != null && (music.getName().length() > 16 ||
                music.getName().trim().length()==0) ||
                music.getLyric() != null && music.getLyric().length() > 4096 ||
                music.getTime()!=null && music.getTime().trim().length()>8 ||
                music.getSinger()!=null && music.getSinger().trim().length()>16
        ) {
            jsonObject.put(MSG, "数据校验不通过，请确认参数是否满足以下要求：1.歌曲名称使用1-32个字符存储。2.歌词最多使用4096个字符存储。3.持续时间最多使用8个字符存储。4.歌手名称最多使用16个字符存储。");
            return jsonObject;
        }

        MusicExample.Criteria criteria = musicExample.createCriteria();
        criteria.andIdEqualTo(music.getId());
        criteria.andAlbumIdEqualTo(music.getAlbumId());
        List<Music> musicList = musicMapper.selectByExample(musicExample);
        if (musicList == null || musicList.size() == 0) {
            jsonObject.put(MSG, "未找到被修改的音乐对象");
            return jsonObject;
        }

        music.setFile(null);
        music.setAlbumId(null);
        Music aimMusic = musicList.get(0);

        String move = null;
        //上传了新封面
        if(music.getCover()!=null && !music.getCover().equals(aimMusic.getCover())){
            String newCover = music.getCover();

            if (!fileStore.exist(newCover)) {
                jsonObject.put(MSG, "音乐信息修改失败。因为提交的新封面无法在服务器被找到，该资源可能已经失效，请重试");
                return jsonObject;
            }

            move = fileStore.move(newCover, "images", "jpg");
            if (move == null) {
                jsonObject.put(MSG, "音乐信息修改失败，因为新的封面无法被正确设置");
                return jsonObject;
            }
            music.setCover(move);
        }

        Object[] objects = loadLyric(music.getLyric());
        File lrcFile = null;
        switch ((Integer) objects[0]) {
            case -1 :
                lrcFile = (File) objects[1];
                lrcFile.delete();
                jsonObject.put(MSG, "音乐信息修改失败，因为提交的新歌词无法被正常处理，这可能是因为歌词文件无法在服务器被找到，该资源可能已经失效，请稍后重试");
                return jsonObject;
            case 0 :
                music.setLyric(null);
                break;
            case 1 :
                lrcFile = (File)objects[1];
                lrcFile.delete();
                music.setLyric(objects[2]+"");
                break;
            case 2 :
                music.setLyric("MM#@#@");
        }

        Integer update = null;
        try {
            update = musicMapper.updateByPrimaryKeySelective(music);
        } catch (Exception e) {
            e.printStackTrace();
            if (move != null) {
                fileStore.deleteByMappingPath(move);
            }
            jsonObject.put(MSG, "音乐信息修改失败，请稍后重试");
            return jsonObject;
        }

        if (update != 1) {
            jsonObject.put(MSG, "音乐信息修改失败，请稍后重试");
            return jsonObject;
        }

        //信息修改完成，删除旧资源
        if (move!=null && aimMusic.getCover() != null && !aimMusic.getCover().equals(AppConfig.getInstance().getDefaultImagePath())) {
            fileStore.deleteByMappingPath(aimMusic.getCover());
        }

        jsonObject.put(STATUS, true);
        jsonObject.put(MSG, "音乐信息修改成功");
        return jsonObject;
    }

    @Override
    public JSONObject uploadMusic(HttpServletRequest request, HttpServletResponse response, Music music) {
        System.out.println(music.toString());
        JSONObject jsonObject = springContextUtil.getApplicationContext().getBean("JSONObject", JSONObject.class);
        jsonObject.put(STATUS, false);

        String name=  music.getName();
        String singer = music.getSinger();
        String time = music.getTime();
        String cover = music.getCover();
        String lyric = music.getLyric();
        String file = music.getFile();
        Integer albumId = music.getAlbumId();

        if(albumId ==null || file==null|| name ==null|| singer==null || time==null ||
                (name.trim().length()<=0 || name.trim().length()>32) ||
                (singer.trim().length()<=0 || singer.trim().length()>32) ||
                (time.trim().length()<=0 || time.trim().length()>8)
        ){
            jsonObject.put(MSG, "提交的音乐信息格式错误，请检查并重新提交");
            return jsonObject;
        }

        //文件校验
        if(!fileStore.exist(file)){
            jsonObject.put(MSG, "提交音乐信息失败，因为在服务器未找到对应的音乐文件，这可能是因为在之前的某个时间该资源被删除或成功上传, 请重试");
            return jsonObject;
        }
        if(cover!=null){
            if (!fileStore.exist(cover)) {
                jsonObject.put(MSG, "提交音乐信息失败，因为在服务器未找到对应的封面文件，这可能是因为在之前的某个时间该资源被删除或成功上传, 请重试");
                return jsonObject;
            }
        }else {
            music.setCover(AppConfig.getInstance().getDefaultImagePath());
        }
        if(lyric!=null){
            if (!fileStore.exist(lyric)) {
                jsonObject.put(MSG, "提交音乐信息失败，因为在服务器未找到对应的歌词文件，这可能是因为在之前的某个时间该资源被删除或成功上传, 请重试");
                return jsonObject;
            }
            Object[] objects = loadLyric(lyric);
            File lrcFile;
            switch ((Integer) objects[0]) {
                case -1 :
                    lrcFile = (File) objects[1];
                    lrcFile.delete();
                    jsonObject.put(MSG, "提交音乐信息失败，因为提交的新歌词无法被正常处理，这可能是因为歌词文件无法在服务器被找到，该资源可能已经失效，请稍后重试");
                    return jsonObject;
                case 0 :
                    music.setLyric(null);
                    break;
                case 1 :
                    lrcFile = (File)objects[1];
                    lrcFile.delete();
                    music.setLyric(objects[2]+"");
                    break;
                case 2 :
                    music.setLyric("MM#@#@");
            }
        }else{
            music.setLyric("MM#@#@");
        }

        Album aimAlbum = albumMapper.selectByPrimaryKey(albumId);
        if (aimAlbum == null) {
            jsonObject.put(MSG, "歌曲所属的歌单不存在，请先创建该歌单并重试");
            return jsonObject;
        }

        //持久化文件
        String musicFileMoved = fileStore.move(file, "music", "mp3");
        String coverFileMoved = null;
        if (cover != null) {
            coverFileMoved = fileStore.move(cover, "images", "jpg");
        }
        if (musicFileMoved == null || cover!=null && coverFileMoved == null) {
            if(musicFileMoved!=null){
                fileStore.deleteByMappingPath(musicFileMoved);
            }
            if (coverFileMoved != null) {
                fileStore.deleteByMappingPath(coverFileMoved);
            }
            jsonObject.put(MSG, "音乐上传失败，因为提交的音乐文件或封面文件无法被正常处理，请稍后重试");
            return jsonObject;
        }
        music.setCover(coverFileMoved==null ? AppConfig.getInstance().getDefaultImagePath() :coverFileMoved);
        music.setFile(musicFileMoved);

        aimAlbum.setMusicCount(aimAlbum.getMusicCount() + 1);
        int i = albumMapper.updateByPrimaryKeySelective(aimAlbum);
        if (i != 1) {
            jsonObject.put(MSG, "音乐上传失败，无法更新所属歌单的音乐数量，请稍后重试");
            return jsonObject;
        }
        int insert = musicMapper.insertSelective(music);
        if (insert != 1) {
            if (musicFileMoved != null) {
                fileStore.deleteByMappingPath(musicFileMoved);
            }
            if (coverFileMoved != null) {
                fileStore.deleteByMappingPath(coverFileMoved);
            }
            jsonObject.put(MSG, "上传音乐失败，请稍后重试");
            return jsonObject;
        }
        jsonObject.put(STATUS, true);
        jsonObject.put(MSG, "歌曲提交完成，刷新页面可查看最新结果");

        return jsonObject;
    }

    @Override
    public Integer deleteMultiple(ConcurrentLinkedQueue<Music> musics) {
        class Deleter implements Runnable{
            @Override
            public void run() {
                while (!musics.isEmpty()) {
                    Music music = musics.poll();
                    if(music.getCover()!=null && !music.getCover().equals(AppConfig.getInstance().getDefaultImagePath())){
                        fileStore.deleteByMappingPath(music.getCover());
                    }
                    if (music.getFile() != null) {
                        fileStore.deleteByMappingPath(music.getFile());
                    }
                }
            }
        }
        if (musics == null) {
            throw new NullPointerException();
        }

        MusicExample musicExample = springContextUtil.getApplicationContext().getBean("musicExample", MusicExample.class);
        Iterator<Music> iterator = musics.iterator();
        while (iterator.hasNext()) {
            musicExample.or().andIdEqualTo(iterator.next().getId());
        }
        int delete = musicMapper.deleteByExample(musicExample);
        if (delete != musics.size()) {
            return delete;
        }

        //目标音乐资源均已经删除，开始删除具体文件
        int num = musics.size()/50 + 1;
        num = num>10 ? 10 : num;
        for (int i = 0; i < num; i++) {
            new Thread(new Deleter(), "歌曲批量删除线程" + i).start();
        }
        return delete;
    }

    // 给出歌词文件的映射路径，读取文件中的歌词信息
    private Object[] loadLyric(String lrcMappingPath){
        if (lrcMappingPath != null && lrcMappingPath.equals("MM#@#@")) {
            //处理结果为2，表示歌词需要设置为空，此时没有歌词文件以及读取到的歌词信息
            return new Object[]{2};
        }
        if(lrcMappingPath!=null && lrcMappingPath.startsWith(fileStore.getPrefixMappingPath()) && lrcMappingPath.endsWith(".lrc")) {
            //如果歌曲不包含歌词，我们约定该音乐对象的歌词以MM#@#@开头，否则以KK#@#@开头
            StringBuilder stringBuilder = new StringBuilder("KK#@#@");
            File lrcFile = fileStore.toAbsolutePath(lrcMappingPath);
            try (
                    FileInputStream fileInputStream = new FileInputStream(lrcFile);
                    InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            ){
                while (bufferedReader.ready()) {
                    stringBuilder.append(bufferedReader.readLine()+"#@#@");
                }
                //处理结果为1，表示设置新歌词，并返回定位到的歌词文件lrcFile，以及读取到的歌词信息
                return new Object[]{1, lrcFile, stringBuilder+""};
            } catch (Exception e) {
                //处理结果为-1，表示读取歌词出错，返回歌词文件对象便于外部后续操作
                return new Object[]{-1, lrcFile};
            }
        }else{
            //处理结果为0，表示不对歌词进行更改，保持原先歌词不变
            return new Object[]{0};
        }
    }
}
