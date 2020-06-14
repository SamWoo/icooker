import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/hexColor.dart';

class ClassfiyCard extends StatelessWidget {
  final data;
  const ClassfiyCard({this.data});

  @override
  Widget build(BuildContext context) {
    // debugPrint('card data---->$data');
    var color = HexColor.getColorFromHex(data['color']);

    return Container(
      height: 180,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(data['img'], fit: BoxFit.fill)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            margin: EdgeInsets.only(top:80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    data['title'],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36), color: Colors.white),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data['class'].map<Widget>((it) {
                    return Row(children: <Widget>[
                      Material(
                        type: MaterialType.circle,
                        color: Color(color),
                        child: Container(width: 8.0, height: 8.0),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        it,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.blueGrey[700]),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
