import 'package:flutter/material.dart';

class AirtimeVendor extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AirtimeVendorState();
  }

}

class AirtimeVendorState extends State<AirtimeVendor>{

  var _airtimeVendor = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
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
    );
  }

}