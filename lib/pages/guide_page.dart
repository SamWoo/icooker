import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/mock/mock_data.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/utils/spHelper.dart';

class GuidePage extends StatefulWidget {
  GuidePage({Key key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

var _currentIndex = 0;

class _GuidePageState extends State<GuidePage> {
  final List<String> _list = MOCKDATA.GUIDE_IMAGE_LIST;
  PageController _controller;
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    //设置定时器控制PageView自动轮播广告页
    _controller = PageController(
      initialPage: _currentIndex,
    );
    _timer = Timer.periodic(Duration(seconds: 5), (_timer) {
      _controller.animateToPage(
          //return the first page when the index go to last
          _currentIndex == _list.length - 1
              ? _currentIndex = 0
              : _currentIndex + 1,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //pageview
        PageView.builder(
          itemBuilder: _buildViewPage,
          itemCount: _list.length,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        //indicator
        Positioned(
          bottom: 20.0,
          child: Container(
            // width: MediaQuery.of(context).size.width / 2.0,
            color: Colors.transparent,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: DotsIndicator(
                controller: _controller,
                itemCount: _list.length,
                // color: Colors.redAccent,
                onPageSelected: (int page) => _controller.animateToPage(page,
                    duration: _kDuration, curve: _kCurve),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewPage(BuildContext context, int index) {
    var item = _list[index];

    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Center(
              child: Container(
                width: 48.0,
                height: 48.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          index == _list.length - 1
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: OutlineButton(
                      child: Text(
                        '立即体验',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.red),
                      splashColor: Colors.redAccent,
                      highlightedBorderColor: Colors.redAccent,
                      shape: StadiumBorder(),
                      onPressed: () async {
                        await SpHelper.putBool(Config.KEY_FIRST_LOGIN, false);
                        Routes.navigateTo(context, '/home',
                            clearStack: true); // 跳转到主页
                      },
                    ),
                  ),
                )
              : Align(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }
}

//底部指示器
class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      {this.controller,
      this.itemCount,
      this.onPageSelected,
      this.color: Colors.grey})
      : super(listenable: controller);

  // The PageController that this DotsIndicator is representing.
  final PageController controller;
  //The number of items managed by the PageController
  final int itemCount;
  //Called when a dot is tapped
  final ValueChanged<int> onPageSelected;
  //Defaults to `Colors.white`.
  final Color color;
  //The base size of the dots
  static const double _kDotSize = 8.0;
  //The increase in the size of the selected dot
  static const double _kDotSpacing = 25.0;
  //The increase in the size of the selected dot
  static const double _kMaxZoom = 1.5;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(onTap: () {}),
          ),
          color: index == _currentIndex ? Colors.redAccent : Colors.grey,
          type: MaterialType.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Row(children: List<Widget>.generate(itemCount, _buildDot));
}
