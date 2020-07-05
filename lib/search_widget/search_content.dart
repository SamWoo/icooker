import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/search_widget/search_item.dart';
import 'package:icooker/services/services_method.dart';
class SearchContentView extends StatefulWidget {
  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  var hotWords;

  @override
  void initState() {
    super.initState();
    getHotWords(Config.SEARCH_HOT_WORDS_URL).then((val) {
      setState(() {
        hotWords = val as List;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
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
              hotwords: hotWords,
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