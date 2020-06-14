//setting
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:icooker/pages/recipe_detail_page.dart';
import 'package:icooker/pages/setting_page.dart';

Handler settingHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SettingPage();
});

Handler recipeDetailHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      print('data====>$params');
      String data=params['data']?.first;
  return RecipeDetailPage(data:data);
});