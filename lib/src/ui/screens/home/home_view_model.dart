import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/model/repository/repository.dart';

class HomeViewModel extends ChangeNotifier {
  final Repository _repository;

  HomeViewModel(this._repository);

  void loadFirstVideoList(StreamSink sink) async {
    await Future.delayed(Duration(seconds: 6));
    sink.add(videoPosts);
  }

  void loadSecondVideoList(StreamSink sink) async {
    await Future.delayed(Duration(seconds: 2));
    // sink.add(event);
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

// final List<VideoPost> videoList = [
//   VideoPost(videoUrl, previewUrl, title, description, botText)
//
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=700&h=1700&q=180',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=700&q=180',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=700&q=180',
// ];
