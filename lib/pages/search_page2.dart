import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/bean/history.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/sqflite/search_history_provider.dart';

class SearchPage extends StatefulWidget {
  final data;

  SearchPage({this.data});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  SearchHistoryProvider provider = SearchHistoryProvider();

  List<String> histories;
  var hotWords;

  @override
  void initState() {
    super.initState();
    hotWords = json.decode(widget.data);

    _getHistory().then((val) {
      List<String> tempList = [];
      val.forEach((it) {
        tempList.add(it.name);
      });
      setState(() {
        histories = tempList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
  }

  //获取搜索历史
  Future<List<SearchHistory>> _getHistory() async {
    return provider.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, //为避免当TextField 获取焦点弹出输入框时，输入框可能会将页面中元素顶上去
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
        borderRadius: BorderRadius.circular(8.0),
      ),
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
              controller: _controller,
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
              onEditingComplete: () {
                _actionDone(context);
              },
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
        _actionDone(context);
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
            _buildHotWords(context),
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
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => _buildCupertinoAlertDialog(context)),
            ),
            _buildSearchHistory(),
          ],
        ),
      ),
    );
  }

  //热搜关键字
  Widget _buildHotWords(context) {
    return hotWords != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: hotWords
                  .map<Widget>(
                    (it) => _buildHotItem(context, it),
                  )
                  .toList(),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(child: Text('发现更多美食')),
          );
  }

  Widget _buildHotItem(BuildContext context, var it) {
    var itemWidth = (MediaQuery.of(context).size.width - 24) / 3;
    return InkWell(
      onTap: () => _navigationToResult(it['title']),
      child: Container(
        width: itemWidth,
        height: itemWidth * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/placeholder.png'),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                width: itemWidth,
                imageUrl: it['img'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "# ${it['title']}",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //搜索历史
  Widget _buildSearchHistory() {
    return histories != null
        ? Container(
            child: Wrap(
              spacing: 8.0,
              children: histories.map<Widget>((it) {
                return Chip(
                  label: Text(it,
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  onDeleted: () {
                    setState(() {
                      histories.remove(it);
                    });
                    provider.deleteData(it);
                  },
                  backgroundColor: _getRandomColor(),
                );
              }).toList(),
            ),
          )
        : Container(
            child: Center(
              child: Text(
                "(Ｔ▽Ｔ)暂无搜索记录!",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          );
  }

  Widget _buildCupertinoAlertDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: Text(
          '清空历史记录',
          style: TextStyle(
            color: Colors.red,
            fontSize: ScreenUtil().setSp(48),
          ),
        ),
        content: Text(
          '是否确定要清空历史记录?',
          style: TextStyle(
            color: Colors.black87,
            fontSize: ScreenUtil().setSp(42),
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('确定!'),
            onPressed: () {
              Navigator.pop(context);
              _deleteAllHistory();
            },
          ),
          CupertinoButton(
            child: Text('我再想想!'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  //点击搜索按钮或软键盘搜索按钮
  _actionDone(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    _navigationToResult(_controller.text);
    _saveToDB(_controller.text);
  }

  //跳转搜索结果页面
  _navigationToResult(var searchStr) {
    Fluttertoast.showToast(msg: '搜索关键字-->$searchStr');
    print('搜索关键字-->$searchStr');
    var data = {
      'cid': '',
      'keyword': searchStr,
      'order': '-hot',
      'page': 1,
      'per_page': 10
    };
    Routes.navigateTo(context, '/searchResult',
        params: {'data': json.encode(data)});
  }

  // 保存搜索记录到数据库
  _saveToDB(var searchWord) async {
    if (!histories.contains(searchWord)) {
      setState(() {
        histories.add(searchWord);
      });
    }
    await provider.saveData(SearchHistory(searchWord));
  }

  //删除数据所有记录
  _deleteAllHistory() async {
    setState(() {
      histories.clear();
    });
    provider.deleteAllData();
  }

  //获取随机背景色
  _getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(240),
        Random.secure().nextInt(240), Random.secure().nextInt(240));
  }
}
