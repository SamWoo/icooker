import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "搜索你感兴趣的";

  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放搜索确认按钮
    return [
      FlatButton.icon(
        icon: Icon(
          EvilIcons.search,
          color: Colors.black,
          size: 24.0,
        ),
        label: Text(
          "搜索",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20,
      ),
      // AnimatedIcon(
      //   icon: AnimatedIcons.menu_arrow,
      //   progress: transitionAnimation,
      // ),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //点击了搜索显示的页面
    return Container(
      child: Center(
        child: Text("搜索的结果：$query"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //输入时的推荐及搜索结果
    return SearchContentView();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      cursorColor: Colors.red,
      inputDecorationTheme: InputDecorationTheme(
        // fillColor: Color.fromARGB(255, 120, 245, 245),
        hintStyle:
            Theme.of(context).textTheme.body1.copyWith(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class SearchContentView extends StatefulWidget {
  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Ionicons.md_flame,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('大家都在搜',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            SearchItemView(
              type: "hot_search",
            ),
            ListTile(
              dense: true,
              title: Text(
                '历史记录',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                EvilIcons.trash,
                size: 32.0,
                // color: Colors.red,
              ),
              contentPadding: EdgeInsets.all(0.0),
              onTap: () => print('Delete all history?'),
            ),
            SearchItemView()
          ],
        ),
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  final String type;

  SearchItemView({this.type});

  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = ['红包到手啦', '充电宝 迷你', 'T恤', '丝袜 防勾丝', '性感情趣内衣', '抽纸 天猫超市'];

  @override
  Widget build(BuildContext context) {
    if (widget.type == "hot_search") {
      return Wrap(
        spacing: 10.0,
        children: items.map((item) {
          return SearchItem(title: item);
        }).toList(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(item,
                style: TextStyle(color: Colors.grey, fontSize: 16.0)),
          );
        }).toList(),
      );
    }
  }
}

class SearchItem extends StatefulWidget {
  final String title;

  SearchItem({this.title});

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  _getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          backgroundColor: _getRandomColor(),
          label: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          // backgroundColor: _getRandomColor(),
          shape: StadiumBorder(),
          // deleteIcon: Icon(Icons.delete),
          // deleteIconColor: Colors.red,
          // onDeleted: () {},
        ),
        onTap: () {
          print(widget.title);
        },
      ),
    );
  }
}
