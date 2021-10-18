import 'dart:async';

import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';

abstract class WebApis {
  Future<List<VideoPost>> loadFirstVideoList();

  Future<List<VideoPost>> loadSecondVideoList();

  void loadImageList(StreamSink sink);
}
