import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'model/bills.dart';

class FactureData with ChangeNotifier{

  static const platform = const MethodChannel('sendSms');
  bool enableFocus ;
  bool isCorrect = false;
  bool edit = false;
String ip_url = "";
String status_message ;
 String ip_is_not = "";

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
  }).then((value) => print("post ${value.body} ")) ;
  notifyListeners();
}
Future sendSms(String numb,String msg ,int id ) async {
  final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"});
  print(result);
  if(result == "SMS Sent"){
    status_message ="success";
    print(" ${status_message}  sendsms");
  await sendData(id,"success");
    notifyListeners();
  }else{
    status_message ="failed";
   await  sendData(id,"failed");
    print("${status_message}  sendsms");
    notifyListeners();
  }
  print("Send//SMS   ${status_message}");
  notifyListeners();
}

changeVis(ip_url){
  RegExp regExp = new RegExp(
    r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
    caseSensitive: false,
    multiLine: true,
                 );
  if(ip_url.length!=0 && regExp.hasMatch(ip_url)){
    print(ip_url);
    // enableFocus = false;
   isCorrect = true;
    // edit = true;
      }
      else
      {
    isCorrect =false;
    if (ip_url.length==0)
         {
            ip_is_not = "  ip لم تدخل اي  ";
         }
    if(!regExp.hasMatch(ip_url))
         {
            ip_is_not = "خاطئ ip ";

         }
   }
  print("ff $ip_is_not");
  notifyListeners();
}
editIp(){
  enableFocus=true;
  if(edit)
  {
    edit=false;
    print("dd ${enableFocus}");
  }
  notifyListeners();
       }


}