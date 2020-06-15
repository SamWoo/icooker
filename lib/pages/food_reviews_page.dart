import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/services/services_method.dart';

class FoodReviewsPage extends StatefulWidget {
  FoodReviewsPage({Key key}) : super(key: key);

  @override
  _FoodReviewsPageState createState() => _FoodReviewsPageState();
}

class _FoodReviewsPageState extends State<FoodReviewsPage> {
  var _tabList = [];
  @override
  void initState() {
    super.initState();
    getDetail(Config.SHIPING_TAB_URL).then((val) {
      setState(() {
        _tabList = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        // padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTabList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      flexibleSpace: Image.asset('assets/images/bar.jpg', fit: BoxFit.cover),
      title: Text(
        '食记',
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(56),
        ),
      ),
      centerTitle: true,
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
      width: ScreenUtil().setWidth(520),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        // color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.grey[300], BlendMode.modulate),
          image: NetworkImage(item['topic_img']),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
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
}
