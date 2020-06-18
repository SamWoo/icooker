import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icooker/router/routes.dart';

class NinthPalace extends StatelessWidget {
  final data;
  final spacing;
  final runSpacing;

  const NinthPalace({this.data, this.spacing = 4.0, this.runSpacing = 4.0});

  @override
  Widget build(BuildContext context) {
    List<String> imgList = [];
    final screenWidth = MediaQuery.of(context).size.width - 24.0;
    var itemWidth;

    data.forEach((it) {
      imgList.add(it['img']);
    });

    if (data.length < 4) {
      switch (data.length % 3) {
        case 0:
          itemWidth = (screenWidth - spacing * 2) / 3;
          break;
        case 1:
          itemWidth = screenWidth;
          break;
        case 2:
          itemWidth = (screenWidth - spacing) / 2;
          break;
      }
    } else if (data.length == 4) {
      itemWidth = (screenWidth - spacing) / 2;
    } else {
      itemWidth = (screenWidth - spacing * 2) / 3;
    }

    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: data
            .asMap()
            .map<int, Widget>((index, it) {//必须进行类型限定，否则报错
              return MapEntry<int, Widget>(
                index,
                InkWell(
                  onTap: () {
                    var data = {'initIndex': index, 'imagesList': imgList};
                    Future.delayed(Duration(milliseconds: 100)).then((e) {
                      Routes.navigateTo(context, '/imagePreview',
                          params: {'data': convert.jsonEncode(data)});
                    });
                  },
                  child: Container(
                    width: itemWidth,
                    height: itemWidth,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Color(0xfff2e6e6)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: it['img'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        child: Image.asset('assets/images/placeholder.png',
                            fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              );
            })
            .values
            .toList(),

        // data.map<Widget>((it) {
        //   return InkWell(
        //     onTap: () {
        //       var data = {'initIndex': 0, 'imagesList': imgList};
        //       Future.delayed(Duration(milliseconds: 50)).then((e) {
        //         Routes.navigateTo(context, '/imagePreview',
        //             params: {'data': convert.jsonEncode(data)});
        //       });
        //     },
        //     child: Container(
        //       width: itemWidth,
        //       height: itemWidth,
        //       decoration: BoxDecoration(
        //         border: Border.all(width: 0.5, color: Color(0xfff2e6e6)),
        //       ),
        //       child: CachedNetworkImage(
        //         imageUrl: it['img'],
        //         fit: BoxFit.cover,
        //         placeholder: (context, url) => Container(
        //           child: Image.asset('assets/images/placeholder.png',
        //               fit: BoxFit.cover),
        //         ),
        //         errorWidget: (context, url, error) => Icon(Icons.error),
        //       ),
        //     ),
        //   );
        // }).toList(),
      ),
    );
  }
}
