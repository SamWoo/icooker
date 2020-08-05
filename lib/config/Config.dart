import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  //默认请求地址
  static const BASE_URL = "https://newapi.meishi.cc"; //自行抓包

  //login
  static const LOGIN_URL = '';

  //首页推荐
  static const INDEX_HOME_RECOMMEND_URL =
      '/index/home_recommend_7_1_3?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //首页Tab
  static const INDEX_FEEDS_TAB_URL =
      '/index/feeds_tab_6_9_1?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //首页其他Tab分类详情
  static const INDEX_HOME_FEEDS_CLASSIFY =
      '/index/home_feeds_classify?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //首页推荐Tab详情
  static const INDEX_HOME_FEEDS_URL =
      '/index/home_feeds_7_1_3?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //食秀Tab
  static const FOOD_SHOW_TAB_URL =
      '/Foodshow/foodshow_tab?source=android&format=json&fc=msjandroid&lat=22.230139&lon=113.276158&cityCode=140&token=';

  //食秀Tab对应详情
  static const FOOD_SHOW_DATA_URL =
      '/Foodshow/foodshow_index?source=android&format=json&fc=msjandroid&lat=22.230139&lon=113.276158&cityCode=140&token=';

  //吃什么
  static const HEATH_EAT_URL =
      '/scene/index?source=android&format=json&fc=msjandroid&lat=22.231292&lon=113.278356&cityCode=140&token=';

  //食评Tab
  static const SHIPING_TAB_URL =
      '/shiping/index_tab?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //食评最热
  static const SHIPING_HOT_URL =
      '/shiping/index?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //食评最新
  static const SHIPING_TIME_URL =
      '/shiping/index?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //菜谱详情
  static const RECIPE_DETAIL_URL =
      '/recipe/detail?source=android&format=json&fc=msjandroid&lat=22.231293&lon=113.278299&cityCode=140&token=';

  //生活技巧详情
  static const KNOWLEDGE_DETAIL_URL =
      '/Knowledge/detail?source=android&format=json&fc=msjandroid&lat=22.231348&lon=113.27846&cityCode=140&token=';

  //channel渠道位的url
  static const DAILYWELFARE_URL =
      'https://apph5.meishi.cc/tbk/dailywelfare.php'; //每日福利

  static const WEEK_RANK_URL = 'https://apph5.meishi.cc/top/week.php'; //本周流行菜谱

  //搜索热词
  static const SEARCH_HOT_WORDS_URL =
      '/search/hot_words?source=android&format=json&fc=msjandroid&lat=22.231214&lon=113.278212&cityCode=140&token=';

  //菜谱分类
  static const CATEGORY_LIST_URL =
      '/index/categorylist/?source=android&format=json&fc=msjandroid&lat=22.231288&lon=113.278349&cityCode=140&token=';

  //搜索结果
  static const SEARCH_RESULT_URL =
      '/Search/recipe_7_1_0?source=android&format=json&fc=msjandroid&lat=22.231192&lon=113.278169&cityCode=140&token=';

  //菜谱评论
  static const COMMENT_URL =
      '/recipe/recipe_pl_list?source=android&format=json&fc=msjandroid&lat=22.231216&lon=113.278165&cityCode=140&token=';

  //登录
  static const USER_URL =
      '/user/mobile_code?source=android&format=json&fc=msjandroid&lat=22.231011&lon=113.278736&cityCode=140&token=';

  //食秀
  static const FOOD_SHOW_URL =
      'https://apph5.meishi.cc/app_index/foodshow.php?token=&phone_model=android';

  //食杰
  static const FOOD_KING_URL =
      'https://apph5.meishi.cc/king_of_food/food_king_two.php?token=&phone_model=android';

  //任务中心
  static const FOOD_TASK_URL =
      'https://apph5.meishi.cc/king_of_food/task_two.php?token=&phone_model=android';

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
  static const KEY_THEME_COLOR = 'key_theme_color';
  static const KEY_FIRST_LOGIN = 'key_first_login';
  static const KEY_TOKEN = 'token';
  static const KEY_IS_LOGIN = 'is_login';
}
