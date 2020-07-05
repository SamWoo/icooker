import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[700],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          isShow ? _buildBarTitle() : Text(''),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[700],
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
      color: Colors.white,
      height: ScreenUtil().setHeight(140),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildIcon(commentAmount, Icons.chat, Colors.blue),
          SizedBox(width: 8.0),
          _buildIcon(favorAmount, Icons.favorite, Colors.red),
          SizedBox(width: 8.0),
          _buildIcon(viewedAmount, Icons.visibility, Colors.green),
          SizedBox(width: 8.0),
          _buildIcon(zanNum, Icons.thumb_up, Colors.yellow),
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
      margin: EdgeInsets.symmetric(horizontal:4.0,vertical:8.0),
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
                  fontSize: ScreenUtil().setSp(56),
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
    var content = it['content'] == null ? "" : it['content'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Text(
        it['content']??'',
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(48),
        ),
      ),
    );
  }
}
