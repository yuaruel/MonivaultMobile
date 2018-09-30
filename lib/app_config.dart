import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget{
  final String apiBaseUrl;
  final String apiV1Base;
  String accessToken;
  var authorizationHeader = Map<String, String>();

  AppConfig({@required this.apiBaseUrl,@required this.apiV1Base, @required Widget child}) : super(child: child);

  static AppConfig of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(AppConfig config) {
    return this.accessToken != config.accessToken;
  }
}