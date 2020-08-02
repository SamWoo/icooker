import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/footer_tip.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'food_show_list_item.dart';

class FoodShowList extends StatefulWidget {
  final data;

  FoodShowList({this.data});

  @override
  _FoodShowListState createState() => _FoodShowListState();
}

class _FoodShowListState extends State<FoodShowList>
    with AutomaticKeepAliveClientMixin {
  var _list;
  var type;
  var page;
  var id;
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
    data = widget.data;
    page = data['page'];

    debugPrint('foodShowData====>$data');

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
    getDataFromServer(Config.FOOD_SHOW_DATA_URL, data: data).then((val) {
      // debugPrint('------>>$val');
      var tempList = val['items'] as List;
      tempList.forEach((it) {
        //屏蔽广告信息
        if (it.containsKey('ad')) tempList.remove(it);
      });
      setState(() {
        _list = tempList;
      });
      // debugPrint('>>>>>> $_list');
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

    getDataFromServer(Config.FOOD_SHOW_DATA_URL, data: data).then((val) {
      setState(() {
        isLoading = false;
        _list.addAll(val['items'] as List);
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
                  primary: false,
                  shrinkWrap: true,
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FoodShowCard(
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
