import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({super.key, required this.video});

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'CustomVideoPlayer',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
