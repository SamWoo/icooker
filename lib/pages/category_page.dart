import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  final data;
  CategoryPage({this.data});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var _dataList;
  var _selected = 0;
  var _subCatesList = [];

  @override
  void initState() {
    super.initState();
    _dataList = json.decode(widget.data);
    _subCatesList.addAll(_dataList[0]['sub_cates']);
  }

  //随机改变子分类的背景颜色
  _getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    _buildLeft(index),
                itemCount: _dataList.length,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            color: Colors.grey,
            width: 0.5,
          ),
          Expanded(
            flex: 3,
            child: Container(
              // color: Colors.yellow,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.transparent,
                    child: _buildRight(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
      title: Text(
        '菜谱分类',
        style: TextStyle(fontSize: ScreenUtil().setSp(64), color: Colors.black),
      ),
      elevation: 0.5,
    );
  }

  //左边主类区域
  Widget _buildLeft(int index) {
    var item = _dataList[index];
    return GestureDetector(
      onTap: () {
        print('点击了-->${item['title']}');
        setState(() {
          _selected = index;
          _subCatesList.clear();
          _subCatesList.addAll(item['sub_cates']);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(96),
              height: ScreenUtil().setHeight(96),
              child: Image.network(
                  _selected == index ? item['icon_selected'] : item['icon']),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              item['title'],
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
                color: _selected == index ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //右边子分类区域
  Widget _buildRight() {
    var itemWidth = (MediaQuery.of(context).size.width * 0.75 - 30) / 3;
    return Wrap(
      spacing: 6.0,
      runSpacing: 12.0,
      children: _subCatesList.map((it) {
        return InkWell(
          onTap: () {
            Fluttertoast.showToast(msg: '点击子类-->${it['title']}');
            print('点击子类菜谱-->${it['title']}');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                //渐变色背景
                colors: [
                  _getRandomColor(),
                  _getRandomColor(),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border.all(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            width: itemWidth,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              it['title'],
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(42),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
