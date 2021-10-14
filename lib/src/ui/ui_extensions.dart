import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

extension UiExtensions on String {
  Color getColor() {
    String hexColor = this.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  String localize(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }

  ///
  /// Context need for localization!
  ///
  void showToast({BuildContext? context}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: context != null ? FlutterI18n.translate(context, this) : this,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}

extension UiExtensionsOnDateTime on DateTime {
  String formattedDateTime() {
    return DateFormat("dd MMM yyyy").format(this);
  }
}
