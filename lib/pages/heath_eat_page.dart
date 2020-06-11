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
            appBar: _buildAppBar(),
            body: RefreshIndicator(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    _buildTitle(),
                    Positioned(
                      top: -16.0,
                      child: Container(
                        // height: 160,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0)),
                        ),
                        child: Column(
                          children: _dataList.map<Widget>((it) {
                            return Classfiy(data: it);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onRefresh: _onRefresh,
            ),
          );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 12.0, left: 16.0),
      color: Colors.red,
      height: 64,
      width: double.infinity,
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

  Widget _buildAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      // toolbarOpacity: 0.1,
      elevation: 0,
      title: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), color: Colors.white),
          child: Row(
            children: <Widget>[
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8.0),
              Text(_ret['search_default'],
                  style: TextStyle(
                      color: Colors.black54, fontSize: ScreenUtil().setSp(42)))
            ],
          )),
    );
  }
}
