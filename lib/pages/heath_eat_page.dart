import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/health_eat_page_widget/classify.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

class HeathEatPage extends StatefulWidget {
  HeathEatPage({Key key}) : super(key: key);

  @override
  _HeathEatPageState createState() => _HeathEatPageState();
}

class _HeathEatPageState extends State<HeathEatPage> {
  List _dataList = [];
  var _title;
  var _desc;
  var _ret;
  @override
  void initState() {
    super.initState();
    getHealthEatData().then((val) {
      setState(() {
        _ret = val;
        _dataList = val['items'] as List;
      });
    });
  }

  Future<void> _onRefresh() async {
    print('refresh.....');
    return;
  }

  @override
  Widget build(BuildContext context) {
    return _ret == null
        ? LoadingWidget()
        : Scaffold(
          backgroundColor: Colors.grey[300],
            body: RefreshIndicator(
              child: Stack(
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            _buildDetail(),
                            _buildDescItem(_dataList[0]),
                            _buildDescItem(_dataList[0]),
                            // _buildDescItem(_dataList[0]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: _buildSearch(context),
                    ),
                  )
                ],
              ),
              onRefresh: _onRefresh,
            ),
          );
  }

  Widget _buildDetail() {
    return Container(
      height: 420,
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildTitle(),
          _buildDesc(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: 180,
      child: Image.asset(
        'assets/images/scene.jpg',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 100,left: 10.0),
      // padding: EdgeInsets.only(left: 12.0),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_ret['title'],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(56), color: Colors.white)),
          SizedBox(height: 4.0),
          Text(_ret['desc'],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDesc() {
    return 
    Container(
      margin: EdgeInsets.only(top: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Classfiy(data: _dataList[0]),
    );
  }

  Widget _buildDescItem(var data){
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Classfiy(data: data),
    ); 
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: Colors.black54),
          SizedBox(width: 8.0),
          Text(_ret['search_default'],
              style: TextStyle(
                  color: Colors.black54, fontSize: ScreenUtil().setSp(42)))
        ],
      ),
    );
  }
}
