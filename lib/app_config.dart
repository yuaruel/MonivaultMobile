import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart' as intl;

class AppConfig extends InheritedWidget{
  final String apiBaseUrl;
  final String apiV1Base;
  String accessToken;
  var currencyFormat = intl.NumberFormat.currency(locale: "en-GB", name: "NGN", symbol: "N", decimalDigits: 2);
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