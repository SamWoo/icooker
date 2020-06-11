import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'classify_card.dart';

class Classfiy extends StatelessWidget {
  final data;
  const Classfiy({this.data});

  @override
  Widget build(BuildContext context) {
    debugPrint('****${data['items']}');
    return Container(
      // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical:8.0),
      padding: EdgeInsets.all(10.0),
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
              SizedBox(width: 8.0),
              Text(data['title'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40), color: Colors.black))
            ],
          ),
          SizedBox(height: 4.0),
          Text(data['desc'],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Colors.grey)),
          SizedBox(height: 8.0),
          Container(
            height: 180,
            color: Colors.blue,
            child: ListView.builder(
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ClassfiyCard(data:data['items']),
              itemCount: data['items'].length,
            ),
          )
        ],
      ),
    );
  }
}
