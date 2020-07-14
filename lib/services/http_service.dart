import 'dart:convert';

import 'package:dio/dio.dart';

import '../http/http_manager.dart';

typedef OnSuccessList<T>(List<T> recipes);
typedef OnFail(String msg);
typedef OnSuccess<T>(T onSuccess);

class HttpService {
  Future getHttpData(String url,
      {Map<String, dynamic> parameters,
      OnSuccess onSuccess,
      OnFail onFail}) async {
    try {
      Response response =
          await HttpManager.getInstance().post(url, data: parameters);
      if (response.statusCode == 200) {
        var ret = (response.data is String)
            ? json.decode(response.data)['data']
            : response.data['data'];
        onSuccess(ret);
      } else {
        onFail('服务器接口有问题!');
      }
    } catch (e) {
      print(e);
      onFail('后端接口有问题!');
    }
  }
}
