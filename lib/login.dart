import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/app_utils.dart';
import 'welcome.dart';
import 'app_theme.dart';
import 'package:validate/validate.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'util_widgets.dart';
import 'home_app.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  GlobalKey<FormState> _loginFormKey = GlobalKey();

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  AppConfig _appConfig;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _appConfig = AppConfig.of(context);
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Material(
      child: new Container(
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
              child: new Center(
                child: new Text('Login Detail',
                    textDirection: TextDirection.ltr,
                    style: new TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: lightPrimaryColor,
                    )),
              ),
            ),
            new Expanded(
              child: new Padding(
                padding:
                    const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
                child: new Form(
                  key: _loginFormKey,
                  child: new Column(
                    children: <Widget>[
                      new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(labelText: 'Username'),
                        validator: (username) {
                          try {
                            Validate.notBlank(username, 'Username is required');
                          } on ArgumentError catch (err) {
                            return err.message;
                          }
                        },
                      ),
                      new TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (password) {
                          try {
                            Validate.notBlank(password, 'Password is required');
                          } on ArgumentError catch (err) {
                            return err.message;
                          }
                        },
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: new RaisedButton(
                            padding:
                                const EdgeInsets.only(left: 65.0, right: 65.0),
                            color: Colors.lightGreen,
                            child: new Text('Login',
                                style: new TextStyle(fontSize: 17.0),
                                textDirection: TextDirection.ltr),
                            onPressed: () {
                              validateFormAndSignin(context);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            new Expanded(
                child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: entranceScreenFooter(context,
                        "Don't have an account?", "Signup", "signupContact")))
          ],
        ),
      ),
    );
  }

  validateFormAndSignin(context) async {
    if (_loginFormKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                content: WaitCircularIndicator(),
                semanticLabel: 'Signin in...');
          });

      var response = await signinUser(_appConfig.apiBaseUrl);
      
      Navigator.of(context, rootNavigator: true).pop();

      if(response.statusCode == 200){
        //Successful login
        Map<String, dynamic> loginResponse = json.decode(response.body);

        _appConfig.accessToken = loginResponse['access_token'];
        _appConfig.authorizationHeader = {'Authorization': "Bearer ${loginResponse['access_token']}"};
              
        MaterialPageRoute homePageRoute = MaterialPageRoute(
          builder: (BuildContext contex) {
            debugPrint('loginResponse: ' + loginResponse.toString());
            debugPrint('account id: ' + loginResponse['accountId']);
            return HomeApp(loginResponse['firstName'], loginResponse['lastName'], loginResponse['accountId']);
          }
        );

        Navigator.of(context).pushReplacement(homePageRoute);
      }else{
        //Failed login. Throw a notification dialog.
        debugPrint('an error occurred while trying to login');

        AppUtil.displayAlert("Login Error", "Invalid Username or password", context);
      }

    }
  }

  Future<http.Response> signinUser(String apiBaseUrl) async {

    StringBuffer signinParam = StringBuffer(apiBaseUrl + "/oauth/token?");
    signinParam.write("grant_type=password&");
    signinParam.write("username=");
    signinParam.write(_usernameController.text);
    signinParam.write("&");
    signinParam.write("password=");
    signinParam.write(_passwordController.text);

    String authStr = "mv_api_client:mv-secret";
    var authByte = utf8.encode(authStr);
    var base64Str = base64.encode(authByte);

    var requestHeader = {"Authorization": "Basic " + base64Str};

    String apiUrl = signinParam.toString();

    http.Response response;
    try {
      response = await http.post(apiUrl, headers: requestHeader);
    }catch(e, s){
      debugPrint('error: ' + e.toString());
      //debugPrint('stacktrace:\n ' + s.toString());
    }

    return response;
  }
}
