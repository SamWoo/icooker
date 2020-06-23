import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/widgets/loading_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final data;
  WebViewPage({this.data});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    data = convert.jsonDecode(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    print('url==>${data['initUrl']}');
    return Scaffold(
      appBar: data['showBar'] ? _buildAppBar() : null,
      body: Stack(children: <Widget>[
        WebView(
          initialUrl: data['initUrl'], //初始化url
          javascriptMode: JavascriptMode.unrestricted, //js执行模式
          onWebViewCreated: (WebViewController webViewController) {
            //仅在webView被创建完成后调用一次
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            //js与flutter通信的Channel
            _toasterJavascriptChannel(context),
          ].toSet(),

          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.baidu.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
        isLoading ? LoadingWidget() : Container(),
      ]),

      // floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.favorite, color: Colors.red),
            );
          }
          return Container();
        });
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      flexibleSpace: Image.asset('assets/images/bar.png', fit: BoxFit.cover),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        data['title'],
        style: TextStyle(fontSize: ScreenUtil().setSp(56), color: Colors.black),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            onPressed: null)
      ],
    );
  }
}
