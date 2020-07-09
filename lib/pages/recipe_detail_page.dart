import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/comment_page_widget/comment_list_item.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';
import 'dart:convert' as convert;

class RecipeDetailPage extends StatefulWidget {
  final data;
  RecipeDetailPage({this.data});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  var _ret;
  bool isShow = false; //控制显示title标志
  double opacity = 0;
  ScrollController _scrollController;
  List commentList;
  var page = 1;
  var totalPage;
  var totalAmount;
  // var itemCount;

  @override
  void initState() {
    super.initState();
    _ret = convert.jsonDecode(widget.data);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      var val = _scrollController.position.pixels > 100.0 ? true : false;
      var tmp = _scrollController.position.pixels / 400.0;

      setState(() {
        isShow = val;
        opacity = tmp < 0.8 ? tmp : 0.8;
      });
    });

    //get comments
    getDataFromServer(Config.COMMENT_URL, data: {
      'id': _ret['id'],
      'filter': 'all',
      'type': '0',
      'page': page,
      'per_page': '10'
    }).then((val) {
      setState(() {
        commentList = val['items'] as List;
        totalAmount = int.parse(val['total_amount']);
        totalPage = val['total_page'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _ret == null
          ? LoadingWidget()
          : Stack(
              children: <Widget>[
                CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(children: <Widget>[
                        _buildImage(),
                        _buildDesc(),
                      ]),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: _buildAppBar(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildFavor(),
                ),
              ],
            ),
    );
  }

  Widget _buildAppBar() {
    debugPrint('opacity==$opacity');
    return Container(
      color: Color.fromRGBO(255, 255, 255, opacity),
      padding: EdgeInsets.only(top: 16.0),
      // height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          isShow ? _buildBarTitle() : Text(''),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBarTitle() {
    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16.0,
            backgroundImage: NetworkImage(
              _ret['author']['avatar_url'],
            ),
          ),
          SizedBox(width: 4.0),
          Text(
            _ret['title'],
            style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(56),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    var _width = MediaQuery.of(context).size.width;
    return Hero(
      tag: _ret['id'],
      child: Container(
        width: _width,
        child: AspectRatio(
          aspectRatio: 0.9,
          child: CachedNetworkImage(
            imageUrl: _ret['cover_img']['big'],
            fit: BoxFit.fill,
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildDesc() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(),
          SizedBox(height: 8.0),
          _buildAuthor(),
          SizedBox(height: 10.0),
          _buildCookSteps()
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        _ret['title'],
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(64),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAuthor() {
    var author = _ret['author'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24.0,
            backgroundImage: NetworkImage(
              author['avatar_url'],
            ),
          ),
          SizedBox(width: 4.0),
          Container(
            width: ScreenUtil().setWidth(400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  author['nickname'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blueGrey, fontSize: ScreenUtil().setSp(48)),
                ),
                SizedBox(height: 4.0),
                Text(
                  "${author['pub_recipe_num']}篇作品",
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(42)),
                ),
              ],
            ),
          ),
          Spacer(),
          ActionChip(
            label: Text(
              "+ 关注",
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(40),
              ),
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
            backgroundColor: Color(0xfff76262),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  //点赞等信息
  Widget _buildFavor() {
    var favorAmount = _ret['favor_amount'];
    var viewedAmount = _ret['viewed_amount'];
    var commentAmount = _ret['comment_amount'];
    var zanNum = _ret['zan_num'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.3, color: Colors.grey),
      ),
      height: ScreenUtil().setHeight(120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () => _showModalBottomSheet(),
            child: _buildIcon(
                commentAmount, FontAwesome.commenting_o, Colors.blue),
          ),
          SizedBox(width: 8.0),
          _buildIcon(favorAmount, Icons.favorite, Colors.red),
          SizedBox(width: 8.0),
          _buildIcon(zanNum, FontAwesome.thumbs_up, Colors.green),
          SizedBox(width: 8.0),
          _buildIcon(viewedAmount, Icons.visibility, Colors.orange),
        ],
      ),
    );
  }

  ///点赞小图标
  Widget _buildIcon(var str, var icon, var color) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(icon, size: 24, color: color),
          SizedBox(width: 2.0),
          Text(
            str,
            style: TextStyle(
                color: Colors.blueGrey, fontSize: ScreenUtil().setSp(48)),
          ),
        ],
      ),
    );
  }

  ///美食做法步骤
  Widget _buildCookSteps() {
    List cookSteps = _ret['cook_steps'] as List;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        children: cookSteps.map<Widget>((it) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildStepPic(it),
                _buildStepContent(it),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  ///每一步的图片视图
  Widget _buildStepPic(var it) {
    var _width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          width: _width,
          height: _width * 0.9,
          imageUrl: it['pic_urls'][0]['big'],
          fit: BoxFit.fill,
        ),
        Positioned(
          left: 0,
          top: 20.0,
          child: Container(
            height: 36,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Center(
              child: Text(
                it['title'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(42),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///每一步的内容介绍
  Widget _buildStepContent(var it) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Text(
        it['content'] ?? '',
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(48),
        ),
      ),
    );
  }

  //评论modal弹窗
  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true, //modal是否全屏展示
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
      builder: (BuildContext context) {
        return commentList == null
            ? LoadingWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 48.0,
                    child: Text(
                      '全部 $totalAmount 条评论',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: commentList.length + 1,
                      itemBuilder: _commentListItem,
                    ),
                  ),
                ],
              );
      },
    );
  }

  //评论项
  Widget _commentListItem(BuildContext context, int index) {
    return index == commentList.length
        ? GestureDetector(
            onTap: () => _toCommentListPage(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text('加载更多评论'),
              ),
            ),
          )
        : CommentListItem(listItem: commentList[index]);
  }

  //跳转评论列表页面
  _toCommentListPage() {
    var data = {
      'id': _ret['id'],
      'commentList': commentList,
      'totalAmount': totalAmount,
      'totalPage': totalPage
    };
    Routes.navigateTo(context, '/comment', params: {'data': json.encode(data)});
  }
}
