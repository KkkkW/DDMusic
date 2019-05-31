package com.bestbigkk.music.service.common;

import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.security.InvalidParameterException;
import java.util.UUID;

public class FileStore{
    private final String SEPARATOR = "/";
    @Autowired
    private ServletContext servletContext;
    private String prefixMappingPath;
    private String resourceRootPath;
    private File resourceRootFile;

    private boolean transfer(InputStream inputStream, File dstFile){
        try(
            FileOutputStream fos = new FileOutputStream(dstFile);
        ){
            inputStream.transferTo(fos);
            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public boolean exist(String mappingPath){
        File absolutePath = toAbsolutePath(mappingPath);
        return absolutePath.exists();
    }

    public String move(String sourceMappingPath, String dstSubDir, String format) {
       return move(sourceMappingPath, dstSubDir, format, true);
    }

    public String move(String sourceMappingPath, String dstSubDir, String format, Boolean deleteSource) {
        if (sourceMappingPath == null || dstSubDir == null) {
            throw new NullPointerException();
        }

        File source = toAbsolutePath(sourceMappingPath);
        File dstDir = toAbsolutePath(dstSubDir);

        if (source.isDirectory() || dstDir.isFile()) {
            throw new InvalidParameterException();
        }

        if(!dstDir.exists()){
            dstDir.mkdirs();
        }

        String fileName = UUID.randomUUID().toString()+(format.startsWith(".") ? format : "."+format);
        File dstFile = new File(dstDir, fileName);
        String path = null;
        try(
            FileInputStream fis = new FileInputStream(source);
        ){
            if(transfer(fis, dstFile)){
                path = toMappingPath(dstFile.getAbsolutePath());
            }
        }catch (Exception e){
            return path;
        }

        if (deleteSource) {
            deleteByAbsolutePath(source.getAbsolutePath());
        }
        return path;
    }

    public String save(InputStream inputStream, String format) {
        if (inputStream == null) {
            throw new NullPointerException("输入流对象不存在");
        }
        if (resourceRootFile == null) {
            initResourceRootFile();
        }
        String fileName = UUID.randomUUID().toString()+(format.startsWith(".") ? format : "."+format);
        if (!resourceRootFile.exists()) {
            resourceRootFile.mkdirs();
        }
        File dstFile = new File(resourceRootFile, fileName);
        if(transfer(inputStream, dstFile)){
            return toMappingPath(fileName);
        }
        return null;
    }

    public String save(InputStream inputStream, String format, String...subPath) {
        if (inputStream == null) {
            throw new NullPointerException("输入流对象不存在");
        }
        if (resourceRootFile == null) {
            initResourceRootFile();
        }
        String fileName = UUID.randomUUID().toString()+(format.startsWith(".") ? format : "."+format);
        String sub = "";
        for (String dir : subPath) {
            sub = sub + SEPARATOR + dir;
        }
        File dstDir = new File(resourceRootFile, sub);
        if (!dstDir.exists()) {
            dstDir.mkdirs();
        }
        File dstFile = new File(dstDir, fileName);
        if(transfer(inputStream, dstFile)){
            return toMappingPath(sub+SEPARATOR+fileName);
        }
        return null;
    }

    public boolean deleteByMappingPath(String mappingPath) {
        File file = toAbsolutePath(mappingPath);
        return deleteByAbsolutePath(file.getAbsolutePath());
    }

    public boolean deleteByAbsolutePath(String absolutePath){
        if (absolutePath == null) {
            throw new NullPointerException();
        }
        File file = new File(absolutePath);
        if(file.isDirectory()){
            return false;
        }
        return file.delete();
    }

    private void initResourceRootFile(){
        resourceRootFile = new File(servletContext.getRealPath("/"), resourceRootPath);
    }

    public String toMappingPath(String path){
        if (path == null) {
            return null;
        }
        if(path.contains(resourceRootPath)){
            String substring = path.substring(path.indexOf(resourceRootPath)+resourceRootPath.length());
            return prefixMappingPath+substring;
        }
        return prefixMappingPath + (path.startsWith(SEPARATOR) ? path : SEPARATOR+ path);
    }

    public File toAbsolutePath(String mappingPath) {
        if (mappingPath == null) {
            return null;
        }
        if (resourceRootFile == null) {
            initResourceRootFile();
        }
        if(mappingPath.contains(prefixMappingPath)){
            mappingPath = mappingPath.substring(prefixMappingPath.length());
            return new File(resourceRootFile, mappingPath);
        }
        return new File(resourceRootFile, mappingPath);
    }

    public String getPrefixMappingPath() {
        return prefixMappingPath;
    }

    public void setPrefixMappingPath(String prefixMappingPath) {
        this.prefixMappingPath = prefixMappingPath;
    }

    public String getResourceRootPath() {
        return resourceRootPath;
    }

    public void setResourceRootPath(String resourceRootPath) {
        this.resourceRootPath = resourceRootPath;
    }

    public ServletContext getServletContext() {
        return servletContext;
    }

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
}
