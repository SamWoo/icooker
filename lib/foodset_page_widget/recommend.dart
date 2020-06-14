import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendData extends StatelessWidget {
  final data;
  const RecommendData({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(880),
      width: double.infinity,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(data[index]);
        },
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
      ),
    );
  }

  Widget _buildItem(var item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }

  Widget _buildItemImage(var item) {
    //推荐图片
    var ratio = 0.75;
    return Container(
      height: ScreenUtil().setHeight(880),
      width: ScreenUtil().setHeight(880) * ratio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          imageUrl: item['video']['img'],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Image.asset('assets/images/placeholder.png', fit: BoxFit.fill),
          errorWidget: (context, url, error) => Container(
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
              ),
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
