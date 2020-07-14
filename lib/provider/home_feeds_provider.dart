import 'package:flutter/material.dart';
import 'package:icooker/services/http_service.dart';

class FeedsModel with ChangeNotifier {
  HttpService httpService = HttpService();
  List recipeData;
  bool hasData;
  int _totalPage;

  //获取总页数
  int get totalPage => _totalPage;

  //获取返回数据
  void loadFeedsData(String url, {var parameters}) async {
    List recipeList = [];
    httpService.getHttpData(url, parameters: parameters, onSuccess: (response) {
      _totalPage = response['total_page'];
      response['items'].forEach((it) {
        if (it.containsKey('recipe')) recipeList.add(it);
      });
      if (parameters['page'] == 1) {
        recipeData = recipeList;
        notifyListeners();
        return;
      }
      List data = recipeList;
      recipeData.addAll(data);
      notifyListeners();
    }, onFail: (message) {
      hasData = !(recipeData == null || recipeData.length == 0);
      notifyListeners();
    });
  }
}
