import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/successful_transfer.dart';
import 'package:monivault_mobile/util_widgets.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return OtpState();
  }

}

class OtpState extends State<Otp>{

  var _otpFormFieldKey = GlobalKey<FormFieldState>();
  String _otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer OtP'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 35.0, left: 15.0, right: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Submit the OTP sent to your registered phone number'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Didn't receive OTP? "),
                FlatButton(
                  child: Text('Resend'),
                  textColor: Colors.blueAccent,
                  onPressed: (){},
                )
              ],
            ),
            SizedBox(height: 45.0,),
            TextFormField(
              key: _otpFormFieldKey,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.number,
              validator: (otpValue){
                try {
                  Validate.notBlank(otpValue, "Otp is required");
                }on ArgumentError catch(e){
                  return e.message;
                }
              },
              onSaved: (otpValue){
                _otp = otpValue;
              },
            ),
            SizedBox(height: 45.0,),
            SizedBox(
              height: 40.0,
              width: 350.0,
              child: RaisedButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text('Submit', style: TextStyle(fontSize:15.0, fontWeight: FontWeight.bold),),
                onPressed: (){
                  var _formFieldState = _otpFormFieldKey.currentState;
                  if(_formFieldState.validate()){
                    _formFieldState.save();

                    verifyOtp();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void verifyOtp() async{
    var appConfig = AppConfig.of(context);

    var requestBody = {"otp": _otp};
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              content: WaitCircularIndicator(),
            );
          }
      );

      var response = await http.post(
          '${appConfig.apiV1Base}transferService/submit-otp',
          headers: appConfig.authorizationHeader, body: requestBody);
      Navigator.pop(context);

      if(response.statusCode == 200){
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context){
            return SuccessfulTransfer();
          }
        ));
      }else{
        var errorBody = jsonDecode(response.body);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
            if(Platform.isAndroid){
              return AlertDialog(
                title: Text('Transfer Error'),
                content: Text(errorBody['reason']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }else if(Platform.isIOS){
              return CupertinoAlertDialog(
                title: Text('Transfer Error'),
                content: Text(errorBody['reason']),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
          }
        );
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

}