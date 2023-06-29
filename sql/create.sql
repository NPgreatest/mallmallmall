-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mall
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `oneforallmall_admin_user`
--

DROP TABLE IF EXISTS `oneforallmall_admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_admin_user` (
  `admin_user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '管理员id',
  `login_user_name` varchar(50) NOT NULL COMMENT '管理员登陆名称',
  `login_password` varchar(50) NOT NULL COMMENT '管理员登陆密码',
  `nick_name` varchar(50) NOT NULL COMMENT '管理员显示昵称',
  `locked` tinyint DEFAULT '0' COMMENT '是否锁定 0未锁定 1已锁定无法登陆',
  PRIMARY KEY (`admin_user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_admin_user_token`
--

DROP TABLE IF EXISTS `oneforallmall_admin_user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_admin_user_token` (
  `admin_user_id` bigint NOT NULL COMMENT '用户主键id',
  `token` varchar(32) NOT NULL COMMENT 'token值(32位字符串)',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `expire_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'token过期时间',
  PRIMARY KEY (`admin_user_id`),
  UNIQUE KEY `uq_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_carousel`
--

DROP TABLE IF EXISTS `oneforallmall_carousel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_carousel` (
  `carousel_id` int NOT NULL AUTO_INCREMENT COMMENT '首页轮播图主键id',
  `carousel_url` varchar(100) NOT NULL DEFAULT '' COMMENT '轮播图',
  `redirect_url` varchar(100) NOT NULL DEFAULT '''##''' COMMENT '点击后的跳转地址(默认不跳转)',
  `carousel_rank` int NOT NULL DEFAULT '0' COMMENT '排序值(字段越大越靠前)',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` int NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `update_user` int NOT NULL DEFAULT '0' COMMENT '修改者id',
  PRIMARY KEY (`carousel_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_goods_category`
--

DROP TABLE IF EXISTS `oneforallmall_goods_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_goods_category` (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `category_level` tinyint NOT NULL DEFAULT '0' COMMENT '分类级别(1-一级分类 2-二级分类 3-三级分类)',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父分类id',
  `category_name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `category_rank` int NOT NULL DEFAULT '0' COMMENT '排序值(字段越大越靠前)',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` int NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `update_user` int DEFAULT '0' COMMENT '修改者id',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_goods_info`
--

DROP TABLE IF EXISTS `oneforallmall_goods_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_goods_info` (
  `goods_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '商品表主键id',
  `goods_name` varchar(200) NOT NULL DEFAULT '' COMMENT '商品名',
  `goods_intro` varchar(200) NOT NULL DEFAULT '' COMMENT '商品简介',
  `goods_category_id` bigint NOT NULL DEFAULT '0' COMMENT '关联分类id',
  `goods_cover_img` varchar(200) NOT NULL DEFAULT '/admin/dist/img/no-img.png' COMMENT '商品主图',
  `goods_carousel` varchar(500) NOT NULL DEFAULT '/admin/dist/img/no-img.png' COMMENT '商品轮播图',
  `goods_detail_content` text NOT NULL COMMENT '商品详情',
  `original_price` int NOT NULL DEFAULT '1' COMMENT '商品价格',
  `selling_price` int NOT NULL DEFAULT '1' COMMENT '商品实际售价',
  `stock_num` int unsigned NOT NULL DEFAULT '0' COMMENT '商品库存数量',
  `tag` varchar(20) NOT NULL DEFAULT '' COMMENT '商品标签',
  `goods_sell_status` tinyint NOT NULL DEFAULT '0' COMMENT '商品上架状态 1-下架 0-上架',
  `create_user` int NOT NULL DEFAULT '0' COMMENT '添加者主键id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商品添加时间',
  `update_user` int NOT NULL DEFAULT '0' COMMENT '修改者主键id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商品修改时间',
  PRIMARY KEY (`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10904 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_index_config`
--

DROP TABLE IF EXISTS `oneforallmall_index_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_index_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '首页配置项主键id',
  `config_name` varchar(50) NOT NULL DEFAULT '' COMMENT '显示字符(配置搜索时不可为空，其他可为空)',
  `config_type` tinyint NOT NULL DEFAULT '0' COMMENT '1-搜索框热搜 2-搜索下拉框热搜 3-(首页)热销商品 4-(首页)新品上线 5-(首页)为你推荐',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '商品id 默认为0',
  `redirect_url` varchar(100) NOT NULL DEFAULT '##' COMMENT '点击后的跳转地址(默认不跳转)',
  `config_rank` int NOT NULL DEFAULT '0' COMMENT '排序值(字段越大越靠前)',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` int NOT NULL DEFAULT '0' COMMENT '创建者id',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最新修改时间',
  `update_user` int DEFAULT '0' COMMENT '修改者id',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_order`
--

DROP TABLE IF EXISTS `oneforallmall_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单表主键id',
  `order_no` varchar(20) NOT NULL DEFAULT '' COMMENT '订单号',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户主键id',
  `total_price` int NOT NULL DEFAULT '1' COMMENT '订单总价',
  `pay_status` tinyint NOT NULL DEFAULT '0' COMMENT '支付状态:0.未支付,1.支付成功,-1:支付失败',
  `pay_type` tinyint NOT NULL DEFAULT '0' COMMENT '0.无 1.支付宝支付 2.微信支付',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `order_status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态:0.待支付 1.已支付 2.配货完成 3:出库成功 4.交易成功 -1.手动关闭 -2.超时关闭 -3.商家关闭',
  `extra_info` varchar(100) NOT NULL DEFAULT '' COMMENT '订单body',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最新修改时间',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_order_address`
--

DROP TABLE IF EXISTS `oneforallmall_order_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_order_address` (
  `order_id` bigint NOT NULL,
  `user_name` varchar(30) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `user_phone` varchar(11) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `province_name` varchar(32) NOT NULL DEFAULT '' COMMENT '省',
  `city_name` varchar(32) NOT NULL DEFAULT '' COMMENT '城',
  `region_name` varchar(32) NOT NULL DEFAULT '' COMMENT '区',
  `detail_address` varchar(64) NOT NULL DEFAULT '' COMMENT '收件详细地址(街道/楼宇/单元)',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='订单收货地址关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_order_item`
--

DROP TABLE IF EXISTS `oneforallmall_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_order_item` (
  `order_item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单关联购物项主键id',
  `order_id` bigint NOT NULL DEFAULT '0' COMMENT '订单主键id',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `goods_name` varchar(200) NOT NULL DEFAULT '' COMMENT '下单时商品的名称(订单快照)',
  `goods_cover_img` varchar(200) NOT NULL DEFAULT '' COMMENT '下单时商品的主图(订单快照)',
  `selling_price` int NOT NULL DEFAULT '1' COMMENT '下单时商品的价格(订单快照)',
  `goods_count` int NOT NULL DEFAULT '1' COMMENT '数量(订单快照)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`order_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_shopping_cart_item`
--

DROP TABLE IF EXISTS `oneforallmall_shopping_cart_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_shopping_cart_item` (
  `cart_item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物项主键id',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `goods_count` int NOT NULL DEFAULT '1' COMMENT '数量(最大为5)',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最新修改时间',
  PRIMARY KEY (`cart_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_user`
--

DROP TABLE IF EXISTS `oneforallmall_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户主键id',
  `nick_name` varchar(50) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `login_name` varchar(11) NOT NULL DEFAULT '' COMMENT '登陆名称(默认为手机号)',
  `password_md5` varchar(32) NOT NULL DEFAULT '' COMMENT 'MD5加密后的密码',
  `introduce_sign` varchar(100) NOT NULL DEFAULT '' COMMENT '个性签名',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '注销标识字段(0-正常 1-已注销)',
  `locked_flag` tinyint NOT NULL DEFAULT '0' COMMENT '锁定标识字段(0-未锁定 1-已锁定)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_user_address`
--

DROP TABLE IF EXISTS `oneforallmall_user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_user_address` (
  `address_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户主键id',
  `user_name` varchar(30) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `user_phone` varchar(11) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `default_flag` tinyint NOT NULL DEFAULT '0' COMMENT '是否为默认 0-非默认 1-是默认',
  `province_name` varchar(32) NOT NULL DEFAULT '' COMMENT '省',
  `city_name` varchar(32) NOT NULL DEFAULT '' COMMENT '城',
  `region_name` varchar(32) NOT NULL DEFAULT '' COMMENT '区',
  `detail_address` varchar(64) NOT NULL DEFAULT '' COMMENT '收件详细地址(街道/楼宇/单元)',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '删除标识字段(0-未删除 1-已删除)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oneforallmall_user_token`
--

DROP TABLE IF EXISTS `oneforallmall_user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oneforallmall_user_token` (
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `token` varchar(32) NOT NULL COMMENT 'token值(32位字符串)',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `expire_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'token过期时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-30  1:38:49
