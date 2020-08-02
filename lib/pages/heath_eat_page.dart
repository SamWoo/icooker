import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/health_eat_page_widget/classify.dart';
import 'package:icooker/mock/mock_data.dart';
import 'package:icooker/widgets/loading_widget.dart';
import 'package:icooker/config/Config.dart';

class HeathEatPage extends StatefulWidget {
  HeathEatPage({Key key}) : super(key: key);

  @override
  _HeathEatPageState createState() => _HeathEatPageState();
}

class _HeathEatPageState extends State<HeathEatPage> {
  List _dataList = [];
  var _ret;
  @override
  void initState() {
    super.initState();
    //fetch mock data
    Future.delayed(Duration(milliseconds: 200)).then((val) => setState(() {
          _ret = MOCKDATA.HEALEAT_DATA['data'];
          _dataList = _ret['items'] as List;
        }));
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
            backgroundColor: Colors.grey[200],
            body: RefreshIndicator(
              child: CustomScrollView(
                slivers: <Widget>[
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Column(
                      children: _dataList.map<Widget>((it) {
                        return _buildDescItem(it);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              onRefresh: _onRefresh,
            ),
          );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      expandedHeight: ScreenUtil().setHeight(360),
      elevation: 0,
      title: _buildSearchBar(),
      pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax, //时差模式
        background: _buildFlexibleSpace(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: Colors.grey[700]),
          SizedBox(width: 8.0),
          Text(_ret['search_default'],
              style: TextStyle(
                  color: Colors.grey[700], fontSize: ScreenUtil().setSp(36)))
        ],
      ),
    );
  }

  Widget _buildFlexibleSpace() {
    return Container(
      child: Stack(
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey[400], BlendMode.modulate),
            child: Image.asset(
              'assets/images/scene.png',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 24.0,
            left: 16.0,
            child: _buildTitle(),
          ),
          Positioned(
            bottom: 0,
            height: 16,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
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
    );
  }

  Widget _buildDescItem(var data) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Classfiy(data: data),
    );
  }
}
