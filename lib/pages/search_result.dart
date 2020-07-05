import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/pages/recipe_list_item.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

class SearchResultPage extends StatefulWidget {
  final data;

  SearchResultPage({this.data});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  var data;
  List _list;
  var totalPage;
  var page = 1;
  bool loadMore = false; //是否上拉加载
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    data = json.decode(widget.data);
    page = data['page'];
    //滚动监听，滚动到底部加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          page < totalPage) {
        setState(() {
          loadMore = true;
        });
        page += 1;
        data['page'] = page;
        _loadData(data);
      }
    });
    //初始化加载数据
    _loadData(data);
  }

  //加载数据
  _loadData(var data) {
    getDataFromServer(Config.SEARCH_RESULT_URL, data: data).then((val) {
      // debugPrint("val====>$val");
      List tempList = [];
      (val['items'] as List).forEach((it) {
        if (it.containsKey('recipe')) tempList.add(it);
      });
      setState(() {
        totalPage = val['total_page'];
        if (loadMore) {
          loadMore = false;
          _list.addAll(tempList);
        } else {
          _list = [];
          // debugPrint('_list===$_list');
          _list = tempList;
        }
      });
    });
  }

  //下拉刷新
  Future _onRefresh() async {
    try {
      _list.clear();
      data['page'] = 1;
      _loadData(data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, data['keyword']),
      body: _list == null
          ? LoadingWidget()
          : RefreshIndicator(child: _buildBody(), onRefresh: _onRefresh),
    );
  }

  Widget _buildAppBar(BuildContext context, var title) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
      leading: InkWell(
        child: Icon(Icons.arrow_back_ios, color: Colors.black),
        onTap: () => Navigator.pop(context),
      ),
      centerTitle: true,
      titleSpacing: 0.0,
      title: Text(
        title,
        style: TextStyle(fontSize: ScreenUtil().setSp(64), color: Colors.black),
      ),
      elevation: 0.5,
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: 4,
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) {
              return TileCard(
                data: _list[index],
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          ),
        ),
        Offstage(
          offstage: !loadMore,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: SpinKitFadingCircle(
                color: Colors.red,
                size: 24.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
