import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/router/routes.dart';

class SearchItemView extends StatefulWidget {
  final type;
  final hotwords;

  SearchItemView({this.type, this.hotwords});

  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = ['红烧猪蹄', '葱油捞面', '虎皮鸡脚', '酸菜鱼', '麻辣小龙虾'];

  @override
  Widget build(BuildContext context) {
    return widget.type == "hot_search"
        ? _buildHotWords(context)
        : _buildSearchHistory();
  }

  //热搜关键字
  Widget _buildHotWords(context) {
    return widget.hotwords != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: widget.hotwords
                  .map(
                    (it) => _buildHotItem(context, it),
                  )
                  .toList(),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(child: Text('发现更多美食')),
          );
  }

  Widget _buildHotItem(BuildContext context, var it) {
    var itemWidth = (MediaQuery.of(context).size.width - 24) / 3;
    return InkWell(
      onTap: () => _navigationToResult(it['title']),
      child: Container(
        width: itemWidth,
        height: itemWidth * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/placeholder.png'),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                width: itemWidth,
                imageUrl: it['img'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "# ${it['title']}",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //搜索历史
  Widget _buildSearchHistory() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(item,
                style: TextStyle(color: Colors.grey, fontSize: 16.0)),
          );
        }).toList(),
      ),
    );
  }

  //跳转搜索结果页面
  _navigationToResult(var searchStr) {
    Fluttertoast.showToast(msg: '搜索关键字-->$searchStr');
    print('搜索关键字-->$searchStr');
    var data = {
      'cid': '',
      'keyword': searchStr,
      'order': '-hot',
      'page': 1,
      'per_page': 10
    };
    Routes.navigateTo(context, '/searchResult',
        params: {'data': json.encode(data)});
  }
}
