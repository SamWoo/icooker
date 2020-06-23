import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'dart:convert' as convert;

class Channel extends StatelessWidget {
  final data;
  const Channel({this.data});

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 8) / 4;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      //  color: Colors.yellow,
      child: Wrap(
        //  spacing: 1.0,
        children: data.map<Widget>((item) {
          return InkWell(
            onTap: () {
              var title = item['title'];
              var initUrl;
              bool showBar = false;
              var data = {
                'initUrl': initUrl,
                'title': title,
                'showBar': showBar
              };

              switch (title) {
                case '每日优惠':
                  data['initUrl'] = Config.DAILYWELFARE_URL;
                  data['showBar'] = true;
                  Routes.navigateTo(context, '/webViewPage',
                      params: {'data': convert.jsonEncode(data)});
                  break;
                case '本周流行':
                  data['initUrl'] = Config.WEEK_RANK_URL;
                  Routes.navigateTo(context, '/webViewPage',
                      params: {'data': convert.jsonEncode(data)});
                  break;
                case '智能组菜':
                  break;
                case '菜谱分类':
                  break;
                default:
                  break;
              }
            },
            child: Container(
              padding: EdgeInsets.all(1.0),
              //  color: Colors.green,
              width: itemWidth,
              height:itemWidth*0.8,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item['img'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.fill),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: ScreenUtil().setWidth(36),
                    left: ScreenUtil().setWidth(36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item['title'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                        ),
                        Text(
                          item['desc'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
