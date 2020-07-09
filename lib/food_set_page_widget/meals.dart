import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'dart:convert' as convert;

class Meals extends StatefulWidget {
  final data;
  Meals(this.data);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> with SingleTickerProviderStateMixin {
  PageController mPageController = PageController(initialPage: 0);
  TabController mTabController;
  var _data;
  var currentPage = 0;
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    mTabController = TabController(length: _data.length, vsync: this);
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) {
        debugPrint('tab_index====>${mTabController.index}');
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
    mPageController.dispose();
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(900),
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPageTitles(),
          Expanded(child: _buildPageView())
        ],
      ),
    );
  }

  Widget _buildPageTitles() {
    return Container(
      // color:Colors.yellow,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bar03.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white60, BlendMode.modulate),
        ),
      ),
//       alignment: Alignment.center,
      height: ScreenUtil().setHeight(128),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: TabBar(
        tabs: _data.map<Widget>((it) {
          return Tab(text: it['title']);
        }).toList(),
        isScrollable: false,
        controller: mTabController,
        labelColor: Colors.black,
        labelPadding: EdgeInsets.all(4),
        labelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(56),
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: Colors.grey[600],
        unselectedLabelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(48),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget _buildPageView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: PageView.builder(
        controller: mPageController,
        itemCount: _data.length,
        itemBuilder: _buildItem,
        onPageChanged: (index) {
          print('index===>$index');
          if (isPageCanChanged) {
            onPageChange(index);
          }
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var items = _data[index]['items'];
    var itemWidth = (MediaQuery.of(context).size.width - 24) / 2;
    var itemHeight = ScreenUtil().setHeight(600);
    return Container(
      // color: Colors.yellow,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Flex(
        direction: Axis.horizontal,
        children: items.map<Widget>((it) {
          return GestureDetector(
            onTap: () {
              var data = {"id": it['id']};
              getDataFromServer(Config.RECIPE_DETAIL_URL, data: data)
                  .then((val) {
                Routes.navigateTo(context, '/recipeDetail',
                    params: {'data': convert.jsonEncode(val)});
              });
            },
            child: Container(
              // color: Colors.green,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: itemWidth,
                    height: itemHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: it['img'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    width: itemWidth,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      it['title'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: itemWidth,
                    padding: EdgeInsets.all(4.0),
                    color: Color(0xfff4cbcb),
                    child: Text(
                      '# ${it['desc']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xfff77e7e),
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
