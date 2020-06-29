import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/search_widget/search_content.dart';

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

