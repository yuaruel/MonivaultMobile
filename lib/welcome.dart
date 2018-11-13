
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget{

  @override
    Widget build(BuildContext context) {
      return new Container(
        color: Colors.white,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            new Expanded(
              flex: 2,
              child: new DecoratedBox(
                decoration: new BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: new Image.asset(
                  'images/welcome_screen_logo.png',
                ),
              ),
            ),
            new Expanded(
                flex: 3,
                child: new Center(
                  child: new RaisedButton(
                      color: Color(0xFF269ED5),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('login');
                      },
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text(
                          'Already have an account? Signin',
                          textDirection: TextDirection.ltr,
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      )),
                )),
            entranceScreenFooter(context, "Don't have an account?", "Signup", "signupContact")
          ],
        ),
      );
    }
}

Widget entranceScreenFooter(BuildContext context, String navigatorInfo, String navigatorCommand, String routerName){
  return new DecoratedBox(
                decoration: new BoxDecoration(color: Color(0xFFF89F1B)),
                child: new Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.ltr,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(navigatorInfo,
                          textDirection: TextDirection.ltr,
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontSize: 15.0)),
                      new FlatButton(
                        child: new Text(
                          navigatorCommand,
                          textDirection: TextDirection.ltr,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF269ED5),
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(routerName);
                        },
                      )
                    ],
                  ),
                ));
}