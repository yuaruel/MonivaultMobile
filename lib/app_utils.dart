import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class AppUtil{
  static final currencyFormatter = intl.NumberFormat.currency(locale: "en-GB", name: "NGN", symbol: "N", decimalDigits: 2);
  static final editCurrencyFormatter = intl.NumberFormat.currency(locale: "en-GB", name: "NGN", symbol: "N", decimalDigits: 0);

  static String unformatCurrency(String currentCurrency){
    return currentCurrency.substring(1).replaceAll(',', '').trim();
  }

  static void displayAlert(String title, String alertContent, BuildContext context){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context){
        if(Platform.isAndroid) {
          return AlertDialog(
            title: Text(title),
            content: Text(alertContent),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.blue,
                child: Text('OK', style: TextStyle(fontSize: 20.0),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }else if(Platform.isIOS){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(alertContent),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                textStyle: TextStyle(fontSize: 20.0),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }

      }
    );
  }

  static Future displayAlertAsync(String title, String alertContent, BuildContext context){
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context){
          if(Platform.isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: Text(alertContent),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.blue,
                  child: Text('OK', style: TextStyle(fontSize: 20.0),),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }else if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(alertContent),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OK'),
                  textStyle: TextStyle(fontSize: 20.0),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }

        }
    );
  }

  static void displayWait(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Center(
              heightFactor: 1.0,
              child: new ListTile(
              leading: new CircularProgressIndicator(value: null,),
          title: const Text('Please wait...'),
          )));
        });
  }

  //TODO I would come back to this. I want only one displayWait, however, I do not have the luxury of time to start fixing all the usage of this method
  static Future displayWaitAsync(context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Center(
                  heightFactor: 1.0,
                  child: new ListTile(
                    leading: new CircularProgressIndicator(value: null,),
                    title: const Text('Please wait...'),
                  )));
        });
  }
}

class AmountFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var currentText = newValue.text;
    if(currentText.contains('N')){
      currentText = AppUtil.unformatCurrency(currentText);
    }

    try{
      return newValue.copyWith(text: AppUtil.editCurrencyFormatter.format(double.parse(currentText)));
    }on FormatException{
      return newValue;
    }
  }
}

