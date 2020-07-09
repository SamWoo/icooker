import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'dart:convert' as convert;

class RecommendData extends StatelessWidget {
  final data;
  const RecommendData({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(880),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(context, data[index]);
        },
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, var item) {
    return GestureDetector(
      onTap: () {
        var data = {"id": item['id']};
        getDataFromServer(Config.RECIPE_DETAIL_URL, data: data).then((val) {
          Routes.navigateTo(context, '/recipeDetail',
              params: {'data': convert.jsonEncode(val)});
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(
          children: <Widget>[
            _buildItemImage(item),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Text(
                item['recommend_title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: _buildInfo(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(var item) {
    //推荐图片
    var ratio = 0.75;
    return Container(
      height: ScreenUtil().setHeight(880),
      width: ScreenUtil().setHeight(880) * ratio,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.grey[200], BlendMode.modulate),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: item['video']['img'],
            fit: BoxFit.fill,
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.fill),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(var item) {
    //推荐图片的info
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item['title'] == null ? '' : item['title'],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 16.0,
              backgroundImage: NetworkImage(item['author']['avatar_url']),
            ),
            SizedBox(width: 8.0),
            Text(
              item['author']['nickname'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            )
          ],
        ),
      ],
    );
  }
}
