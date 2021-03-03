import 'dart:convert' as convert;

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewiePage extends StatefulWidget {
  final data;
  ChewiePage({this.data});

  @override
  _ChewiePageState createState() => _ChewiePageState();
}

class _ChewiePageState extends State<ChewiePage> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    final data = convert.jsonDecode(widget.data);
    _videoPlayerController =
        VideoPlayerController.network(data['video']['vendor_video'])
          ..initialize().then((_) {
            setState(() {});
          });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      showControls: true,
      autoInitialize: true,
      allowFullScreen: true,
      fullScreenByDefault: true,
      allowMuting: true, //静音控件
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.green,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _videoPlayerController.value.initialized
          ? Chewie(
              controller: _chewieController,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
