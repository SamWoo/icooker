import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:icooker/router/routes.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('我的'),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: BottomClipper(),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 120,
                ),
              ),
              Positioned(
                left: 12,
                top: 0,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(
                      'http://9.onn9.com/2016/10/85c76e5623b1b443bcdb7afe2a951cd5.jpg'),
                ),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            selected: true,
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('设置'),
            onTap: () => Routes.router.navigateTo(context, '/setting'),
          ),
          Divider(
            height: 1,
            indent: 4.0,
            endIndent: 4.0,
            color: Colors.grey[400],
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            selected: true,
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('其他'),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  var height = kToolbarHeight + MediaQueryData.fromWindow(window).padding.top;
  @override
  Path getClip(Size size) {
    var path = Path();
    //单曲线切割路径
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height -50);
    // var firstControlPoint = Offset(size.width / 2, size.height);
    // var firstEndpoint = Offset(size.width, size.height -50);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndpoint.dx, firstEndpoint.dy);
    // path.lineTo(size.width, size.height-50);
    // path.lineTo(size.width, 0);

    //波浪线路径
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height); //第一段曲线控制点
    var firstEndpoint = Offset(size.width / 2.25, size.height - 30); //第一段曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy); //形成曲线

    var secondControlPoint =
        Offset(size.width * 3 / 4, size.height - 90); //第二段曲线控制点
    var secondEndPoint = Offset(size.width, size.height - 40); //第二段曲线结束点
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
