import 'package:flutter/material.dart';

class SucccessfulRecharge extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Recharge'),
          centerTitle: true
      ),
      body: Center(
        child: Text('Airtime Recharge Successfull!',
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