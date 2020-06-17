import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_preview.dart';

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
    var index = 0;

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
        children: data.map<Widget>((it) {
          index++;
          return InkWell(
            onTap: () {
              Future.delayed(Duration(milliseconds: 100)).then((e) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ImagePreview(initIndex: index, imagesList: imgList),
                  ),
                );
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
          );
        }).toList(),
      ),
    );
  }
}
