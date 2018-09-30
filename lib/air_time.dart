import 'package:flutter/material.dart';
import 'package:monivault_mobile/air_time_vendors.dart';

class Airtime extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AirtimeState();
  }

}

class AirtimeState extends State<Airtime>{

  var _formKeyState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airtime Purchase'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 35.0, left: 25.0, right: 25.0),
        child: Form(
          key: _formKeyState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AirtimeVendor(),
              SizedBox(height: 55.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Recipient Phone Number',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 55.0,),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Airtime Amount'
                ),
                keyboardType: TextInputType.number,
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
                  onPressed: (){},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}