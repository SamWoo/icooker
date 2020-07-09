import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentListItem extends StatelessWidget {
  final listItem;
  const CommentListItem({this.listItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage:
                      NetworkImage(listItem['author']['avatar_url']),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            listItem['author']['nickname'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            listItem['create_time'],
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        listItem['author']['signature'],
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Colors.blueGrey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          listItem['content'],
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Colors.grey[500],
            indent: 8.0,
            endIndent: 8.0,
          )
        ],
      ),
    );
  }
}
