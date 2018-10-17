import 'package:flutter/material.dart';

class SuccessfulTransfer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
        centerTitle: true
      ),
      body: Center(
        child: Text('Transfer Successfull!',
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