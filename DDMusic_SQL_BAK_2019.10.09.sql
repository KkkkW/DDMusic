/*
SQLyog Ultimate v12.3.1 (64 bit)
MySQL - 5.7.18-20170830-log : Database - music_best_big_kk
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`music_best_big_kk` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `music_best_big_kk`;

/*Table structure for table `album` */

DROP TABLE IF EXISTS `album`;

CREATE TABLE `album` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `cover` varchar(128) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `music_count` int(11) DEFAULT NULL,
  `access_level` tinyint(1) DEFAULT NULL,
  `introduce` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

/*Table structure for table `music` */

DROP TABLE IF EXISTS `music`;

CREATE TABLE `music` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `album_id` int(11) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `time` varchar(8) DEFAULT NULL,
  `singer` varchar(32) DEFAULT NULL,
  `cover` varchar(128) DEFAULT NULL,
  `file` varchar(128) DEFAULT NULL,
  `lyric` varchar(4096) DEFAULT 'MM#@#@',
  PRIMARY KEY (`id`),
  KEY `music2album` (`album_id`) USING BTREE,
  CONSTRAINT `music_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(11) NOT NULL,
  `password` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
