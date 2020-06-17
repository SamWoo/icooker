import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagePreview extends StatefulWidget {
  final int initIndex;
  final List<String> imagesList;
  final PageController _pageController;

  ImagePreview({this.initIndex, this.imagesList})
      : _pageController = PageController(initialPage: initIndex);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  int _currentIndex;

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _currentIndex = widget.initIndex;
    super.initState();
  }

  @override
  void dispose() {
    widget._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
          // backgroundDecoration: BoxDecoration(color: Colors.white),
          reverse: true,
          pageController: widget._pageController,
          scrollPhysics: BouncingScrollPhysics(),
          onPageChanged: _onPageChanged,
          itemCount: widget.imagesList.length,
          builder: (BuildContext context, int index) {
            var item = widget.imagesList[index];
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
