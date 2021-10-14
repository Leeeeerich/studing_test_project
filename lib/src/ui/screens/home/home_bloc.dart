import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/base_bloc.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';

class HomeBloc extends BaseBloc {
  late HomeViewModel vm;

  StreamController<List<VideoPost>> _videoFirstCarousel = BehaviorSubject();
  StreamController<List<VideoPost>> _videoSecondCarousel = BehaviorSubject();
  StreamController<List<ImagePost>> _imagesCarousel = BehaviorSubject();

  HomeBloc(this.vm) : super(vm);

  Stream<List<VideoPost>> get videoFirstCarousel => _videoFirstCarousel.stream;

  Stream<List<VideoPost>> get videoSecondCarousel =>
      _videoSecondCarousel.stream;

  Stream<List<ImagePost>> get imageCarousel => _imagesCarousel.stream;

  void loadPosts() {
    vm.loadImageList(_imagesCarousel.sink);
  }

  @override
  void dispose() {
    _videoFirstCarousel.close();
    _videoSecondCarousel.close();
    _imagesCarousel.close();
    super.dispose();
  }
}
