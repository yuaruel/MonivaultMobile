import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monivault_mobile/air_time.dart';
import 'package:monivault_mobile/air_time_vendors.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:monivault_mobile/redeem_pin_android.dart';
import 'package:monivault_mobile/redeem_pin_ios.dart';
import 'package:monivault_mobile/transfer.dart';
import 'app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class HomeApp extends StatefulWidget{

  final String _firstName;
  final String _lastName;
  final String _accountId;

  HomeApp(this._firstName, this._lastName, this._accountId);

  @override
  State<StatefulWidget> createState() {
    return HomeAppState();
  }

}
class HomeAppState extends State<HomeApp>{

  AppConfig appConfig;
  
  String _availableBalance = '';
  String _ledgerBalance = '';
  String _interestAccrued = '';
  String _payoutDate = '';
  String _currentYear = '';
  String _payoutTotal = '';

  var currencyFormat = intl.NumberFormat.currency(locale: "en-GB", name: "NGN", symbol: "N", decimalDigits: 2);

  @override
  void initState() {

    super.initState();

    //Set current year.
    _currentYear = DateTime.now().year.toString();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    appConfig = AppConfig.of(context);
    fetchBalanceDetail();
    fetchInterestDetail();
  }

  @override
    Widget build(BuildContext context) {

      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('MoniVault', textDirection: TextDirection.ltr,),
          centerTitle: true,
          backgroundColor: lightSecondaryColor
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: lightSecondaryColor),
                accountEmail: new RichText(
                  text: new TextSpan(
                    text: 'AccountID: ', style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: widget._accountId, style: TextStyle(fontWeight: FontWeight.normal))
                    ]
                  ),
                ),
                accountName: new Text(widget._firstName + ' ' + widget._lastName),
              ),
              ListTile(leading: Icon(Icons.home), title: Text('Home', textDirection: TextDirection.ltr,),),
              ListTile(
                leading: Icon(Icons.save),
                title: Text('Save'),
                onTap: (){
                  //Close the drawer
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context){
                      return PinRedeem();
                    }
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.keyboard),
                title: Text('Airtime'),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex){
                      return Airtime();
                    }
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.art_track),
                title: Text('Transfer'),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context){
                      return Transfer();
                    }
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app), 
                title: Text('Logout', textDirection: TextDirection.ltr,),
                onTap: () {
                  //Revok access token, and erase AccountID, and name.
                  Navigator.of(context).pushReplacementNamed("login");                
                },
              )
            ],
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: lightSecondaryColor,
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_availableBalance,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 35.0),
                          ),
                          Text('Available Balance'),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(_ledgerBalance,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                          ),
                          Text('Ledger Balance')
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: FlatButton(
                      onPressed: (){},
                      child: Text('Recent Transactions', style: TextStyle(fontSize: 20.0),),
                      textColor: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Current Running Interest'),
                          Text(_interestAccrued)
                        ],
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Next Payout Date'),
                          Text(_payoutDate)
                        ],
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total Interest Paid ' + _currentYear),
                          Text(_payoutTotal)
                        ],
                      )
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      );
    }

  Future<Map<String, double>> fetchBalanceDetail() async{

    StringBuffer urlParam = StringBuffer(appConfig.apiV1Base + 'accountHolderService/balance-detail');

    try {

      var response = await http.get(urlParam.toString(), headers: appConfig.authorizationHeader);

      var responseBody = json.decode(response.body);

      setState(() {
        _availableBalance = currencyFormat.format(responseBody['availableBalance']);
        _ledgerBalance = currencyFormat.format(responseBody['ledgerBalance']);
      });

    }catch(e, s){
      debugPrint('error: ' + e.toString());
      debugPrint('stacktrace: ' + s.toString());
    }
  }

  Future<void> fetchInterestDetail() async{
    String serviceApi = appConfig.apiV1Base + "accountHolderService/interest-detail";

    try{

      var response = await http.get(serviceApi, headers: appConfig.authorizationHeader);

      var responseBody = json.decode(response.body);

      setState(() {
        _interestAccrued = currencyFormat.format(currencyFormat.parse(responseBody['accruedInterest']));
        _payoutDate = responseBody['payoutDate'];
        _payoutTotal = currencyFormat.format(currencyFormat.parse(responseBody['totalPayout']));
      });
    }catch(e, s){
      debugPrint('error: ${e.toString()}');
      debugPrint('stacktrace: ${s.toString()}');
    }
  }
}