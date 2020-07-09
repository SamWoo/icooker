import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/provider/app_info_provider.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/utils/Utils.dart';
import 'package:icooker/utils/spHelper.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _colorKey;
  var cacheSize;

  @override
  void initState() {
    super.initState();
    _initAsync();
    Utils.getInstance().loadCache().then((val) {
      setState(() {
        cacheSize = val;
      });
    });
  }

  void _initAsync() {
    setState(() {
      _colorKey =
          SpHelper.getString(Config.KEY_THEME_COLOR, defValue: 'redAccent');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Routes.router.pop(context);
          },
        ),
        title: Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            leading: Icon(Icons.color_lens),
            title: Text('主题'),
            initiallyExpanded: true,
            children: <Widget>[
              _buildColorItem(context),
            ],
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('多语言'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('跟随系统',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    )),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.android),
            title: Text('清除缓存'),
            trailing: Text(
              cacheSize ?? '0.0',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.grey[700],
              ),
            ),
            onTap: () => showDialog(
                context: context,
                builder: (context) => _buildCupertinoAlertDialog(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: Config.themeColorMap.keys.map((key) {
          Color value = Config.themeColorMap[key];
          return InkWell(
            onTap: () async {
              setState(() {
                _colorKey = key;
              });
              await SpHelper.putString(Config.KEY_THEME_COLOR, key);
              Provider.of<AppInfoProvider>(context, listen: false)
                  .setThemeColor(key);
            },
            child: Container(
              width: 40,
              height: 40,
              color: value,
              child: _colorKey == key
                  ? Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCupertinoAlertDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: _buildTitle(context),
        content: _buildContent(context),
        actions: <Widget>[
          CupertinoButton(
              child: Text('Yes!'),
              onPressed: () {
                Utils.getInstance().clearCache();
                Routes.pop(context);
                Utils.getInstance().loadCache().then((val) {
                  setState(() {
                    cacheSize = val;
                  });
                });
              }),
          CupertinoButton(
              child: Text('No!'), onPressed: () => Routes.pop(context)),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          CupertinoIcons.delete_solid,
          color: Colors.red,
          size: 32.0,
        ),
        Expanded(
          child: Text(
            '清理缓存',
            style: TextStyle(
              color: Colors.red,
              fontSize: ScreenUtil().setSp(48),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Column(children: <Widget>[
        Text('是否确定要清除缓存文件?'),
      ]),
    );
  }
}
