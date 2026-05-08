import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  final Widget child;
  final String videoUrl;

  const VideoBackground({
    super.key,
    required this.child,
    required this.videoUrl,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _controller.setLooping(true);
            _controller.setVolume(0); // Muted
            _controller.play();
          });
        }
      }).catchError((error) {
        debugPrint("VideoPlayer Error: $error");
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose(); // FIXED: replaced super.initState() with super.dispose()
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: _controller.value.isInitialized && !_hasError
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(color: Colors.black), // Fallback background
        ),
        // Darkened Overlay
        SizedBox.expand(
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
        widget.child,
      ],
    );
  }
}
