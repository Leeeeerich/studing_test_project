import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studing_test_project/src/model/constants/Routers.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.HOME, (route) => false);
    });
    return Scaffold(
      body: Center(
        child: SpinKitSpinningCircle(
          color: Colors.green,
        ),
      ),
    );
  }
}
