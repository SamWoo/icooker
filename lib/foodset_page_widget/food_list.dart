import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/footer_tip.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'food_list_item.dart';

class FoodList extends StatefulWidget {
  var data;
  FoodList({this.data});

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList>
    with AutomaticKeepAliveClientMixin {
  var _list;
  // var type;
  var page;
  var data;
  var pageCount = 2;
  bool isLoading = false;

  bool isBottom = false;

  ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // type = widget.data['type'];
    data = widget.data;
    page = data['page'];

    print('data====$data');

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
      print('------>>$val');
      setState(() {
        _list = val;
      });
      print('>>>>>> $_list');
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
    return Column(
      children: <Widget>[
        Expanded(
          child: _list == null
              ? LoadingWidget()
              : StaggeredGridView.countBuilder(
                  primary: false,
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: _list.length,
                  // crossAxisSpacing: 1.0,
                  // mainAxisSpacing: 2.0,
                  itemBuilder: (BuildContext context, int index) {
                    return TileCard(
                      data: _list[index],
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Offstage(
            offstage: !isLoading,
            child: LoadingWidget(),
          ),
        )
      ],
    );
  }
}
