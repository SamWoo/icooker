import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'dart:convert' as convert;

class FoodShowCard extends StatelessWidget {
  final data;

  const FoodShowCard({this.data});

  @override
  Widget build(BuildContext context) {
    var id = data['works']['id'];
    debugPrint('works===$data');
    return Card(
      child: InkWell(
        onTap: () {}, //=> _onTapHandler(context, id),
        //点击时出现水波纹效果
        splashColor: Colors.deepOrange.withOpacity(0.3),
        highlightColor: Colors.deepOrange.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildImg(context, id),
            _buildDesc(),
          ],
        ),
      ),
    );
  }

  //点击跳转详情界面
  _onTapHandler(BuildContext context, var id) {
    var data = {"id": id};
    getDataFromServer(Config.RECIPE_DETAIL_URL, data: data).then((val) {
      Routes.navigateTo(context, '/recipeDetail',
          params: {'data': convert.jsonEncode(val)});
    });
  }

  Widget _buildImg(context, var id) {
    debugPrint('ratio====>${data['wh_ratio']}');
    var ratio = (data['wh_ratio'] is String)
        ? double.parse(data['wh_ratio'])
        : double.parse(data['wh_ratio'].toString());
    // debugPrint(ratio.runtimeType.toString());
    //每个card的默认宽度
    var _itemWidth = (MediaQuery.of(context).size.width - 16) / 2;
    return Hero(
      tag: id,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        child: Container(
          width: _itemWidth,
          height: _itemWidth / ratio,
          child: CachedNetworkImage(
            width: _itemWidth,
            imageUrl: data['works']['img'],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildDesc() {
    var item = data['works'];
    var topicInfo = item['topic_info'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(item['content']),
          SizedBox(height: 8.0),
          topicInfo == null
              ? Container()
              : _buildInfo(topicInfo['topic_title']),
          SizedBox(height: 8.0),
          _buildAuthor(item['author'], item['time']),
        ],
      ),
    );
  }

  Widget _buildTitle(var title) {
    return Container(
      child: Text(
        title,
        maxLines: 3,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(40),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInfo(var info) {
    return Container(
      child: Text(
        '# $info',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey,
          fontSize: ScreenUtil().setSp(36),
        ),
      ),
    );
  }

  Widget _buildAuthor(var author, var time) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 12.0,
          backgroundImage: NetworkImage(
            author['avatar_url'],
          ),
        ),
        SizedBox(width: 4.0),
        Container(
          width: ScreenUtil().setWidth(240),
          child: Text(
            author['nickname'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(32)),
          ),
        ),
        Spacer(),
        Text(
          time,
          style:
              TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(32)),
        ),
      ],
    );
  }
}
