import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studing_test_project/src/model/constants/Routers.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';
import 'package:studing_test_project/src/ui/ui_extensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();
  final CarouselController _controllerPosts = CarouselController();

  int _current = 0;
  int _currentPosts = 0;

  late double _screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(Provider.of(context, listen: false)),
      builder: (context, child) {
        var bloc = HomeBloc(Provider.of<HomeViewModel>(context));
        bloc.loadPosts();
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              const SizedBox(height: 16),
              StreamBuilder<List<VideoPost>>(
                  stream: bloc.videoFirstCarousel,
                  builder: (context, data) {
                    return _showVideoCarouselOrProgress(
                        data, _controller, _current, (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    });
                  }),
              const SizedBox(height: 16),
              // StreamBuilder(
              //     stream: bloc.videoSecondCarousel,
              //     builder: (context, data) {
              //       return _showVideoCarouselOrProgress(data);
              //     }),
              // const SizedBox(height: 16),
              StreamBuilder<List<ImagePost>>(
                stream: bloc.imageCarousel,
                builder: (context, data) {
                  if (data.data != null) {
                    return _getImgPosts(data.data!);
                  } else {
                    return _getCarouselProgress();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showVideoCarouselOrProgress(
    dynamic data,
    CarouselController controller,
    int index,
    Function(int, CarouselPageChangedReason) onPageChanged,
  ) {
    if (data.data != null) {
      return _getVideoPosts(data.data!, controller, index, onPageChanged);
    } else {
      return _getCarouselProgress();
    }
  }

  Widget _getImgPosts(List<ImagePost> items) {
    return CarouselSlider.builder(
      itemBuilder: (context, index, realIndex) {
        return _getImgContainer(items[realIndex]);
      },
      itemCount: items.length,
      carouselController: _controllerPosts,
      options: CarouselOptions(
        aspectRatio: 1.5,
        viewportFraction: 0.7,
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentPosts = index;
          });
        },
      ),
    );
  }

  Widget _getImgContainer(ImagePost post) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.WEB_VIEWER,
            arguments: {"link", "https://www.flutter.dev/"});
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
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
    List<VideoPost> items,
    CarouselController controller,
    int currentIndex,
    Function(int, CarouselPageChangedReason) onPageChanged,
  ) {
    return Column(
      children: [
        CarouselSlider(
          items: items.map((e) => _getVideoContainer(e)).toList(),
          carouselController: controller,
          options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              aspectRatio: 24 / 9,
              onPageChanged: onPageChanged),
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
                        .withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getVideoContainer(VideoPost post) {
    return Container(
      width: _screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            // child: AspectRatio(
            //   aspectRatio: 24 / 9,
            child:
                // YoutubePlayerControllerProvider(
                //   controller: post.controller,
                //   child: LayoutBuilder(
                //     builder: (context, constraints) {
                //       return Stack(
                //         children: [
                //           SizedBox(
                //             width: constraints.maxWidth,
                //             child: YoutubePlayerIFrame(
                //               controller: post.controller,
                //               gestureRecognizers: null,
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ),

                YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: post.controller,
                      showVideoProgressIndicator: false,
                      onReady: () {
                        // post.controller.addListener(() {});
                      },
                    ),
                    builder: (context, player) => Scaffold(
                          body: IconButton(
                              icon: Icon(Icons.play_arrow_rounded),
                              color: Colors.black,
                              onPressed: () {
                                // cc.play();
                                // post.controller.value.isPlaying
                                //     ? post.controller.pause()
                                //     : post.controller.play();
                              }),
                        )),
          ),
          Visibility(
            visible: !post.controller.value.isPlaying,
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
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  iconSize: 48,
                  icon: Icon(Icons.play_arrow),
                  color: Colors.black,
                  onPressed: () {
                    post.controller.value.isPlaying
                        ? post.controller.pause()
                        : post.controller.play();
                  }),
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
