import 'package:flutter/material.dart';
class FooterTip extends StatelessWidget {
  const FooterTip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text('─ ♨我是有底线的!!!♨ ─', style: TextStyle(color: Colors.blueGrey)),
    );
  }
}