import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/app_utils.dart';
import 'package:monivault_mobile/login.dart';
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
    return Material(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
              flex: 2,
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
                      SizedBox(height: 25.0,),
                      RaisedButton(
                          padding:
                          const EdgeInsets.only(left: 65.0, right: 65.0),
                          color: Colors.lightGreen,
                          child: Text('Continue',
                              style: TextStyle(fontSize: 17.0),
                              textDirection: TextDirection.ltr),
                          onPressed: () {
                            //validate contact fields
                            validateFormAndSubmit(context);
                          })
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

  validateFormAndSubmit(BuildContext context) async{
    var contactFormState = contactFormKey.currentState;

    if(contactFormState.validate()){
      contactFormState.save();

      AppUtil.displayWait(context);
      var appConfig = AppConfig.of(context);

      StringBuffer verificationUrl = StringBuffer("${appConfig.apiBaseUrl}signupservice/verification-code?");
      verificationUrl.write("phone=");
      verificationUrl.write(_phoneController.text);
      verificationUrl.write("&");
      verificationUrl.write("email=");
      verificationUrl.write(_emailController.text);

      try {

        var response = await http.post(verificationUrl.toString());

        Navigator.pop(context);
        if(response.statusCode == 200){
            var detailRoute = MaterialPageRoute<void>(
                builder: (context) => SignupDetail(_emailController.text, _phoneController.text)
            );

            Navigator.of(context).push(detailRoute);
        }else if(response.statusCode == 400){
          switch(response.body){
            case 'duplicate-phone':
              AppUtil.displayAlert("MoniVault", "Invalid phone number", context);
              break;
            case 'duplicate-email':
              AppUtil.displayAlert("MoniVault", "Invalid email", context);
              break;
            default:
              AppUtil.displayAlert("MoniVault", "Error sending verification code. Try again later!", context);
          }
        }else{
          AppUtil.displayAlert("MoniVault", "Error sending verification code.", context);
        }

      }catch(e){
        AppUtil.displayAlert("MoniVault", "Unable to get verification code. Try again later!", context);
      }
    }
  }
}

class SignupDetail extends StatefulWidget {

  final String _email;
  final String _phone;

  SignupDetail(this._email, this._phone);

  @override
    State<StatefulWidget> createState() {
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (confirmPassword){
                          try{
                            Validate.notBlank(confirmPassword);
                            if(confirmPassword != _passwordController.text){
                              return "Password does not match";
                            }
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

  validateFormAndSubmit() async{
    
    if(_personalInfoFormKey.currentState.validate()){
      AppUtil.displayWait(context);
      var response = await createUserAccount();
      Navigator.pop(context);

      if(response.statusCode == 201){
        await AppUtil.displayAlertAsync("MoniVault", "Your account has been created successfully!", context);

        //Navigate to the login page
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context){
            return Login();
          }
        ));
      }else{
        AppUtil.displayAlert("MoniVault", "Unable to complete your registration. Please try again!", context);
      }
    }
  }

  Future<http.Response> createUserAccount() async {

    var appConfig = AppConfig.of(context);

    var requestHeader = {'Content-Type': MediaType("application", "json").toString()};
    var requestBody = jsonEncode({'phone': _phone, 'email': _email, 'verificationCode': _verificationCodeController.text,
                'username': _usernameController.text, 'password': _passwordController.text, 
                'firstname': _firstNameController.text, 'lastname': _lastNameController.text });
    
    var response = await http.post("${appConfig.apiBaseUrl}signupservice/signup-account-holder",
          headers: requestHeader,
          body: requestBody);

    return response;
  }
}
