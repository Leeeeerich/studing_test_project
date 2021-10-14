import 'package:flutter/widgets.dart';

abstract class BaseBloc<T extends ChangeNotifier> {
  late T model;

  BaseBloc(this.model);

  @mustCallSuper
  void dispose() {}
}
