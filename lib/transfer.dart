import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

class Transfer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TransferState();
  }

}

class TransferState extends State<Transfer>{
  var _formKeyState = GlobalKey<FormState>();

  var _transferChannel = '';
  var atmSelected = false;
  var bankSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transfer'),
        centerTitle: true,
      ),
      body: Container(
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
                value: 'atm',
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
                value: 'bank',
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
                  hintText: 'Transfer Amount'
                ),
                keyboardType: TextInputType.number,
                onEditingComplete: (){
                  debugPrint('this editing is complete.');
                },

                validator: (amountValue){
                  try{
                    Validate.notBlank(amountValue, 'Amount is required');

                  }on ArgumentError catch(e){
                    return e.message;
                  }
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

                    }
                  }),
              )
            ],
          ),
        ),
      ),
    );
  }

}