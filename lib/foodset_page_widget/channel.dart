import 'package:flutter/material.dart';

class Channel extends StatelessWidget {
  final data;
  const Channel({this.data});

  @override
  Widget build(BuildContext context) {
    // print('------>$data');
    var itemWidth = (MediaQuery.of(context).size.width - 8) / 4;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      // color: Colors.blue,
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.center,
        // spacing: 2.0,
        children: data.map<Widget>((item) {
          return Container(
            padding: EdgeInsets.all(1.0),
            // color: Colors.green,
            width: itemWidth,
            child: Stack(
              children: <Widget>[
                Image.network(item['img'], fit: BoxFit.cover),
                Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item['title'],
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        item['desc'],
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
