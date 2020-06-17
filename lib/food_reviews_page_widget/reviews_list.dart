import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/food_reviews_page_widget/ninth_palace.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FoodReviewsList extends StatefulWidget {
  final data;
  FoodReviewsList({this.data});

  @override
  _FoodReviewsListState createState() => _FoodReviewsListState();
}

class _FoodReviewsListState extends State<FoodReviewsList>
    with AutomaticKeepAliveClientMixin {
  var pageCount = 1; //总页码数
  var page = 1;
  var sort; //类型:hot->最热 time->最新
  var url;
  var _list; //返回的数据列表items

  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    sort = widget.data['sort'];

    //获取数据
    switch (sort) {
      case 'hot':
        url = Config.SHIPING_HOT_URL;
        break;
      case 'time':
        url = Config.SHIPING_TIME_URL;
        break;
      default:
    }
    getDataFromServer(url, data: widget.data).then((val) {
      setState(() {
        pageCount = val['total_page'];
        _list = val['items'] as List;
      });
    });

    //给_scrollController添加监听
    _scrollController.addListener(() {
      //判断是否滑动到了页面的最底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //如果不是最后一页数据，则生成的数据添加到mlist中
        if (page < pageCount) {
          _retrieveData();
        }
      }
    });
  }

  //上拉加载新的数据
  void _retrieveData() {
    widget.data['page'] = ++page;
    getDataFromServer(url, data: widget.data).then((val) {
      setState(() {
        _list.addAll(val['items']);
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
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _list == null
          ? LoadingWidget()
          : ListView.builder(
              controller: _scrollController,
              primary: false,
              shrinkWrap: true,
              itemBuilder: _buildListItem,
              itemCount: _list.length + 1,
            ),
    );
  }

  //ListView Item
  Widget _buildListItem(BuildContext context, int index) {
    return index == _list.length
        ? _loadingTip()
        : Card(
            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildAuthorInfo(_list[index]['author_info']),
                  _buildTopList(_list[index]['sp_content']['top_list']),
                  _buildSocialTools(),
                  _buildContent(_list[index]['sp_content']),
                  _buildGoodsInfo(_list[index]['goods_infos']),
                ],
              ),
            ),
          );
  }

  //加载提示信息
  Widget _loadingTip() {
    return page < pageCount
        ? Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('─ ♨我是有底线的!!!♨ ─',
                style: TextStyle(color: Colors.blueGrey)),
          );
  }

  //author_info
  Widget _buildAuthorInfo(var item) {
    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
              item['avatar'],
            ),
          ),
          SizedBox(width: 4.0),
          Container(
            width: ScreenUtil().setWidth(400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item['user_name'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  item['time'],
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(36)),
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
              onPressed: () {})
        ],
      ),
    );
  }

  //点赞等操作
  Widget _buildSocialTools() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        // color: Colors.blue,
        width: ScreenUtil().setWidth(480),
        height: ScreenUtil().setHeight(140),
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildIcon(FontAwesome.thumbs_up, '点赞'),
            _buildIcon(FontAwesome.star_o, '收藏'),
            _buildIcon(FontAwesome.commenting_o, '评论'),
            _buildIcon(FontAwesome.share, '分享'),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(var icon, var title) {
    return GestureDetector(
      onTap: () => Fluttertoast.showToast(msg: '点击 $title 按钮'),
      child: Column(
        children: <Widget>[
          Icon(icon, color: Colors.grey[700], size: 16.0),
          SizedBox(height: 4.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: ScreenUtil().setSp(32),
            ),
          )
        ],
      ),
    );
  }

  //推荐商品图片展示(九宫格模式)
  Widget _buildTopList(var item) {
    return NinthPalace(data: item);
  }

  ///content
  Widget _buildContent(var item) {
    return Container(
      child: Text(
        item['content'],
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black87,
          fontSize: ScreenUtil().setSp(48),
        ),
      ),
    );
  }

  ///goods_infos
  Widget _buildGoodsInfo(var item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 48.0,
            width: 48.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(item[0]['img'], fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(480),
                child: Text(
                  item[0]['title'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                children: <Widget>[
                  Text(
                    "¥ ${item[0]['price']}",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil().setSp(56),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "¥ ${item[0]['discount_price']}",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough, //删除线
                      fontSize: ScreenUtil().setSp(40),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          ActionChip(
            avatar: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 16.0,
            ),
            label: Text(
              '去购买',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(40),
              ),
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
            backgroundColor: Color(0xfff76262),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
