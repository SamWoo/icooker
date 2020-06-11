import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: Center(
            child: SpinKitFadingCircle(
              color: Colors.red,
              size: 24.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: Center(
            child: Text('正在加载中，莫着急额...'),
          ),
        ),
      ],
    );
  }
}
