import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImagePost {
  String url;
  IconData tagIcon;
  String tag;
  DateTime time;
  String text;

  ImagePost(this.url, this.time, this.tagIcon, this.tag, this.text);
}
