import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'dart:convert' as convert;

import 'package:icooker/services/services_method.dart';

class Channel extends StatelessWidget {
  final data;
  const Channel({this.data});

  //渠道位点击事件
  _onTapHandle(BuildContext context, var item) {
    var title = item['title'];
    var initUrl;
    bool showBar = false;
    var data = {'initUrl': initUrl, 'title': title, 'showBar': showBar};

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
        getDataFromServer(Config.CATEGORY_LIST_URL).then((val) {
          Routes.navigateTo(context, '/categoryPage',
              params: {'data': convert.jsonEncode(val)});
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 8) / 4;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Wrap(
        children: data.map<Widget>((item) {
          return InkWell(
            onTap: () => _onTapHandle(context, item),
            child: Container(
              padding: EdgeInsets.all(1.0),
              width: itemWidth,
              height: itemWidth * 0.8,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height:double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: item['img'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
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
                          style: TextStyle(fontSize: ScreenUtil().setSp(36)),
                        ),
                        Text(
                          item['desc'],
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
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
