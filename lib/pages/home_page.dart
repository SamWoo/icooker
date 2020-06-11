import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/food_show_page_widget/food_show_list.dart';
import 'package:icooker/pages/food_set_page.dart';
import 'package:icooker/pages/food_show_page.dart';

import 'heath_eat_page.dart';
import 'my_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  //底部需要切换的页面
  final List<Widget> _pages = [
    FoodSetPage(),
    // FoodShowPage(),
    FoodShowList(data:{'type': '1', 'page': 1, 'id': 7}),
    MyPage(),
    HeathEatPage(),
    MyPage(),
  ];

  //底部导航item的文字和图片
  final List<BottomNavigationBarItem> tabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('食集'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('食秀'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      title: Text('食记'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.cake),
      title: Text('吃什么'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      title: Text('我的'),
    ),
  ];

  //当前点击的item
  int _currentIndex = 0;

  //点击底部item跳转相应的page
  void _onTapHandler(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // 方式一：默认设置宽度1080px，高度1920px
    ScreenUtil.init(context);
    // 方式二：设置宽度750px，高度1334px
    // ScreenUtil.init(context, width: 750, height: 1334);
    // 方式三：设置宽度750px，高度1334px，根据系统字体进行缩放
    // ScreenUtil.init(context, width: 1080, height: 1920, allowFontScaling: true);
    return Scaffold(
      // body: _pageList[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: tabs,
        onTap: _onTapHandler,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
