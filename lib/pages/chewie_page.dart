import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _videoPlayerController =
        VideoPlayerController.network(widget.data['video']['vendor_video']);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      // aspectRatio: 0.8,
      autoPlay: false,
      showControls: true,
      autoInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder:
          Image.asset('assets/images/placeholder.png', fit: BoxFit.fill),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
