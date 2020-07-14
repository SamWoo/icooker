import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'recipe_list_item.dart';

class RecipeList extends StatefulWidget {
  final data;

  RecipeList({this.data});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList>
    with AutomaticKeepAliveClientMixin {
  var _list;

  // var type;
  var page;
  var data;
  var pageCount = 5;
  bool isLoading = false;

  bool isBottom = false;

  ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    data = widget.data;
    page = data['page'];
    
    _scrollController.addListener(() {
      var maxPosition = _scrollController.position.maxScrollExtent;
      bool val =
          _scrollController.position.pixels == maxPosition ? true : false;

      if (val && page < pageCount) {
        setState(() {
          //显示加载更多或到底信息
          isLoading = val;
        });
        Future.delayed(Duration(milliseconds: 200))
            .then((e) => _retrieveData());
      }
    });

    //获取初始数据
    getFoodSetData(data).then((val) {
      setState(() {
        _list = val;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  //上拉加载数据
  Future<void> _retrieveData() async {
    page++;
    data['page'] = page;

    getFoodSetData(data).then((val) {
      setState(() {
        isLoading = false;
        _list.addAll(val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: _list == null
              ? LoadingWidget()
              : StaggeredGridView.countBuilder(
                  // primary: true,
                  // physics: NeverScrollableScrollPhysics(),
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
          offstage: !isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
