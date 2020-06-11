import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/food_show_page_widget/food_show_tab.dart';

class FoodShowPage extends StatefulWidget {
  FoodShowPage({Key key}) : super(key: key);

  @override
  _FoodShowPageState createState() => _FoodShowPageState();
}

class _FoodShowPageState extends State<FoodShowPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  var _tabTitles = [
    Tab(text: '食秀'),
    Tab(text: '食杰'),
    Tab(text: '任务中心'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Show(),
          Center(child: Text('食杰')),
          Center(child: Text('任务中心')),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      //修改TabBar吸顶后的背景颜色和高度
      child: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        flexibleSpace: Image.asset('assets/images/bar.jpg', fit: BoxFit.cover),
        title: TabBar(
          tabs: _tabTitles,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
          indicatorWeight: ScreenUtil().setHeight(10),
          //选中样式
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(56),
            // color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          //未选中样式
          unselectedLabelColor: Colors.black54,
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(48),
            // color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        // centerTitle: true,
      ),
      preferredSize: Size.fromHeight(48),
    );
  }
}
