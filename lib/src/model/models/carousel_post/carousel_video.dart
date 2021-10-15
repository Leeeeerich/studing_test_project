// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPost {
  String videoId;
  String previewUrl;
  String title;
  String description;
  String botText;

  late YoutubePlayerController controller;

  VideoPost(
    this.videoId,
    this.previewUrl,
    this.title,
    this.description,
    this.botText,
  );
}
