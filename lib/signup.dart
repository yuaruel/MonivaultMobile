import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'app_theme.dart';
import 'welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class SignupContact extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return SignupContactState();
    }
}

class SignupContactState extends State<SignupContact>{

  GlobalKey<FormState> contactFormKey = GlobalKey();
  var _emailController = new TextEditingController();
  var _phoneController = new TextEditingController();
  //String _email;
  //String _phone;

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
              child: Center(
                child: Text('Contact Detail',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: lightPrimaryColor,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: 'Note: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'This will be our primary means of communication to you.',
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ]),
                textDirection: TextDirection.ltr,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
                child: Form(
                  key: contactFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        validator: (phoneValue){
                          
                          try{
                            Validate.notBlank(phoneValue, 'Phone number is required');
                            Validate.matchesPattern(phoneValue, RegExp('\\d{11}'), 'Phone number is not valid');
                          }on ArgumentError catch(err){
                            return err.message;
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email Address'),
                        validator: (emailValue){
                          try{
                            if(emailValue.isNotEmpty){
                              Validate.isEmail(emailValue, 'Enter a valid email');
                            }
                          } on ArgumentError catch (err){
                            return err.message;
                          }
                        },    
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: RaisedButton(
                            padding:
                                const EdgeInsets.only(left: 65.0, right: 65.0),
                            color: Colors.lightGreen,
                            child: Text('Continue',
                                style: TextStyle(fontSize: 17.0),
                                textDirection: TextDirection.ltr),
                            onPressed: () {
                              //validate contact fields
                              validateFormAndSubmit(context);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: entranceScreenFooter(context,
                        "Already have an account?", "Signin", "login")))
          ],
        ),
      ),
    );
  }

  validateFormAndSubmit(BuildContext context){
    var contactFormState = contactFormKey.currentState;

    if(contactFormState.validate()){
      contactFormState.save();

      Future<int> statusCode = sendVerificationToken();
      
      statusCode.then((onValue){
        if(onValue == 200){
          var detailRoute = MaterialPageRoute<void>(
            builder: (context) => SignupDetail(_emailController.text, _phoneController.text)
          );

          Navigator.of(context).push(detailRoute);
        }
      });
    }
  }


  Future<int> sendVerificationToken() async {
    
    StringBuffer verificationUrl = StringBuffer("http://10.0.2.2:8080/signupservice/verification-code?");
    verificationUrl.write("phone=");
    verificationUrl.write(_phoneController.text);
    verificationUrl.write("&");
    verificationUrl.write("email=");
    verificationUrl.write(_emailController.text);

    debugPrint("verificationcode url: " + verificationUrl.toString());
    var response = await http.post(verificationUrl.toString());

    debugPrint("response code: " + response.statusCode.toString());

    return response.statusCode;

  }
}

class SignupDetail extends StatefulWidget {

  final String _email;
  final String _phone;

  SignupDetail(this._email, this._phone);

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return SignupDetailState(_email, _phone);
    }
}

class SignupDetailState extends State<SignupDetail>{
  final String _email;
  final String _phone;

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _verificationCodeController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();

  GlobalKey<FormState> _personalInfoFormKey = GlobalKey();

  SignupDetailState(this._email, this._phone);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 55.0, bottom: 25.0),
              child: Center(
                child: Text('Personal Information',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: lightPrimaryColor,
                    )),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: Form(
                  key: _personalInfoFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Verification Code'),
                        validator: (verificationCode){
                          try{
                            Validate.notBlank(verificationCode, 'Verification code is required');
                            Validate.matchesPattern(verificationCode, RegExp('\\d{6}'), 'Invalid verification code');
                          }on ArgumentError catch (err){
                            return err.message;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (username){
                          try{
                            Validate.notBlank(username, 'Username is required');
                          }on ArgumentError catch(err){
                            return err.message;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (password){
                          try{
                            Validate.notBlank(password);
                          }on ArgumentError catch(err){
                            return err.message;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator: (firstName){
                          try{
                            Validate.notBlank(firstName, 'First name is required');
                          }on ArgumentError catch(err){
                            return err.message;
                          }
                        },
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (lastName){
                          try{
                            Validate.notBlank(lastName, 'Last name is required');
                          }on ArgumentError catch(err){
                            return err.message;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: RaisedButton(
                            padding:
                                const EdgeInsets.only(left: 65.0, right: 65.0),
                            color: Colors.lightGreen,
                            child: Text('Signup',
                                style: TextStyle(fontSize: 17.0),
                                textDirection: TextDirection.ltr),
                            onPressed: () {
                              //validate the personal information fields
                              validateFormAndSubmit();
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
/*             new Expanded(
                child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: entranceScreenFooter(context,
                        "Already have an account?", "Signin", "login"))) */
          ],
        ),
      ),
    );
  }

  validateFormAndSubmit(){
    
    if(_personalInfoFormKey.currentState.validate()){
      createUserAccount();
    }
  }

  createUserAccount() async {

    var requestHeader = {'Content-Type': MediaType("application", "json").toString()};
    var requestBody = jsonEncode({'phone': _phone, 'email': _email, 'verificationCode': _verificationCodeController.text,
                'username': _usernameController.text, 'password': _passwordController.text, 
                'firstname': _firstNameController.text, 'lastname': _lastNameController.text });

    debugPrint('the request body: ' + requestBody);
    
    var response = await http.post("http://10.0.2.2:8080/signupservice/signup-account-holder", 
          headers: requestHeader,
          body: requestBody);

    debugPrint('response status code: ' + response.statusCode.toString());
    debugPrint('response text: ' + response.body);
    
  }
}
