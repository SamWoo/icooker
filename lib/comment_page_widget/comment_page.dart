import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/services_method.dart';
import 'package:icooker/widgets/loading_widget.dart';

import 'comment_list_item.dart';

class CommentPage extends StatefulWidget {
  final data;
  CommentPage({this.data});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var data;
  var commentList;
  var page = 1;
  var totalAmount;
  var totalPage;
  bool loadMore = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    data = json.decode(widget.data);
    commentList = data['commentList'];
    totalAmount = data['totalAmount'];
    totalPage = data['totalPage'];

    //给_scrollController添加监听
    _scrollController.addListener(() {
      //判断是否滑动到了页面的最底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //如果不是最后一页数据，则生成的数据添加到mlist中
        if (page < totalPage) {
          _retrieveData();
        }
      }
    });
  }

  void _retrieveData() {
    //get more comments
    getDataFromServer(Config.COMMENT_URL, data: {
      'id': data['id'],
      'filter': 'all',
      'type': '0',
      'page': ++page,
      'per_page': '10'
    }).then((val) {
      setState(() {
        commentList.addAll(val['items']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildCommentList(context),
    );
  }

  //AppBar
  Widget _buildAppBar(BuildContext context) {
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
        '共${totalAmount}条热门评论',
        style: TextStyle(fontSize: ScreenUtil().setSp(64), color: Colors.black),
      ),
      elevation: 0.5,
    );
  }

  //评论列表
  Widget _buildCommentList(BuildContext context) {
    return commentList == null
        ? LoadingWidget()
        : Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 48.0),
                child: ListView.builder(
                  controller: _scrollController,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: commentList.length + 1,
                  itemBuilder: _commentListItem,
                ),
              ),
              Positioned(
                child: _publishComment(),
                bottom: 0,
                left: 0,
                right: 0,
              ),
            ],
          );
  }

  Widget _commentListItem(BuildContext context, int index) {
    return index == commentList.length
        ? _loadingTip()
        : CommentListItem(listItem: commentList[index]);
  }

  //加载提示信息
  Widget _loadingTip() {
    return page < totalPage
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

  //发表评论
  Widget _publishComment() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      padding: EdgeInsets.all(8.0),
      height: 48.0,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16.0,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              // controller: _controller,
              textInputAction: TextInputAction.search,
              minLines: 1,
              maxLines: 1,
              cursorColor: Colors.red,
              cursorRadius: Radius.circular(3),
              cursorWidth: 2,
              showCursor: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                hintText: "来说点什么吧！",
                // border: InputBorder.none,
              ),
              onChanged: (v) {},
              onEditingComplete: () {
                // _actionDone(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
