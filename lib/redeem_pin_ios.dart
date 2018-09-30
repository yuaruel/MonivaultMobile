
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosPinRedeem extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return IosPinRedeemState();
  }

}

class IosPinRedeemState extends State<IosPinRedeem>{
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: 'Back',
          middle: Text('PIN Redeem'),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          margin: const EdgeInsets.only(top: 200.0),
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
              CupertinoButton(
                child: Text('Save',
                style: TextStyle(fontSize: 25.0),),
                onPressed: (){},
              )
            ],
          ),
        )
      ),
    );
  }

}