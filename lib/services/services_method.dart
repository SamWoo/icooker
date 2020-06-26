import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:icooker/config/Config.dart';

import '../http/http_manager.dart';

/// 根据url和data获取服务器数据
Future getDataFromServer(var url, {var data}) async {
  Response response;
  response = await HttpManager.getInstance().post(url, data: data);
  if (response.statusCode == 200) {
    var ret = json.decode(response.data)['data'];
//    print('ret--->$ret');
    return ret;
  } else {
    throw Exception('服务器接口有问题!');
  }
}

/// 获取首页展示数据
Future getFoodSetData(data) async {
  Response response;
  List _dataList = [];
  var type = data['type'];
  var url = type.isEmpty
      ? Config.INDEX_HOME_FEEDS_URL
      : Config.INDEX_HOME_FEEDS_CLASSIFY;

  response = await HttpManager.getInstance().post(url, data: data);
  if (response.statusCode == 200) {
    List tempList = json.decode(response.data)['data']['items'] as List;
    // print('tempList--->$tempList');
    tempList.forEach((val) {
      if (val.containsKey('recipe') ||
          // val.containsKey('works') ||
          val.containsKey('video_recipe') ||
          val.containsKey('video_article')) {
        _dataList.add(val);
      }
    });
    // print('dataList--->$_dataList');
    return _dataList;
  } else {
    throw Exception('服务器接口有问题!');
  }
}

/// 获取服务器搜索热词数据
Future getHotWords(var url, {var data}) async {
  Response response;
  response = await HttpManager.getInstance().post(url, data: data);
  if (response.statusCode == 200) {
    var ret = response.data['data'];
//    print('ret--->$ret');
    return ret;
  } else {
    throw Exception('服务器接口有问题!');
  }
}