// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPost {
  String videoId;
  String previewUrl;
  String title;
  String description;
  String botText;

  bool isShowInfo = true;

  late YoutubePlayerController controller;

  VideoPost(
    this.videoId,
    this.previewUrl,
    this.title,
    this.description,
    this.botText,
  );

  void startPlay() {
    isShowInfo = false;
    controller.play();
  }

  void stopPlay() {
    controller.pause();
    isShowInfo = true;
  }
}
