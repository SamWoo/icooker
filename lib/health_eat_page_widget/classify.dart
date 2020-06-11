import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'classify_card.dart';

class Classfiy extends StatelessWidget {
  final data;
  const Classfiy({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical:8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                data['icon'],
                fit: BoxFit.fill,
              ),
              SizedBox(width: 8.0),
              Text(data['title'],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40), color: Colors.black))
            ],
          ),
          Text(data['title'],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24), color: Colors.grey)),
          SizedBox(height: 8.0),
          Container(
            width: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indec) =>
                  ClassfiyCard(data:data['items']),
              itemCount: data['items'].length,
            ),
          )
        ],
      ),
    );
  }
}
