import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/router/routes.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;
  int count = 3; //默认倒计时3s

  @override
  void initState() {
    super.initState();
    countDown();
  }

  countDown() async {
    Timer(Duration(seconds: 1), () {
      _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
        count--;
        if (count == 0) {
          navigationToHome(); //跳转到home页
        } else {
          setState(() {}); //刷新界面
        }
      });
      return _timer;
    });
  }

  navigationToHome() {
    _timer.cancel();
    Routes.navigateTo(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    print('count===$count');
    return Stack(
      alignment: Alignment(1.0, -1.0),
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20.0, 10.0, 0),
          child: FlatButton(
            onPressed: () => navigationToHome(),
            color: Colors.grey,
            shape: CircleBorder(),
            child: Text(
              '${count}s',
              style: TextStyle(
                color: Colors.white,
                fontSize:14.0, 
              ),
            ),
          ),
        ),
      ],
    );
  }
}
