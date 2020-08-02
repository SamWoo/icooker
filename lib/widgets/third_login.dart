import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThirdLoginWidget extends StatelessWidget {
  const ThirdLoginWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new Column(
        children: [
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 1.0,
                color: Colors.white,
              ),
              Text('第三方登录'),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.white,
              ),
            ],
          ),
          new SizedBox(
            height: 4.0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.green,
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: 24.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.red,
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weibo),
                iconSize: 24.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.blue,
                icon: Icon(FontAwesomeIcons.alipay),
                iconSize: 24.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.lightBlue[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: 24.0,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
