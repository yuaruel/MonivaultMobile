import 'package:flutter/material.dart';

class AirtimeVendor extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AirtimeVendorState();
  }

}

class AirtimeVendorState extends State<AirtimeVendor>{

  var _airtimeVendor = 'airtel';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _airtimeVendor,
      items: [
        DropdownMenuItem<String>(
          value: 'airtel',
          child: Text('Airtel'),
        ),
        DropdownMenuItem<String>(
          value: 'mtn',
          child: Text('MTN'),
        ),
        DropdownMenuItem<String>(
          value: 'glo',
          child: Text('Glo'),
        ),
        DropdownMenuItem<String>(
          value: '9mobile',
          child: Text('9Mobile'),
        )
      ],
      onChanged: (selectedVendor){
        setState(() {
          _airtimeVendor = selectedVendor;
        });
      },
    );
  }

}