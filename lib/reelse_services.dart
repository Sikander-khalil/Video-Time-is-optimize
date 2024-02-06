import 'dart:convert';
import 'dart:developer';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'cache_config.dart';

class ReelService {
  List<String> _reels = [];

  Future<List<String>> getVideosFromApI() async {
    final String apiUrl = 'https://aasonline.co/api/c-logs';

    String? token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYjliNDQ1NDYyYmE4ZTA5MTFhZTI1MDA1YmZjNTg1ZjA0MWY0ZDRkZWY1ZjNkZDI0NmYwZmQ3Y2QyYmViNmE2NGQ3OTNmNDM3YzZlNzJlNGMiLCJpYXQiOjE3MDQ4NzgwNTAuNzEwMDg4LCJuYmYiOjE3MDQ4NzgwNTAuNzEwMDk1LCJleHAiOjE3MzY1MDA0NTAuNjg0ODU2LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.IHInQ9QX8zQyAkVmXOYjqLOjLR0fEXt1xo4JzEVPMlRpVJDd9SrI01CROlV9Yzwc79AWmWKjUKqMGJSZROr0CbOuKb3ZSkbKjEP4Kqx1hjUlMFS_SbF5VKTMcwZ8U-JQ9ogt18Q0d8i7AKOM8Ojj4z5P6DiDHReJH0QI4Y2w36KfEwN1LVGpgyrAPPz6JkRJYocoXbljgXdy2iIgdK0J40opyTGXiMXvWMdlUPvS5MkgT-hieUgE3KriKJ3yhC1LXovapIXytSoMTarZctSZixdIbvRSteTOYbIgld7WydAx1F6jwudBSXKDrIdq_eF9n0pCSYavAlb0etquarIXqoaFmiw-hfHNkfOGum5h2GLvyKznyXrbgDEHNr07rZLMhTvV4r5ET7mZvLWsZXAgA8PLuKYDrJG4DEQXChda-M7I8MECits7umFGXRuVucyP90z5hhbgRJ-vYOSMJF_Dt5hKHqOPUXTj_EB8ww7na_SrQ9q3UvZt8IyC8skJ_yBjEqcItlOjAL8UN0C-XlV1VQaBezMywOHSTvfHgp6eSxUs01dqSPEnyiPi4AT9lsOqfeoWPlkkr4PgyeXJLLFc44txlhPP32I-narbmc37VNlEctufpgp93Yg79wMOiJjHDu1YtXMSZ9l4RV-2YkgWAx_pacUS1k6NCS44mSXZ9ao";

    final data = {'id': 't'};
    final response = await http.post(
      Uri.parse('$apiUrl'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> videoList = jsonDecode(response.body)['videos'];

      for (var video in videoList) {
        final String baseUrl = 'https://aasonline.co/storage/app';

        var url = '${baseUrl}/${video['url']}';
        print("THis is Url : ${url}");
        _reels.add(url);
      }

      for (var i = 0; i < _reels.length; i++) {
        cacheVideos(_reels[i], i);
      }

      print("Caching finished");
      return _reels;
    } else {
      return [];
    }
  }

  cacheVideos(String url, int i) async {
    FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);
    if (fileInfo == null) {

      await kCacheManager.downloadFile(url);
      log('downloaded file: $url');
    } else {
      log('file already in cache:$url');
    }

    if (i + 1 == _reels.length) {
      log('caching finished');

    }
  }
}
