
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monivault_mobile/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:monivault_mobile/utils/Transaction.dart';

class RecentTransaction extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return RecentTransactionState();
  }

}

class RecentTransactionState extends State<RecentTransaction>{

  Future<List<Transaction>> _recentTransactions;
  AppConfig _appConfig;
  int _itemSize = 0;

  @override
  void initState() {
    super.initState();
    debugPrint("init was called...");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _appConfig = AppConfig.of(context);
    _recentTransactions = getRecentTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Transactions'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Transaction>>(
        initialData: List<Transaction>(),
        future: _recentTransactions,
        builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(width: 0.0, height: 0.0);
              break;
            case ConnectionState.done:
              if(snapshot.hasError){
                return Text('An error occurred!');
              }else{
                if(snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _itemSize,
                    itemBuilder: (BuildContext context, int index){
                      return listItem(snapshot.data[index]);
                    }
                  );
                }else{
                  return Container(width: 0.0, height: 0.0);
                }
              }

              break;
          }
        },
      ),
    );
  }

  Future<List<Transaction>> getRecentTransactions() async{
    debugPrint("called future method");

    List<Transaction> transactions;
    try {

      String serviceUrl = _appConfig.apiV1Base + "transactionService/recent-transactions";
      debugPrint("service url: ${serviceUrl}");

      debugPrint("calling api...");
      var response = await http.get(
          serviceUrl, headers: _appConfig.authorizationHeader);

      debugPrint("returned from call...");
      var responseBody = json.decode(response.body) as List;
      setState((){
        _itemSize = responseBody.length;
      });

      debugPrint("first object: ${responseBody[0]}");

      transactions = responseBody.map((data) => Transaction.fromJson(data)).toList();

      debugPrint("response: ${transactions}");
    }catch(e, s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    return transactions;
  }

  Widget listItem(Transaction transaction){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(transaction.description,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(transaction.transactionDate),
              Text(_appConfig.currencyFormat.format(transaction.amount))
            ],
          )
        ],
      ),
    );
  }
}