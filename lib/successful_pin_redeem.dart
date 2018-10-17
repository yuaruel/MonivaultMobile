import 'package:flutter/material.dart';

class SuccessfulPinRedeem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('PIN Redeem'),
          centerTitle: true
      ),
      body: Center(
        child: Text('PIN Redeem Successfull!',
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.green
          ),
        ),
      ),
    );
  }

}