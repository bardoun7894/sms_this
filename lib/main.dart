
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_this/facture.dart';
import 'package:sms_this/fut_widget.dart';

import 'model/bills.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
runApp(     new MaterialApp(
  title: "Rotation Demo",
  home: MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (BuildContext context) {
         return FactureData();
        },
        )
      ],
  child: new SendSms()),
  ),
 );
}


class SendSms extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController _textController =new TextEditingController();

static const platform = const MethodChannel('sendSms');


//  Future<Bills> getFactureData() async {
//    var url =  'http://${_textController.text}:8000/api/getFacture/';
//    var response = await http.get( url,headers:{
//      HttpHeaders.contentTypeHeader: "application/json",'api_password':'12345678'// or whatever
//    } );
//    if (response.statusCode == 200) {
//      var jsonResponse = convert.jsonDecode(response.body);
//      return data.fromJson(jsonResponse).bills;
//    } else {
//      print('Request failed with status: ${response.statusCode}.');
//    }
//}
//Future<Bills> sendData(int id ,String status) async{
//   var url = 'http://${_textController.text}:8000/api/smsSended';
//     http.post(url,headers:{ "Accept": "application/json",'api_password':'12345678'},body: {
//      "facture_id":"$id",
//      "status": status
//    }).then((value) => print(value.body)) ;
//
//}
Future<Bills> futureBi;

//Future sendSms(String numb,String msg ,int id ) async {
//
//final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"});
//if(result == "SMS Sent"){
//  sendData(id,"success");
//}else{
//  sendData(id,"failed");
//}
//print("Send//SMS");
//}



@override
Widget build(BuildContext context) {
  final bloc =Provider.of<FactureData>(context);
return new Material(
child: SingleChildScrollView(
  child:   new Container(
  alignment: Alignment.center,
  child: Padding(
    padding: const EdgeInsets.all(28.0),
    child:   Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: " ip أدخل ال  "
          ),
          controller: _textController,
            enabled: bloc.enableFocus,
          style: TextStyle(color: Colors.blueAccent,fontSize: 24),
        ),
      Padding(
        padding: const EdgeInsets.only(top:18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              onPressed:(){
               bloc.ip_url = _textController.text ;
               bloc.changeVis(bloc.ip_url);
              } ,
              color: bloc.edit ? Colors.grey : Colors.blueAccent,
              child: Text("حفظ",style: TextStyle(color: Colors.white),),
            ),
            FlatButton(
              onPressed:(){
                bloc.editIp();
              }  ,
              color:bloc.edit ?Colors.green:Colors.grey,
              child: Text("تعديل",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
      bloc.isCorrect ? FWidget(context):Center(child: Text("${bloc.ip_is_not}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),))

  ],

    ),

  ),
  ),
),
);
}

}