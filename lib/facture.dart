import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'model/bills.dart';

class FactureData with ChangeNotifier{

  static const platform = const MethodChannel('sendSms');
String ip_url ="";
String status_message ="";

  Future<Bills> getFactureData() async {
    var url =  'http://${ip_url}:8000/api/getFacture/';
    var response = await http.get( url,headers:{
      HttpHeaders.contentTypeHeader: "application/json",'api_password':'12345678'// or whatever
    } );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return data.fromJson(jsonResponse).bills;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

Future<Bills> sendData(int id ,String status) async{
  var url = 'http://${ip_url}:8000/api/smsSended';
  http.post(url,headers:{ "Accept": "application/json",'api_password':'12345678'},body: {
    "facture_id":"$id",
    "status": status
  }).then((value) => print(value.body)) ;
  notifyListeners();
}
Future sendSms(String numb,String msg ,int id ) async {
  final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"});
  if(result == "SMS Sent"){
    sendData(id,"success");
    status_message ="success";
  }else{
    sendData(id,"failed");
    status_message ="failed";
  }
  print("Send//SMS");
}

}