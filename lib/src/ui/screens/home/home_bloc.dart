import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/base_bloc.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';

// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeBloc extends BaseBloc {
  late HomeViewModel vm;
  Map<String, YoutubePlayerController> youtubeControllers = Map();

  StreamController<List<VideoPost>> _videoFirstCarousel = BehaviorSubject();
  StreamController<List<VideoPost>> _videoSecondCarousel = BehaviorSubject();
  StreamController<List<ImagePost>> _imagesCarousel = BehaviorSubject();

  HomeBloc(this.vm) : super(vm) {
    _videoFirstCarousel.stream.listen((event) {
      event.forEach((element) {
        var con = YoutubePlayerController(
          initialVideoId: element.videoId,
          // params: YoutubePlayerParams(
          //   showControls: false,
          //   autoPlay: false,
          //   mute: true,
          //   showVideoAnnotations: false,
          //   desktopMode: false,
          //   enableKeyboard: false,
          //   enableCaption: false,
          //   enableJavaScript: false,
          // ),
          flags: YoutubePlayerFlags(
              mute: true, autoPlay: false, hideControls: true),
        );
        youtubeControllers[element.videoId] = con;
        element.controller = con;
      });
    });
  }

  Stream<List<VideoPost>> get videoFirstCarousel => _videoFirstCarousel.stream;

  Stream<List<VideoPost>> get videoSecondCarousel =>
      _videoSecondCarousel.stream;

  Stream<List<ImagePost>> get imageCarousel => _imagesCarousel.stream;

  void loadPosts() {
    vm.loadFirstVideoList(_videoFirstCarousel);
    // vm.loadSecondVideoList(_videoSecondCarousel);
    vm.loadImageList(_imagesCarousel.sink);
  }

  @override
  void dispose() {
    _videoFirstCarousel.close();
    _videoSecondCarousel.close();
    _imagesCarousel.close();

    youtubeControllers.forEach((key, value) {
      value.dispose();
    });

    super.dispose();
  }
}
