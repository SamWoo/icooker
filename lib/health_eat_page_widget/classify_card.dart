import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/hexColor.dart';

class ClassfiyCard extends StatelessWidget {
  final data;

  const ClassfiyCard({this.data});

  @override
  Widget build(BuildContext context) {
    // debugPrint('card data---->$data');

    return Card(
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(data['img'], fit: BoxFit.fill)),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            child: _buildDesc(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesc() {
    var color = HexColor.getColorFromHex(data['color']);
    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 4.0),
//      margin: EdgeInsets.only(top: 80.0),
//      color: Colors.lightBlueAccent,
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
                  fontSize: ScreenUtil().setSp(32), color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: data['class'].map<Widget>((it) {
              return Row(children: <Widget>[
                Icon(
                  Icons.album,
                  color: Color(color),
                  size: 8.0,
                ),
//                Material(
//                  type: MaterialType.circle,
//                  color: Color(color),
//                  child: Container(width: 8.0, height: 8.0),
//                ),
                SizedBox(width: 4.0),
                Text(
                  it,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Colors.blueGrey[700]),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
