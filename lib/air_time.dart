import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monivault_mobile/air_time_vendors.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/app_utils.dart';
import 'package:monivault_mobile/successful_recharge.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;

class Airtime extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AirtimeState();
  }

}

class AirtimeState extends State<Airtime>{

  var _formKeyState = GlobalKey<FormState>();
  var _phoneNo = '';
  var _airtimeVendor = '';
  double _airtimeAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airtime Purchase'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 35.0, left: 25.0, right: 25.0),
          child: Form(
            key: _formKeyState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              DropdownButton(
                hint: Text('Select Network'),
              value: _airtimeVendor,
              items: [
                DropdownMenuItem<String>(
                  value: '',
                  child: Text(''),
                ),
                DropdownMenuItem<String>(
                  value: 'AIRT',
                  child: Text('Airtel'),
                ),
                DropdownMenuItem<String>(
                  value: 'MTN',
                  child: Text('MTN'),
                ),
                DropdownMenuItem<String>(
                  value: 'Glo',
                  child: Text('Glo'),
                ),
                DropdownMenuItem<String>(
                  value: 'ETST',
                  child: Text('9Mobile'),
                )
              ],
              onChanged: (selectedVendor){
                setState(() {
                  _airtimeVendor = selectedVendor;
                });
              },
            ),
                SizedBox(height: 55.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Recipient Phone Number',
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (phoneValue){
                    try{
                      Validate.notBlank(phoneValue, 'Phone Number is required');
                      Validate.matchesPattern(phoneValue, RegExp(r"\d{11}"), 'Invalid phone number');
                    }on ArgumentError catch (e){
                      return e.message;
                    }
                  },
                  onSaved: (phoneValue){
                    _phoneNo = phoneValue;
                  },
                ),
                SizedBox(height: 55.0,),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Amount',
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
                    if(numValue.remainder(1000) > 0){
                      throw ArgumentError('Amount should be a multiple of 1,000');
                    }

                  }on ArgumentError catch(e){
                    return e.message;
                  }on FormatException{
                    return 'Invalid amount';
                  }
                },
                onSaved: (amountValue){
                  _airtimeAmount = double.parse(AppUtil.unformatCurrency(amountValue));
                },
              ),
                SizedBox(height: 55.0,),
                SizedBox(
                  height: 45.0,
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Purchase',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: (){
                      var formState = _formKeyState.currentState;
                      if(formState.validate()){
                        if(_airtimeVendor.isNotEmpty) {
                          formState.save();
                          purchaseAirtime();
                        }else{
                          AppUtil.displayAlert('Network Provider', 'Select network', context);
                        }
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

  void purchaseAirtime() async{
    var appConfig = AppConfig.of(context);

    var platformSpecific = Platform.isAndroid ? 'Android' : 'iOS';

    var requestData = {'productCode': _airtimeVendor, 'airtimeAmount': '${_airtimeAmount.toString()}0', 'phoneNumber': _phoneNo,
                      'requestOriginatingPlatform': 'Mobile', 'platformSpecific': platformSpecific};

    AppUtil.displayWait(context);
    var response = await http.post('${appConfig.apiV1Base}topUpService/airtime-recharge',
                                    headers: appConfig.authorizationHeader, body: requestData);

    Navigator.pop(context);

    if(response.statusCode == 200){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context){
          return SucccessfulRecharge();
        }
      ));
    }else{
      var responseError = jsonDecode(response.body);
      AppUtil.displayAlert("Recharge Error", responseError['reason'], context);
    }
  }

}