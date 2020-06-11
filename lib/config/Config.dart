import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  //默认请求地址
  static const BASE_URL = "https://newapi.meishi.cc";
  //首页推荐
  static const INDEX_HOME_RECOMMEND_URL =
      '/index/home_recommend_7_1_3?source=android&format=json&fc=msjandroid&lat=0.0&lon=0.0&cityCode&token=';
  //feeds_tab
  static const INDEX_FEEDS_TAB_URL =
      '/index/feeds_tab_6_9_1?source=android&format=json&fc=msjandroid&lat=0.0&lon=0.0&cityCode&token=';
  //feeds_classify
  static const INDEX_HOME_FEEDS_CLASSIFY =
      '/index/home_feeds_classify?source=android&format=json&fc=msjandroid&lat=0.0&lon=0.0&cityCode&token=';
  //home_feeds
  static const INDEX_HOME_FEEDS_URL =
      '/index/home_feeds_7_1_3?source=android&format=json&fc=msjandroid&lat=0.0&lon=0.0&cityCode&token=';
  //food_show
  static const FOOD_SHOW_TAB_URL =
      '/Foodshow/foodshow_tab?source=android&format=json&fc=msjandroid&lat=22.230139&lon=113.276158&cityCode=140&token=';
  static const FOOD_SHOW_DATA_URL =
      '/Foodshow/foodshow_index?source=android&format=json&fc=msjandroid&lat=22.230139&lon=113.276158&cityCode=140&token=';
  //est_what
  static const HEATH_EAT_URL =
      '/scene/index?source=android&format=json&fc=msjandroid&lat=22.231292&lon=113.278356&cityCode=140&token=';
  //shiping
  static const SHIPING_TAB_URL =
      '/shiping/index_tab?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';
  //shiping_hot
  static const SHIPING_HOT_URL =
      '/shiping/index?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';
  //shiping_time
  static const SHIPING_TIME_URL =
      '/shiping/index?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //连接服务器超时时间
  static const CONNECT_TIMEOUT = 10 * 1000;
  //响应流前后接收数据间隔，单位毫秒
  static const RECIVE_TIMEOUT = 5 * 1000;

  // 预设主题颜色值
  static const Map<String, Color> themeColorMap = {
    'redAccent': Colors.redAccent,
    'blue': Colors.blue,
    'blueAccent': Colors.blueAccent,
    'cyan': Colors.cyan,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'deepOrange': Colors.orange,
    'green': Colors.green,
    'indigo': Colors.indigo,
    'indigoAccent': Colors.indigoAccent,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
    'red': Colors.red,
    'teal': Colors.teal,
    'black': Colors.black,
  };
  // Theme Color Key
  static const key_theme_color = 'key_theme_color';
}
