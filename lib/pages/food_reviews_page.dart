import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/food_reviews_page_widget/reviews_list.dart';
import 'package:icooker/services/services_method.dart';

class FoodReviewsPage extends StatefulWidget {
  FoodReviewsPage({Key key}) : super(key: key);

  @override
  _FoodReviewsPageState createState() => _FoodReviewsPageState();
}

class _FoodReviewsPageState extends State<FoodReviewsPage>
    with SingleTickerProviderStateMixin {
  var _tabList = [];
  var _tabTitles = ['最热', '最新'];
  var hotData = [];
  var pageCount = 1;
  TabController mTabController;

  @override
  void initState() {
    super.initState();
    mTabController = TabController(length: _tabTitles.length, vsync: this);
    //获取AppBar下面的List数据
    getDataFromServer(Config.SHIPING_TAB_URL).then((val) {
      setState(() {
        _tabList = val;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTabList(),
            _buildTabBar(),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
      title: Text(
        '食记',
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(56),
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildTabList() {
    return Container(
      // color: Colors.blue,
      height: ScreenUtil().setHeight(300),
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: ListView.builder(
        itemBuilder: _buildListItem,
        itemCount: _tabList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    var item = _tabList[index];
    return Container(
      width: ScreenUtil().setWidth(480),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage('assets/images/placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.mode(Colors.grey[400], BlendMode.modulate),
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: item['topic_img'],
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
          ),
          Container(
            padding: EdgeInsets.only(top: 8.0, left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item['topic_title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item['topic_text'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    item['topic_click'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      // color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      height: ScreenUtil().setHeight(140),
      child: TabBar(
        tabs: _tabTitles.map<Widget>((it) {
          return Tab(text: it);
        }).toList(),
        isScrollable: true,
        controller: mTabController,
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(56),
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: Colors.grey[600],
        unselectedLabelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(42),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.red,
        indicatorWeight: 4.0,
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: TabBarView(
        controller: mTabController,
        children: [
          FoodReviewsList(data: {'sort': 'hot', 'page': 1}),
          FoodReviewsList(data: {'sort': 'time', 'page': 1}),
        ],
      ),
    );
  }
}
