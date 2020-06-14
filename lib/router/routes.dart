import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:icooker/router/router_handler.dart';

class Routes {
  static Router router;

  static String root = '/';
  static String setting = '/setting';
  static String recipeDetail = '/recipeDetail';

  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('ERROR====>>>>ROUTE WAS NOT FOUND!!!');
      return;
    });

    router.define(setting, handler: settingHandler);
    router.define(recipeDetail, handler: recipeDetailHandler);
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      TransitionType transition = TransitionType.native}) {
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
    return router.navigateTo(context, path, transition: transition);
  }
}
