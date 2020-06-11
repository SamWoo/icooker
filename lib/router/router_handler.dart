//setting
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:icooker/pages/setting_page.dart';

Handler settingHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SettingPage();
});