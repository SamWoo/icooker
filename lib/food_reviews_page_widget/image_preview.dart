import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert' as convert;

class ImagePreview extends StatefulWidget {
  final data;
  ImagePreview({this.data});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  PageController _pageController;
  int _currentIndex;
  var data;

  @override
  void initState() {
    data = convert.jsonDecode(widget.data);
    print(data);
    _currentIndex = data['initIndex'];
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
          // backgroundDecoration: BoxDecoration(color: Colors.white),
          reverse: false,
          pageController: _pageController,
          scrollPhysics: BouncingScrollPhysics(),
          onPageChanged: _onPageChanged,
          itemCount: data['imagesList'].length,
          builder: (BuildContext context, int index) {
            var item = data['imagesList'][index];
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(item),
              minScale: PhotoViewComputedScale.contained * 0.6,
              maxScale: PhotoViewComputedScale.covered * 1.1,
              initialScale: PhotoViewComputedScale.contained,
            );
          }),
    );
  }
}
