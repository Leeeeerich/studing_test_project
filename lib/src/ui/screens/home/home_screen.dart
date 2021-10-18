import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studing_test_project/src/model/constants/Routers.dart';
import 'package:studing_test_project/src/model/models/args.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/screens/home/carousel_states.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';
import 'package:studing_test_project/src/ui/ui_extensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'home_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(Provider.of(context, listen: false)),
      builder: (context, child) {
        var bloc = HomeBloc(Provider.of<HomeViewModel>(context));
        bloc.loadPosts();
        return Scaffold(
          appBar: AppBar(title: Text("Test App")),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  StreamBuilder<CarouselState>(
                      stream: bloc.videoFirstCarousel,
                      initialData: CarouselState.LOADING_DATA,
                      builder: (context, data) {
                        print("List size = ${bloc.firstVideoList.length}");
                        return _carouselStates(
                          data.data!,
                          _getVideoPosts(
                            context,
                            bloc,
                            bloc.firstVideoList.toList(),
                            bloc.firstVideoPostsCarouselCon,
                            bloc.currentFirstVideoCarouselPage,
                            bloc.firstVideoCarouselScrollingListener,
                            bloc.firstVideoCarouselPageChangedListener,
                          ),
                        );
                      }),
                  const SizedBox(height: 16),
                  StreamBuilder<CarouselState>(
                      stream: bloc.videoSecondCarousel,
                      initialData: CarouselState.LOADING_DATA,
                      builder: (context, data) {
                        return _carouselStates(
                          data.data!,
                          _getVideoPosts(
                            context,
                            bloc,
                            bloc.secondVideoList.toList(),
                            bloc.secondVideoPostsCarouselCon,
                            bloc.currentSecondVideoCarouselPage,
                            bloc.secondVideoCarouselScrollingListener,
                            bloc.secondVideoCarouselPageChangedListener,
                          ),
                        );
                      }),
                  const SizedBox(height: 16),
                  StreamBuilder<List<ImagePost>>(
                    stream: bloc.imageCarousel,
                    builder: (context, data) {
                      if (data.data != null) {
                        return _getImgPosts(context, bloc, data.data!);
                      } else {
                        return _getCarouselProgress();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _carouselStates(CarouselState state, Widget child) {
    print("State = $state");
    switch (state) {
      case CarouselState.SCROLLED:
        return child;
      case CarouselState.SCROLLING:
        return child;
      case CarouselState.LOADING_DATA:
        return _getCarouselProgress();
      case CarouselState.ERROR:
        return Center(
            child: Text("Sorry! There were problems during the download."));
      case CarouselState.NO_DATA:
        return const SizedBox();
    }
  }

  Widget _getImgPosts(
      BuildContext context, HomeBloc bloc, List<ImagePost> items) {
    return CarouselSlider.builder(
      itemBuilder: (context, index, realIndex) {
        return _getImgContainer(context, items[realIndex]);
      },
      itemCount: items.length,
      carouselController: bloc.imagePostsCarouselCon,
      options: CarouselOptions(
        aspectRatio: 1.5,
        viewportFraction: 0.7,
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {},
      ),
    );
  }

  Widget _getImgContainer(BuildContext context, ImagePost post) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.WEB_VIEWER,
            arguments: WebLink("https://www.flutter.dev"));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(post.url, fit: BoxFit.fill, height: 150),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(post.tagIcon, color: Colors.deepOrangeAccent),
                      const SizedBox(width: 4),
                      Text(post.tag),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.time.formattedDateTime(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(post.text, maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getVideoPosts(
    BuildContext context,
    HomeBloc bloc,
    List<VideoPost> items,
    CarouselController controller,
    int currentPage,
    Function(double?) onScrollListener,
    Function(int index, CarouselPageChangedReason reason) onPageChangedListener,
  ) {
    return Column(
      children: [
        CarouselSlider(
          items: items.map((e) => _getVideoContainer(bloc, e)).toList(),
          carouselController: controller,
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            aspectRatio: 24 / 9,
            initialPage: currentPage,
            onScrolled: onScrollListener,
            onPageChanged: onPageChangedListener,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.deepOrangeAccent)
                      .withOpacity(currentPage == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getVideoContainer(HomeBloc bloc, VideoPost post) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: YoutubePlayerBuilder(
              // onEnterFullScreen: () {
              //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              // },
              onExitFullScreen: () {
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              },
              player: YoutubePlayer(
                controller: post.controller,
                showVideoProgressIndicator: false,
                onReady: () {},
              ),
              builder: (context, player) => Scaffold(
                body: const SizedBox(),
              ),
            ),
          ),
          Visibility(
            visible: post.isShowInfo,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    "C02196F3".getColor(),
                    "B02196F3".getColor(),
                    "A02196F3".getColor(),
                    Colors.transparent
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.1, 0.4, 0.6, 0.8, 1],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    //TODO fix to two lines
                    post.description,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(),
                  Text(
                    post.botText,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      backgroundColor: Colors.yellow,
                      fontSize: 20,
                      wordSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: post.isShowInfo,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 48,
                  icon: Icon(Icons.play_arrow),
                  color: Colors.black,
                  onPressed: () {
                    if (post.controller.value.isReady) {
                      bloc.playStop(post);
                    } else {
                      "Video not ready yet!".showToast();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCarouselProgress() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SpinKitCubeGrid(color: Colors.blueAccent),
      ),
    );
  }
}
