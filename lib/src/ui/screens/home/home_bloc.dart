import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:rxdart/rxdart.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/base_bloc.dart';
import 'package:studing_test_project/src/ui/screens/home/carousel_states.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeBloc extends BaseBloc {
  late HomeViewModel vm;

  final CarouselController firstVideoPostsCarouselCon = CarouselController();
  final CarouselController secondVideoPostsCarouselCon = CarouselController();
  final CarouselController imagePostsCarouselCon = CarouselController();

  int currentFirstVideoCarouselPage = 0;
  int currentSecondVideoCarouselPage = 0;
  int currentImagesCarouselPage = 0;

  final Set<VideoPost> firstVideoList = Set();
  final Set<VideoPost> secondVideoList = Set();
  final Set<ImagePost> imageList = Set();

  final StreamController<CarouselState> _videoFirstCarousel = BehaviorSubject();
  final StreamController<CarouselState> _videoSecondCarousel =
      BehaviorSubject();
  final StreamController<List<ImagePost>> _imagesCarousel = BehaviorSubject();

  HomeBloc(this.vm) : super(vm);

  Stream<CarouselState> get videoFirstCarousel => _videoFirstCarousel.stream;

  Stream<CarouselState> get videoSecondCarousel => _videoSecondCarousel.stream;

  Stream<List<ImagePost>> get imageCarousel => _imagesCarousel.stream;

  void loadPosts() {
    vm.loadFirstVideoList().then((value) {
      setYoutubeControllers(value);
      firstVideoList.addAll(value);
      _videoFirstCarousel.sink.add(CarouselState.SCROLLED);
    }).onError((error, stackTrace) {
      _videoFirstCarousel.sink.add(CarouselState.ERROR);
    });

    vm.loadSecondVideoList().then((value) {
      setYoutubeControllers(value);
      secondVideoList.addAll(value);
      _videoSecondCarousel.sink.add(CarouselState.SCROLLED);
    }).onError((error, stackTrace) {
      _videoSecondCarousel.sink.add(CarouselState.ERROR);
    });
    vm.loadImageList(_imagesCarousel.sink);
  }

  void setYoutubeControllers(List<VideoPost> posts) {
    posts.forEach((element) {
      var con = YoutubePlayerController(
        initialVideoId: element.videoId,
        flags: YoutubePlayerFlags(
          mute: true,
          autoPlay: false,
          hideControls: true,
          hideThumbnail: true,
          disableDragSeek: true,
          enableCaption: false,
        ),
      );
      element.controller = con;
    });
  }

  void firstVideoCarouselScrollingListener(double? scrollingPosition) {
    _videoFirstCarousel.sink.add(CarouselState.SCROLLING);
    var page = firstVideoList.elementAt(currentFirstVideoCarouselPage);
    if (page.controller.value.isPlaying) page.stopPlay();
  }

  void secondVideoCarouselScrollingListener(double? scrollingPosition) {
    _videoSecondCarousel.sink.add(CarouselState.SCROLLING);
    var page = secondVideoList.elementAt(currentSecondVideoCarouselPage);
    if (page.controller.value.isPlaying) page.stopPlay();
  }

  void firstVideoCarouselPageChangedListener(
    int index,
    CarouselPageChangedReason reason,
  ) {
    currentFirstVideoCarouselPage = index;
  }

  void secondVideoCarouselPageChangedListener(
    int index,
    CarouselPageChangedReason reason,
  ) {
    currentSecondVideoCarouselPage = index;
  }

  void playStop(VideoPost post) {
    if (post.controller.value.isPlaying) {
      post.stopPlay();
    } else {
      post.startPlay();
    }

    // TODO: fix for update only was scrolling carousel
    _videoFirstCarousel.sink.add(CarouselState.SCROLLED);
    _videoSecondCarousel.sink.add(CarouselState.SCROLLED);
  }

  @override
  void dispose() {
    _videoFirstCarousel.close();
    _videoSecondCarousel.close();
    _imagesCarousel.close();

    firstVideoList.forEach((element) => element.controller.dispose());
    secondVideoList.forEach((element) => element.controller.dispose());

    super.dispose();
  }
}
