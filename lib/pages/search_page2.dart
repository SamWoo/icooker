import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/search_widget/search_item.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final data;

  SearchPage({this.data});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  var hotWords;

  @override
  void initState() {
    super.initState();
    hotWords = json.decode(widget.data);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
      leading: InkWell(
        child: Icon(Icons.arrow_back_ios, color: Colors.black),
        onTap: () => Navigator.pop(context),
      ),
      centerTitle: true,
      titleSpacing: 0.0,
      title: _buildTextField(context),
      actions: <Widget>[
        _buildActions(context),
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: ScreenUtil().setHeight(100),
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.grey[700]),
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: <Widget>[
          Icon(
            EvilIcons.search,
            color: Colors.grey[700],
            size: 20,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              minLines: 1,
              maxLines: 1,
              cursorColor: Colors.red,
              cursorRadius: Radius.circular(3),
              cursorWidth: 2,
              showCursor: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                hintText: "搜索你感兴趣的",
                border: InputBorder.none,
              ),
              onChanged: (v) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          "搜索",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(48),
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Ionicons.md_flame,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('大家都在搜',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            SearchItemView(
              type: "hot_search",
              data: hotWords,
            ),
            ListTile(
              dense: true,
              title: Text(
                '历史记录',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                EvilIcons.trash,
                size: 32.0,
                // color: Colors.red,
              ),
              contentPadding: EdgeInsets.all(0.0),
              onTap: () => print('Delete all history?'),
            ),
            SearchItemView()
          ],
        ),
      ),
    );
  }
}
