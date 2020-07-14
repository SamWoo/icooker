import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/pages/recipe_list_item.dart';
import 'package:icooker/provider/search_result_provider.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  final data;

  SearchResultPage({this.data});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  RecipeModel model = RecipeModel();

  var data;
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
          page < model.totalPage) {
        page += 1;
        data['page'] = page;
        model.loadSearchData(Config.SEARCH_RESULT_URL, parameters: data);
      }
    });
    //初始化加载数据
    model.loadSearchData(Config.SEARCH_RESULT_URL, parameters: data);
  }

  //下拉刷新
  Future _onRefresh() async {
    try {
      data['page'] = 1;
      model.loadSearchData(Config.SEARCH_RESULT_URL, parameters: data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, data['keyword']),
      body: RefreshIndicator(
          child: ChangeNotifierProvider<RecipeModel>(
            create: (_) => model,
            child: Consumer<RecipeModel>(builder: (_, model, child) {
              return model.recipeData == null
                  ? LoadingWidget()
                  : _buildBody(model);
            }),
          ),
          onRefresh: _onRefresh),
    );
  }

  Widget _buildAppBar(BuildContext context, var title) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
      leading: InkWell(
        child: Icon(Icons.arrow_back_ios, color: Colors.black),
        onTap: () => Routes.pop(context),
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

  Widget _buildBody(RecipeModel model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: 4,
            itemCount: model.recipeData == null ? 0 : model.recipeData.length,
            itemBuilder: (BuildContext context, int index) {
              return TileCard(
                data: model.recipeData[index],
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
