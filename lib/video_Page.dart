import 'package:flutter/material.dart';
import 'package:video_show/video_show.dart';


class VideoReelPage extends StatefulWidget {
  const VideoReelPage({super.key, required this.reels,});
  final List<String> reels;


  @override
  _VideoReelPageState createState() => _VideoReelPageState();
}

class _VideoReelPageState extends State<VideoReelPage> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: widget.reels.length,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          print("This is video reel: ${widget.reels[index]}");
          return VideoPlayerWidget(
            key: Key(widget.reels[index]),
            reelUrl: widget.reels[index],

          );
        },
      ),
    );
  }
}