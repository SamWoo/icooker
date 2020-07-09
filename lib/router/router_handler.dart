//setting
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:icooker/comment_page_widget/comment_page.dart';
import 'package:icooker/food_reviews_page_widget/image_preview.dart';
import 'package:icooker/pages/category_page.dart';
import 'package:icooker/pages/home_page.dart';
import 'package:icooker/pages/recipe_detail_page.dart';
import 'package:icooker/pages/search_page2.dart';
import 'package:icooker/pages/search_result.dart';
import 'package:icooker/pages/setting_page.dart';
import 'package:icooker/pages/webview_page.dart';

Handler homeHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return HomePage();
});

Handler searchHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return SearchPage(data: data);
});

Handler settingHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SettingPage();
});

Handler recipeDetailHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return RecipeDetailPage(data: data);
});

Handler imagePreviewHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return ImagePreview(data: data);
});

Handler webViewPageHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return WebViewPage(data: data);
});

Handler categoryPageHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return CategoryPage(data: data);
});

Handler searchResultHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return SearchResultPage(data: data);
});

Handler commentPageHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  print('handleData====>$params');
  String data = params['data']?.first;
  return CommentPage(data: data);
});
