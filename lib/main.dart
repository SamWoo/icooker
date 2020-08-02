import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icooker/pages/guide_page.dart';
import 'package:icooker/pages/splash_page.dart';
import 'package:icooker/router/routes.dart';
import 'package:provider/provider.dart';

import 'config/Config.dart';
import 'provider/app_info_provider.dart';
import 'utils/spHelper.dart';

void main() {
  /**
   * 在每一次启动时进行判断，这个过程必须是同步的，
   * 但flutter提供的shared_preferences和package_info却都是异步的,
   * 这就导致获取值及路由跳转不同步问题。
   * 解决方法：  
   *  在main入口方法中先调用初始化方法，再去调用runApp方法，
   *  这样就可以将 “异步” 操作 转化成 “同步” 操作
   */
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 1.7.8+版本必须加，否则报错

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    // 底色透明是否生效与Android版本有关，版本过低设置无效
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //全局设置透明
      // statusBarIconBrightness: Brightness.light
      //light:黑色图标  dark:白色图标
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  realRunApp();
}

void realRunApp() async {
  await SpHelper.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _colorKey;
  bool _firstKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 配置路由
    final router = Router();
    Routes.configureRouters(router);
    Routes.router = router;
    // 主题颜色值
    Color _themeColor;
    _colorKey = SpHelper.getString(Config.KEY_THEME_COLOR, defValue: 'red');
    //是否第一次登录，是：显示引导页guide_page；否：显示home_page
    _firstKey = SpHelper.getBool(Config.KEY_FIRST_LOGIN, defValue: true);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoProvider()),
      ],
      child: Consumer<AppInfoProvider>(builder: (context, appInfo, _) {
        String colorKey = appInfo.themeColor;
        if (Config.themeColorMap[colorKey] != null) {
          _themeColor = Config.themeColorMap[colorKey];
        } else {
          _themeColor = Config.themeColorMap[_colorKey];
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false, //关闭banner上的Debug标识
          onGenerateRoute: Routes.router.generator,
          //自定義主題
          theme: ThemeData.light().copyWith(
              primaryColor: _themeColor,
              accentColor: _themeColor,
              indicatorColor: Colors.white),
          home: _firstKey ? GuidePage() : SplashPage(),
          // )
        );
      }),
    );
  }
}
