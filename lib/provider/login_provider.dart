import 'package:flutter/material.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/services/http_service.dart';
import 'package:icooker/utils/spHelper.dart';

class LoginProvider with ChangeNotifier {
  HttpService httpService = HttpService();
  bool _isLogin = false; //是否登录

  bool get isLogin => _isLogin;

  void login(String url, {var parameters}) {
    httpService.getHttpData(url, parameters: parameters, onSuccess: (response) {
      SpHelper.putString(
          Config.KEY_TOKEN, response.headers['set-cookie'][0].split(';')[0]);
    }, onFail: (msg) {});
    _isLogin = true;
    notifyListeners();
  }
}
