import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_player/component/custom_icon_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

final _speed = [1, 1.5, 2];

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer(
      {super.key, required this.video, required this.onNewVideoPressed});

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  bool showControls = false;
  num dropDownValue = _speed.first;

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

    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(
                      videoController!.value.position,
                    ),
                    Expanded(
                      child: Slider(
                        onChanged: (double val) {
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds
                            .toDouble(),
                        min: 0,
                        max: videoController!.value.duration.inSeconds
                            .toDouble(),
                      ),
                    ),
                    renderTimeTextFromDuration(
                      videoController!.value.duration,
                    ),
                  ],
                ),
              ),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    value: dropDownValue,
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    autofocus: true,
                    items: _speed.map(
                      (speed) {
                        return DropdownMenuItem(
                          child: Text('${speed}배속'),
                          value: speed,
                        );
                      },
                    ).toList(),
                    onChanged: (speed) {
                      dropDownValue = speed!;
                      onChangeSpeed(speed.toDouble());
                    },
                  ),
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                    onPressed: widget.onNewVideoPressed,
                    iconData: Icons.photo_camera_back),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 3600).toString().padLeft(2, '0')}',
      style: TextStyle(color: Colors.white),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    videoController!.value.isPlaying
        ? videoController!.pause()
        : videoController!.play();
  }

  void onChangeSpeed(double? speed) {
    videoController!.setPlaybackSpeed(speed!);
  }
}
