import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/pages/webview_page.dart';

class FoodShowPage extends StatefulWidget {
  FoodShowPage({Key key}) : super(key: key);

  @override
  _FoodShowPageState createState() => _FoodShowPageState();
}

class _FoodShowPageState extends State<FoodShowPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewPage(
          data:
              json.encode({'initUrl': Config.FOOD_SHOW_URL, 'showBar': false})),
    );
  }
}
