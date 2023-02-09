import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_player/component/custom_icon_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({super.key, required this.video});

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    setState(() {
      this.videoController = videoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(
            videoController!,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Slider(
              onChanged: (double val) {
                videoController!.seekTo(
                  Duration(seconds: val.toInt()),
                );
              },
              value: videoController!.value.position.inSeconds.toDouble(),
              min: 0,
              max: videoController!.value.duration.inSeconds.toDouble(),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: CustomIconButton(
                onPressed: () {}, iconData: Icons.photo_camera_back),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  onPressed: () {},
                  iconData: Icons.rotate_left,
                ),
                CustomIconButton(
                  onPressed: () {},
                  iconData: videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                CustomIconButton(
                  onPressed: () {},
                  iconData: Icons.rotate_right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
