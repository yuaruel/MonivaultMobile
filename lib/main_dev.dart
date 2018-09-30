
import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/main.dart';

void main(){
  var configuredApp = AppConfig(
    apiBaseUrl: 'http://10.0.2.2:8080',
    apiV1Base: 'http://10.0.2.2:8080/api/v1/',
    child: MyApp(),
  );

  runApp(configuredApp);
}