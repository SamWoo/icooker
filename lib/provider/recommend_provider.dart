import 'package:flutter/material.dart';
import 'package:icooker/services/http_service.dart';

class RecommendModel with ChangeNotifier {
  HttpService httpService = HttpService();
  List recommendData;
  bool hasData;
  int _totalPage;

  //获取总页数
  int get totalPage => _totalPage;

  //获取返回数据
  void loadRecommendData(String url, {var parameters}) async {
    httpService.getHttpData(url, parameters: parameters, onSuccess: (response) {
      recommendData = response as List;
      notifyListeners();
    }, onFail: (message) {
      hasData = !(recommendData == null || recommendData.length == 0);
      notifyListeners();
    });
  }
}
