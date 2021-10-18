import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/model/web_apis/web_apis.dart';

class WebApisImpl extends WebApis {
  Future<List<VideoPost>> loadFirstVideoList() async {
    await Future.delayed(Duration(seconds: 6));
    return videoPosts;
  }

  Future<List<VideoPost>> loadSecondVideoList() async {
    await Future.delayed(Duration(seconds: 2));
    return videoPosts2;
  }

  void loadImageList(StreamSink sink) async {
    await Future.delayed(Duration(seconds: 4));
    sink.add(img1List);
  }
}

final List<ImagePost> img1List = [
  ImagePost(
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
      DateTime.now(),
      Icons.directions_run,
      "#Qwerty",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consectetur interdum maximus. Phasellus ut ligula orci. Fusce eget lobortis neque. Morbi accumsan nibh faucibus velit gravida, dapibus maximus leo feugiat."),
  ImagePost(
      'https://p.bigstockphoto.com/GeFvQkBbSLaMdpKXF1Zv_bigstock-Aerial-View-Of-Blue-Lakes-And--227291596.jpg',
      DateTime.now(),
      Icons.menu_book_sharp,
      "#Qwerty",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consectetur interdum maximus. Phasellus ut ligula orci. Fusce eget lobortis neque. Morbi accumsan nibh faucibus velit gravida, dapibus maximus leo feugiat."),
];

final List<VideoPost> videoPosts = [
  VideoPost("GeyDf4ooPdo", "previewUrl", "Care Freedom Plan",
      "Your investment in good\n health begins here.", " carē "),
  VideoPost("dEqT3pfNpXk", "previewUrl", "Care Freedom Plan",
      "Your investment in good\n health begins here.", " carē "),
];

final List<VideoPost> videoPosts2 = [
  VideoPost("KT18KJouHWg", "previewUrl", "Care Freedom Plan",
      "Your investment in good\n health begins here.", " carē "),
  VideoPost("H1_OpWiyijU", "previewUrl", "Care Freedom Plan",
      "Your investment in good\n health begins here.", " carē "),
  VideoPost("UBVV8pch1dM", "previewUrl", "Care Freedom Plan",
      "Your investment in good\n health begins here.", " carē "),
];
