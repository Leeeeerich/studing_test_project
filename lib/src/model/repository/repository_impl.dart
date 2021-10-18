import 'dart:async';

import 'package:studing_test_project/src/model/models/carousel_post/carousel_video.dart';
import 'package:studing_test_project/src/model/web_apis/web_apis.dart';

import 'repository.dart';

class RepositoryImpl implements Repository {
  final WebApis _webApis;

  RepositoryImpl(this._webApis);

  Future<List<VideoPost>> loadFirstVideoList() => _webApis.loadFirstVideoList();

  Future<List<VideoPost>> loadSecondVideoList() =>
      _webApis.loadSecondVideoList();

  void loadImageList(StreamSink sink) => _webApis.loadImageList(sink);
}
