import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/otp_verification.dart';
import 'package:monivault_mobile/util_widgets.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'app_utils.dart';

class Transfer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TransferState();
  }

}

class TransferState extends State<Transfer>{
  var _formKeyState = GlobalKey<FormState>();

  var _transferChannel = '';

  double _amount;
  var _comment = '';

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transfer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 25.0),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Form(
            key: _formKeyState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Minimum transfer is N1,000'),
                Text('Transfer charge is N100'),
                SizedBox(height: 35.0,),
                RadioListTile<String>(
                  value: 'ATM',
                  title: Text('ATM'),
                  groupValue: _transferChannel,
                  selected: false,
                  onChanged: (buttonValue){
                    debugPrint('selected value: $buttonValue');
                    setState(() {
                      _transferChannel = buttonValue;
                    });
                  },
                ),
                RadioListTile<String>(
                  value: 'Bank Account',
                  title: Text('Bank Transfer'),
                  groupValue: _transferChannel,
                  selected: false,
                  onChanged: (buttonValue){
                    debugPrint('selected value: $buttonValue');
                    setState(() {
                      _transferChannel = buttonValue;
                    });
                  },

                ),
                SizedBox(height: 35.0,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Transfer Amount',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    AmountFormatter()
                  ],
                  validator: (amountValue){
                    try{
                      Validate.notBlank(amountValue, 'Amount is required');
                      String stringValue = AppUtil.unformatCurrency(amountValue);

                      var numValue = double.parse(stringValue);

                      if(_transferChannel == 'atm'){
                        //This is a paycode transfer request. The amount has to be a multiple of 1000.
                        if(numValue.remainder(1000) > 0){
                          throw ArgumentError('Amount should be a multiple of 1,000');
                        }

                      }

                    }on ArgumentError catch(e){
                      return e.message;
                    }on FormatException{
                      return 'Invalid amount';
                    }
                  },
                  onSaved: (transferAmount){
                    _amount = double.parse(AppUtil.unformatCurrency(transferAmount));
                  },
                ),
                SizedBox(height: 35.0,),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Comment'
                  ),
                  keyboardType: TextInputType.text,
                  validator: (commentValue){
                    try{
                      Validate.notBlank(commentValue);
                      if(commentValue.length > 240){
                        throw ArgumentError("Maximum of 240 characters");
                      }
                    }on ArgumentError catch(e){
                      return e.message;
                    }
                  },
                  onSaved: (commentValue){
                    _comment = commentValue;
                  },
                ),
                SizedBox(height: 35.0,),
                SizedBox(
                  height: 45.0,
                  width: 350.0,
                  child: RaisedButton(
                    child: Text('Transfer', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: (){
                      if(_formKeyState.currentState.validate()){
                        _formKeyState.currentState.save();
                        processTransfer();
                        debugPrint('about to send request...');

                      }
                    }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void processTransfer() async{

    var appConfig = AppConfig.of(context);

    var transferData = {'amount': _amount.toString(), 'transferChannel': _transferChannel, 'comment': _comment, 'platform': 'Mobile'};

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
      var response = await http.post('${appConfig.apiV1Base}transferService/request-transfer', headers: appConfig.authorizationHeader, body: transferData);

      //Remove Wait dialog box.
      Navigator.of(context).pop();

      if(response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return Otp();
            }
        ));
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context){
            if(Platform.isIOS){
              return CupertinoAlertDialog(
                title: Text('Transfer Error'),
                content: Text(response.body),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    isDefaultAction: true,
                  )
                ],
              );
            }
            return AlertDialog(
              title: Text('Transfer Error'),
              content: Text(response.body),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      }
    }catch(e, s){

    }
  }

}