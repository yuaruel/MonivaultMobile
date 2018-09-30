
import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/main.dart';

void main(){
  var configuredApp = AppConfig(
    apiBaseUrl: 'https://app.monivault.ng/',
    apiV1Base: 'https://app.monivault.ng/api/v1/',
    child: MyApp(),
  );

  runApp(configuredApp);
}