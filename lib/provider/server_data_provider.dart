import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:icooker/http/http_manager.dart';

class ServerProvider with ChangeNotifier {
  var _data;
  getDataFromServer(var url, {var data}) async {
    Response response;
    response = await HttpManager.getInstance().post(url, data: data);
    if (response.statusCode == 200) {
      _data = json.decode(response.data)['data'];
      print('provider ret--->$_data');
    }
    notifyListeners();
  }

  List get data => _data;
}
