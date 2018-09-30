
import 'package:flutter/material.dart';

class AndroidPinRedeem extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return AndroidPinRedeemState();
  }

}

class AndroidPinRedeemState extends State<AndroidPinRedeem>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIN Redeem'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'OneCard PIN',
                  border: OutlineInputBorder(

                  )
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: 'Comment',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            SizedBox(
              width: 250.0,
              height: 55.0,
              child: RaisedButton(
                color: Colors.blue,
                child: Text('Save',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),),
                onPressed: (){},
              ),
            )
          ],
        ),
      ),
    );
  }

}