import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'dart:convert' as convert;

class TileCard extends StatelessWidget {
  final data;

  const TileCard({this.data});

  @override
  Widget build(BuildContext context) {
    var img;
    var title;
    var id;
    var author;
    var viewedAmount;
    var favorAmount;
    var ratio = (data['wh_ratio'] is String)
        ? double.parse(data['wh_ratio'])
        : double.parse(data['wh_ratio'].toString()); //图片的宽高比

    if (data['video_article'] != null) {
      img = data['video_article']['img'];
      title = data['video_article']['title'];
      id = data['video_article']['id'];
      author = data['video_article']['author'];
      favorAmount = data['video_article']['favor_amount'];
      viewedAmount = data['video_article']['viewed_amount'];
    } else if (data['video_recipe'] != null) {
      img = data['video_recipe']['img'];
      title = data['video_recipe']['title'];
      id = data['video_recipe']['id'];
      author = data['video_recipe']['author'];
      viewedAmount = data['video_recipe']['viewed_amount'];
      favorAmount = data['video_recipe']['favor_amount'];
    } else if (data['recipe'] != null) {
      img = data['recipe']['img'];
      title = data['recipe']['title'];
      id = data['recipe']['id'];
      author = data['recipe']['author'];
      viewedAmount = data['recipe']['viewed_amount'];
      favorAmount = data['recipe']['favor_amount'];
    } else if (data['works'] != null) {
      img = data['works']['img'];
      title = data['works']['title'];
      id = data['works']['id'];
      author = data['works']['author'];
      viewedAmount = data['works']['viewed_amount'];
      favorAmount = data['works']['favor_amount'];
    }

    return Card(
      child: InkWell(
        onTap: () {
          var data = {"id": id};
          getDataFromServer(Config.RECIPE_DETAIL_URL, data: data).then((val) {
            Routes.navigateTo(context, '/recipeDetail',
                params: {'data': convert.jsonEncode(val)});
          });
        },
        //点击时出现水波纹效果
        splashColor: Colors.deepOrange.withOpacity(0.3),
        highlightColor: Colors.deepOrange.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildImg(context, img, id, ratio),
            _buildDesc(title, author, viewedAmount, favorAmount),
          ],
        ),
      ),
    );
  }

  Widget _buildImg(BuildContext context, var imgUrl, var id, var ratio) {
    var _itemWidth = (MediaQuery.of(context).size.width - 16) / 2;
    return Hero(
        tag: id,
        child: Container(
          width: _itemWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                child: Image.asset('assets/images/placeholder.png',
                    fit: BoxFit.fill),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ));
  }

  Widget _buildDesc(var title, var author, var views, var favor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(title),
          SizedBox(height: 8.0),
          _buildAuthor(author),
          SizedBox(height: 8.0),
          _buildFavor(views, favor)
        ],
      ),
    );
  }

  Widget _buildTitle(var title) {
    // title = title == null ? '' : title;
    return Container(
      child: Text(
        title ?? "",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAuthor(var author) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 16.0,
          backgroundImage: NetworkImage(
            author['avatar_url'],
          ),
        ),
        SizedBox(width: 4.0),
        Container(
          width: ScreenUtil().setWidth(320),
          child: Text(
            author['nickname'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(40)),
          ),
        ),
      ],
    );
  }

  Widget _buildFavor(var views, var favor) {
    // views = views == null ? '0' : views;
    // favor = favor == null ? '0' : favor;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.library_books, size: 14, color: Colors.blue),
          Text(
            data['tag'],
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(32)),
          ),
          SizedBox(width: 8.0),
          Icon(Icons.favorite, size: 14, color: Colors.red),
          Text(
            favor ?? '0',
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(32)),
          ),
          SizedBox(width: 8.0),
          Icon(Icons.visibility, size: 14, color: Colors.green),
          Text(
            views ?? '0',
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(32)),
          ),
        ],
      ),
    );
  }
}
