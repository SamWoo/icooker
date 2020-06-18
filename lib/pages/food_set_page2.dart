import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/food_set_page_widget/ad_banner.dart';
import 'package:icooker/food_set_page_widget/channel.dart';
import 'package:icooker/food_set_page_widget/food_list.dart';
import 'package:icooker/food_set_page_widget/meals.dart';
import 'package:icooker/food_set_page_widget/recommend.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

class FoodSetPage extends StatefulWidget {
  FoodSetPage({Key key}) : super(key: key);

  @override
  _FoodSetPageState createState() => _FoodSetPageState();
}

class _FoodSetPageState extends State<FoodSetPage>
    with SingleTickerProviderStateMixin {
  static ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);
  TabController _tabController;
  var pageCount = 2;
  var page;
  var data;

  var _tabTitles = [
    Tab(text: '推荐'),
    Tab(text: '生活技巧'),
    Tab(text: '时令'),
    Tab(text: '食肉'),
    Tab(text: '素食'),
    Tab(text: '烘焙'),
  ];

  var _foodList = [
    FoodList(data: {'type': '', 'page': 1}),
    FoodList(data: {'type': '211', 'page': 1}),
    FoodList(data: {'type': '210', 'page': 1}),
    FoodList(data: {'type': '206', 'page': 1}),
    FoodList(data: {'type': '207', 'page': 1}),
    FoodList(data: {'type': '208', 'page': 1}),
  ];

  var _recommendData;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabTitles.length, vsync: this);

    //服务器获取数据
    getDataFromServer(Config.INDEX_HOME_RECOMMEND_URL).then((val) {
      //推荐数据
      setState(() {
        _recommendData = (val as List);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: _recommendData == null
          ? LoadingWidget()
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                _buildRecommend(),
                _buildPersistentHeader(),
                _buildSliverBody(),
              ],
            ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      child: AppBar(
        // elevation: 0,
        brightness: Brightness.light,
        flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
        leading: IconButton(
          icon: Icon(Icons.add, color: Colors.black87),
          onPressed: () => debugPrint("点击+按钮.."),
        ),
        centerTitle: true,
        titleSpacing: 8.0,
        title: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(width:0.5,color:Colors.grey),
              color: Colors.grey[100]),
          child: InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: '点击搜索按钮');
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 8.0),
                Text(
                  "搜索百万免费菜谱",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.email, color: Colors.grey[700]),
            onPressed: () => Fluttertoast.showToast(msg: '点击Email按钮'),
          ),
        ],
      ),
      preferredSize: Size.fromHeight(50),
    );
  }

  Widget _buildRecommend() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//              _slogan(),
            RecommendData(data: _recommendData[1]['video_info']),
            Channel(data: _recommendData[2]['channel']),
            Meals(_recommendData[3]['sancan']),
            AdBanner(data: _recommendData[4]['zhuanti']),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: PreferredSize(
          //修改TabBar吸顶后的背景颜色和高度
          child: Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: _tabTitles,
              labelColor: Colors.red,
              labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
              labelStyle: TextStyle(
                fontSize: ScreenUtil().setSp(42),
                // color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: Colors.black54,
              unselectedLabelStyle: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                // color: Colors.black54,
              ),
              indicatorColor: Colors.red,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 4.0,
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
      ),
    );
  }

  Widget _buildSliverBody() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: _foodList,
      ),
    );
  }

  //推荐语
  Widget _slogan() {
    var slogan =
        _recommendData[0]['recommend_info']['recommend_text'].substring(1);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        '$slogan',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.deepOrange,
          // fontFamily: ,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class _SliverDelegate extends SliverPersistentHeaderDelegate {
  _SliverDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      SizedBox.expand(
        child: child,
      );

  @override
  double get maxExtent => max(minHeight, maxHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    //是否需要重建
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
