
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/main.dart';

void main(){
  AppConfig appConfig;

  if(Platform.isAndroid) {
    appConfig = AppConfig(
      apiBaseUrl: 'http://10.0.2.2:8080/',
      apiV1Base: 'http://10.0.2.2:8080/api/v1/',
      child: MyApp(),
    );
  }else if(Platform.isIOS){
    appConfig = AppConfig(
      apiBaseUrl: 'http://127.0.0.1:8080',
      apiV1Base: 'http://127.0.0.1:8080/api/v1/',
      child: MyApp(),
    );
  }

  runApp(appConfig);
}