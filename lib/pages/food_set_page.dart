import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/foodset_page_widget/ad_banner.dart';
import 'package:icooker/foodset_page_widget/channel.dart';
import 'package:icooker/foodset_page_widget/food_list.dart';
import 'package:icooker/foodset_page_widget/meals.dart';
import 'package:icooker/foodset_page_widget/recommend.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

class FoodSetPage extends StatefulWidget {
  FoodSetPage({Key key}) : super(key: key);

  @override
  _FoodSetPageState createState() => _FoodSetPageState();
}

class _FoodSetPageState extends State<FoodSetPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

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
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(length: _tabTitles.length, vsync: this);

    //服务器获取数据
    getHomeRecommend().then((val) {
      setState(() {
        _recommendData = val;
      });
      // print('>>>>>>>>> $_recommendData');
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
          : NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  _buildSliverAppBar(),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: _foodList,
              ),
            ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      child: AppBar(
        // elevation: 0,
        leading: Icon(
          Icons.add,
          color: Colors.white,
          size: 24.0,
        ),
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200]),
          child: InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: '点击搜索按钮');
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                  "搜索百万免费菜谱",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.email, color: Colors.white),
            ),
            onTap: () {
              Fluttertoast.showToast(msg: '点击Email按钮');
            },
          ),
        ],
      ),
      preferredSize: Size.fromHeight(50),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      floating: true,
      expandedHeight: ScreenUtil().setHeight(2000),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          height: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              SizedBox(height: 10.0),
//              _slogan(),
              SizedBox(height: 10.0),
              RecommendData(_recommendData[1]['video_info']),
              SizedBox(height: 10.0),
              Channel(_recommendData[2]['channel']),
              SizedBox(height: 10.0),
              Meals(_recommendData[3]['sancan']),
              SizedBox(height: 10.0),
              AdBanner(_recommendData[4]['zhuanti']),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
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
