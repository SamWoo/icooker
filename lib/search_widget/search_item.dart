import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SearchItemView extends StatefulWidget {
  final String type;
  final List data;

  SearchItemView({this.type, this.data});

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
    var itemWidth = (MediaQuery.of(context).size.width - 24) / 3;
    return widget.data != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical:8.0),
            child: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: widget.data.map((it) {
                return Container(
                  width: itemWidth,
                  height: itemWidth * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      // colorFilter: ColorFilter.mode(
                      //     Colors.grey[100], BlendMode.modulate),
                      image:  NetworkImage(it['img']),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "# ${it['title']}",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(48),
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(child: Text('发现更多美食')),
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
}