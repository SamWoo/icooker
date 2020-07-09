import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'food_show_list.dart';

class Show extends StatefulWidget {
  Show({Key key}) : super(key: key);

  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  TabController _tabController;
  List _tabList = [];
  List<Widget> _tabTitles = [
    // Tab(text: '每日分享'),
    // Tab(text: '晒团圆饭'),
    // Tab(text: '热门活动'),
    // Tab(text: '热门话题'),
    // Tab(text: '每日三餐'),
    // Tab(text: '安食油鸡'),
    // Tab(text: '视频美食'),
  ];

  @override
  void initState() {
    super.initState();

    getDataFromServer(Config.FOOD_SHOW_TAB_URL, data: {'type': 1}).then((val) {
      var items = val['item'] as List;
      List<Widget> _tmpList = [];

      items.forEach((it) {
        _tmpList.add(Tab(text: it['topic_title']));
      });

      setState(() {
        _tabList = items;
        _tabTitles = _tmpList;
      });
      // print('$_tabTitles');
    });

    // _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _tabList == null
        ? LoadingWidget()
        : DefaultTabController(
            length: _tabList.length,
            child: Scaffold(
              appBar: _buildAppBar(),
              body: TabBarView(
                // controller: _tabController,
                children: _tabList.map<Widget>((it) {
                  var data = {'type': '1', 'page': 1, 'id': it['topic_id']};
                  return FoodShowList(data: data);
                }).toList(),
              ),
            ),
          );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      //修改TabBar吸顶后的背景颜色和高度
      child: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          isScrollable: true,
          tabs: _tabTitles,
          // controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
          indicatorWeight: ScreenUtil().setHeight(6),
          labelPadding: EdgeInsets.all(8.0),
          //选中样式
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(48),
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          //未选中样式
          unselectedLabelColor: Colors.black54,
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(40),
            // color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        // elevation: 1,
        centerTitle: true,
      ),
      preferredSize: Size.fromHeight(50),
    );
  }
}
