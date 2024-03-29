import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:icooker/router/router_handler.dart';

// 在routes.dart文件中配置路由，这里需要注意的事首页一定要用“/”配置，其它页无所谓
class Routes {
  static Router router;

  static String root = '/';
  static String home = '/home';
  static String login = '/login';
  static String register = '/register';
  static String search = '/search';
  static String setting = '/setting';
  static String recipeDetail = '/recipeDetail';
  static String imagePreview = '/imagePreview';
  static String webViewPage = '/webViewPage';
  static String categoryPage = '/categoryPage';
  static String searchResultPage = '/searchResult';
  static String commentPage = '/comment';
  static String chewiePage = '/chewiePage';

  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('ERROR====>>>>ROUTE WAS NOT FOUND!!!');
      return;
    });

    router.define(home, handler: homeHandler); //首页界面
    router.define(login, handler: loginHandler); //登录界面
    router.define(register, handler: registerHandler); //注册界面
    router.define(search, handler: searchHandler); //搜索界面
    router.define(setting, handler: settingHandler); //设置界面
    router.define(recipeDetail, handler: recipeDetailHandler); //菜谱详情界面
    router.define(imagePreview, handler: imagePreviewHandler); //图片预览界面
    router.define(webViewPage, handler: webViewPageHandler); //webView显示界面
    router.define(categoryPage, handler: categoryPageHandler); //菜谱分类界面
    router.define(searchResultPage, handler: searchResultHandler); //搜索结果界面
    router.define(commentPage, handler: commentPageHandler); //评论界面
    router.define(chewiePage, handler: chewiePageHandler); //
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      TransitionType transition = TransitionType.native,
      bool clearStack = false}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('navigatorTo传递的参数:$query');
    path += query;
    return router.navigateTo(context, path,
        transition: transition, clearStack: clearStack);
  }

  //关闭当前页面
  static pop(BuildContext context) {
    router.pop(context);
  }
}
