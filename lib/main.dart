import 'package:flutter/material.dart';
import 'welcome.dart';
import 'login.dart';
import 'signup.dart';
import 'app_theme.dart';
import 'home_app.dart';

//void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  //checks data to know 
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColorLight: lightPrimaryColor,
          primaryColorDark: darkPrimaryColor,
          textTheme: new TextTheme(
            body1: new TextStyle(color: Colors.black)
          )
        ),
        home: new Welcome(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder> {
          'login': (BuildContext context) => new Login(),
          //'homeApp': (BuildContext context) => new HomeApp(),
          'signupContact': (BuildContext context) => new SignupContact(),
        },
    );
  }
}
