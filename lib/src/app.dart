import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:studing_test_project/src/model/constants/Routers.dart';
import 'package:studing_test_project/src/model/repository/repository.dart';
import 'package:studing_test_project/src/model/repository/repository_impl.dart';
import 'package:studing_test_project/src/ui/screens/home/home_screen.dart';
import 'package:studing_test_project/src/ui/screens/splash/splash_screen.dart';
import 'package:studing_test_project/src/ui/ui_extensions.dart';

class App extends StatefulWidget {
  final FlutterI18nDelegate _flutterI18nDelegate;

  App(this._flutterI18nDelegate) : super();

  @override
  _App createState() => _App();
}

class _App extends State<App> {
  late Repository _repository;

  @override
  Widget build(BuildContext context) {
    _prepareSync();
    return MultiProvider(
      providers: [
        Provider.value(value: _repository),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          widget._flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        initialRoute: Routes.HOME,
        routes: {
          Routes.SPLASH: (_) => SplashScreen(),
          Routes.HOME: (_) => HomeScreen(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: "F3F3F3".getColor(),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _prepareSync() {
    _repository = RepositoryImpl();
  }
}
