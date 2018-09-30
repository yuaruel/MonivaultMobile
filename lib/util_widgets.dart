import 'package:flutter/material.dart';

class WaitCircularIndicator extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {

    return new Center(
      heightFactor: 1.0,
      child: new ListTile(
        leading: new CircularProgressIndicator(value: null,),
        title: const Text('Please wait...'),
      ),
    );
  }
}