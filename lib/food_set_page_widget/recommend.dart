import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/router/routes.dart';

class RecommendData extends StatefulWidget {
  final data;
  RecommendData({this.data});

  @override
  _RecommendDataState createState() => _RecommendDataState();
}

class _RecommendDataState extends State<RecommendData> {
  bool isPlay = false; //是否正在播放

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
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
    var ratio = 0.7;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      height: ScreenUtil().setHeight(880),
      width: ScreenUtil().setHeight(880) * ratio,
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
          Align(
            alignment: Alignment.center,
            child: _buildPlayButton(item),
          ),
        ],
      ),
    );
  }

  ///播放按钮
  Widget _buildPlayButton(var item) {
    return item['video']['vendor_video'] == null
        ? Container()
        : GestureDetector(
            onTap: () => _goToChewiePage(context, item),
            child: Container(
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(160.0),
              width: ScreenUtil().setWidth(160.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(80.0),
                ),
                color: Colors.black54,
              ),
              child: Icon(
                Icons.play_arrow,
                size: 42,
                color: Colors.white,
              ),
            ),
          );
  }

  ///推荐图片
  Widget _buildItemImage(var item) {
    return Container(
      height: double.infinity,
      width: double.infinity,
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

  ///推荐图片的info
  Widget _buildInfo(var item) {
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

  ///跳转视频播放页
  _goToChewiePage(BuildContext context, var item) {
    Routes.navigateTo(context, '/chewiePage',
        params: {'data': convert.jsonEncode(item)});
  }
}
