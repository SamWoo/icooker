import 'package:flutter/material.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/provider/app_info_provider.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/utils/spHelper.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _colorKey;
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync(){
    setState(() {
      _colorKey =
          SpHelper.getString(Config.key_theme_color, defValue: 'redAccent');
      // bool _firstKey = SpHelper.getBool(Config.key_first_install, defValue: true);
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
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: Config.themeColorMap.keys.map((key) {
                    Color value = Config.themeColorMap[key];
                    return InkWell(
                      onTap: () async{
                        setState(() {
                          _colorKey = key;
                        });
                        await SpHelper.putString(Config.key_theme_color, key);
                        Provider.of<AppInfoProvider>(context,listen: false).setThemeColor(key);
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
              )
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
          )
        ],
      ),
    );
  }
}