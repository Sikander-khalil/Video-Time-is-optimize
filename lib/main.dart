import 'package:flutter/material.dart';
import 'package:video_show/reelse_services.dart';
import 'package:video_show/video_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  List<String> reels = await ReelService().getVideosFromApI();

  runApp(MyApp(reels: reels));
}

class MyApp extends StatelessWidget {
  final List<String> reels;

  const MyApp({Key? key, required this.reels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        anothereels: reels,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> anothereels;

  const HomeScreen({super.key, required this.anothereels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoReelPage(
                          reels: anothereels,
                        ),
                      ));
                },
                child: Text("Go To Reels Screen"))
          ],
        ),
      ),
    );
  }
}
