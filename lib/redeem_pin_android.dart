
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/app_utils.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;

class PinRedeem extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return PinRedeemState();
  }

}

class PinRedeemState extends State<PinRedeem>{

  var _pinFormKey = GlobalKey<FormState>();
  var _pin = '';
  var _comment = '';
  var _pinController = TextEditingController();
  var _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIN Redeem'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
          child: Form(
            key: _pinFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Enter your PIN in the box below'),
                SizedBox(height: 35.0),
                TextFormField(
                  controller: _pinController,
                  decoration: InputDecoration(
                      hintText: 'OneCard PIN',
                      border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (pinValue){
                    try{
                      Validate.notBlank(pinValue, 'PIN is required');
                      Validate.matchesPattern(pinValue, RegExp(r"\d{12,16}"), 'Invalid PIN');
                    }on ArgumentError catch(e){
                      return e.message;
                    }
                  },
                  onSaved: (pinValue){
                    _pin = pinValue;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'Comment',
                      border: OutlineInputBorder()
                  ),
                  /*validator: (commentValue){
                    try{
                      Validate.notBlank(commentValue, 'Comment is required');
                    }on ArgumentError catch(e){
                      return e.message;
                    }
                  },*/
                  onSaved: (commentValue){
                    _comment = commentValue;
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  width: 250.0,
                  height: 55.0,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('Save',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),),
                    onPressed: (){
                      var formState = _pinFormKey.currentState;

                      if(formState.validate()){
                        formState.save();

                        redeemPin();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void redeemPin() async{
    var appConfig = AppConfig.of(context);

    var platformSpecific = Platform.isAndroid ? 'Android' : 'iOS';
    var requestData = {'pin': _pinController.text, 'oneCardComment': _commentController.text, 'platform': 'Mobile',
                        'platformSpecific' : platformSpecific, 'type': 'One Card PIN Redeem'};
    
    var response = await http.post('${appConfig.apiV1Base}depositService/make-one-card-deposit', headers: appConfig.authorizationHeader, body: requestData);

    if(response.statusCode == 200){
      AppUtil.displayAlert('Success', 'Your PIN Redeem was successful!', context);

      //Clear the input fields
      _pinController.text = '';
      _commentController.text = '';
    }else{
      var errorBody = jsonDecode(response.body);
      AppUtil.displayAlert('PIN Redeem Error', errorBody['apiResponse'], context);
    }
  }
}