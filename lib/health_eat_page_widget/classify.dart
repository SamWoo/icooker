import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'classify_card.dart';

class Classfiy extends StatelessWidget {
  final data;
  const Classfiy({this.data});

  @override
  Widget build(BuildContext context) {
    // debugPrint('****${data['items']}');
    return Container(
      margin: EdgeInsets.symmetric(vertical:2.0),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                data['icon'],
                height: 24,
                width: 24,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 4.0),
              Text(data['title'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(48), color: Colors.black))
            ],
          ),
          SizedBox(height: 4.0),
          Text(data['desc'],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Colors.blueGrey[700])),
          SizedBox(height: 8.0),
          Container(
            height: 180,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ClassfiyCard(data:data['items'][index]),
              itemCount: data['items'].length,
            ),
          )
        ],
      ),
    );
  }
}
