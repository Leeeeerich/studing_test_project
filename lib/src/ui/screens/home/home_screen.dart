import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_post.dart';
import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/ui/screens/home/home_view_model.dart';
import 'package:studing_test_project/src/ui/ui_extensions.dart';

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
                    return _showVideoCarouselOrProgress(data);
                  }),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: bloc.videoSecondCarousel,
                  builder: (context, data) {
                    return _showVideoCarouselOrProgress(data);
                  }),
              const SizedBox(height: 16),
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

  Widget _showVideoCarouselOrProgress(dynamic data) {
    if (data.data != null) {
      return _getVideoPosts(data.data!);
    } else {
      return _getCarouselProgress();
    }
  }

  Widget _getImgPosts(List<ImagePost> items) {
    return CarouselSlider(
      items: items.map((e) => _getImgContainer(e)).toList(),
      carouselController: _controllerPosts,
      options: CarouselOptions(
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
    return Container(
      child: Column(
        children: [
          Image.network(post.url),
          Row(
            children: [
              Icon(post.tagIcon),
              Text(post.tag),
            ],
          ),
          Text(post.time.formattedDateTime()),
          Text(post.text),
        ],
      ),
    );
  }

  Widget _getVideoPosts(List<VideoPost> items) {
    return Column(
      children: [
        CarouselSlider(
          items: items.map((e) => _getVideoContainer(e)).toList(),
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.deepOrangeAccent)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
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
            child: Image.network(post.previewUrl, fit: BoxFit.fill),
            // ),
          ),
          Visibility(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Care Freedom Plan",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    //TODO fix to two lines
                    "Your investment in good\n health begins here.",
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(),
                  Text(
                    " carē ",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        backgroundColor: Colors.yellow,
                        fontSize: 20,
                        wordSpacing: 2),
                  ),
                ],
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
