import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:pedantic/pedantic.dart';
import 'cache_config.dart';

class VideoPlayerWidget extends StatefulWidget {

  final String reelUrl;

  const VideoPlayerWidget({
    super.key,
    required this.reelUrl,

  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _videoInitialized = false;
  BaseCacheManager? _cacheManager;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeController();
  }

  initializeController() async {
    var fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
    print("THis is fileInfo:${fileInfo}");

    if (fileInfo != null) {
      _controller = VideoPlayerController.file(fileInfo.file)
        ..initialize().then(
          (_) {
            setState(() {
              _controller.setLooping(true); // Set video to loop
              _controller.play();
              _videoInitialized = true;
            });
          },
          onError: (error) {
            log("Error initializing video: $error");
          },
        );

      _controller.addListener(() {
        if (_controller.value.isPlaying && !_isPlaying) {
          setState(() {
            _isPlaying = true;
          });
        }
      });
    } else {
      unawaited(_cacheManager!.downloadFile(widget.reelUrl));
      return VideoPlayerController.network(widget.reelUrl);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _controller.play();
    } else if (state == AppLifecycleState.inactive) {
      _controller.pause();
    } else if (state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.detached) {
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    log('disposing a controller');
    if (_videoInitialized) {
      _controller.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_videoInitialized) {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    _isPlaying = false;
                  } else {
                    _controller.play();
                    _isPlaying = true;
                  }
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                !_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : VideoPlayer(_controller),
                if (!_isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                !_videoInitialized
                    ? const SizedBox()
                    : VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.amber,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
