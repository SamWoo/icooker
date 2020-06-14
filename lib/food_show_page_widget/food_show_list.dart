import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/footer_tip.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'food_show_list_item.dart';

class FoodShowList extends StatefulWidget {
  var data;

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
    getFoodShowData(data).then((val) {
      // debugPrint('------>>$val');
      setState(() {
        _list = val;
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

    getFoodShowData(data).then((val) {
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
                  shrinkWrap: true,
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: _list.length,
                  // crossAxisSpacing: 1.0,
                  // mainAxisSpacing: 2.0,
                  itemBuilder: (BuildContext context, int index) {
                    // if (index == _list.length - 1) _retrieveData();
                    return FoodShowCard(
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
        ),
        Visibility(
          visible: false,
          child: FooterTip(),
        ),
      ],
    );
  }
}
