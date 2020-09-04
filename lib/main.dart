
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sms_this/bills.dart';
void main() {
runApp(new MaterialApp(
title: "Rotation Demo",
home: new SendSms(),
));
}
class SendSms extends StatefulWidget {
@override
_SendSmsState createState() => new _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  bool enableFocus ;
  String ipisnot="";
  TextEditingController _textController =new TextEditingController();
  bool isCorrect =false;
  bool edit =false;
static const platform = const MethodChannel('sendSms');
  Future<Bills> getFactureData() async{
    var queryParameters = {
      'password': '12345678',
    };
    var uri =  Uri.https('http://${_textController.text}:8000', '/api/getFacture/', queryParameters);
    var response = await http.get(uri, headers: {
     // HttpHeaders.authorizationHeader: 'Token $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
   // var url =  'http://${_textController.text}:8000/api/getFacture/' ;
    // Await the http get response, then decode the json-formatted response.
//    var response = await http.get(url,headers:{
//      HttpHeaders.contentTypeHeader: "application/json", // or whatever
//
//    } );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Bills.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
}
Future<Bills> sendData(int id ,String status) async{
    var url = 'http://${_textController.text}:8000/api/smsSended';
    var queryParameters = {
      'password': '12345678',
    };
    var uri =  Uri.https('http://${_textController.text}:8000', '/api/smsSended/', queryParameters);
    // Await the http get response, then decode the json-formatted response.
     http.post(uri,headers:{ "Accept": "application/json"},body: {
      "facture_id":"$id",
      "status":status
    }).then((value) =>print(value));
}
Future<Bills> futureBi;
Future sendSms(String numb,String msg ,int id ) async {
try {
final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"}); //Replace a 'X' with 10 digit phone number
print(result);
print("Send//SMS");
if(id!=null){
  sendData(id,"success");
}
} on PlatformException catch(e){
  if(id!=null){
    sendData(id,"failed");
  }
print(e.toString());
}
}
RegExp regExp = new RegExp(
 r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
  caseSensitive: false,
  multiLine: true,
);

@override
Widget build(BuildContext context) {
print(isCorrect);

return new Material(
child: new Container(
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
          enabled: enableFocus,
        style: TextStyle(color: Colors.blueAccent,fontSize: 24),

      ),


    Padding(
      padding: const EdgeInsets.only(top:18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed:(){

              if(_textController.text.length!=0 && regExp.hasMatch(_textController.text)){
                setState(() {
                  enableFocus=false;
                  isCorrect =true;
                  edit=true;
                });
              }else{
                setState(() {
                  isCorrect =false;
                  if(_textController.text.length==0){
                    ipisnot="لم تدخل اي Ip";
                  }
                });
                  }
            } ,
            color: edit ? Colors.grey : Colors.blueAccent,
            child: Text("حفظ",style: TextStyle(color: Colors.white),),
          ),
        FlatButton(
            onPressed:(){
           setState(() {
            enableFocus=true;
            if(edit){
              edit=false;
            }   });  } ,
            color:edit ?Colors.green:Colors.grey,

            child: Text("تعديل",style: TextStyle(color: Colors.white),),

          ),

        ],

      ),
    ),

    isCorrect ? FutureBuilder<Bills>(

    future: getFactureData(),

    builder: (context, snapshot) {

    if (snapshot.hasData) {

       return new  ListView.builder

        (
         shrinkWrap: true,
          itemCount:snapshot.data.facture.length,
          itemBuilder: (BuildContext ctxt, int i) {

            int id =snapshot.data.facture[i].id;

            String numberPhone =snapshot.data.facture[i].home.phone;

            String userName =snapshot.data.facture[i].home.landlord;

            String debt =snapshot.data.facture[i].home.debt;

            String price =snapshot.data.facture[i].price;

            String s = " $userName عزيزنا العميل "  ;

            String sa =   " \n قيمة الفاتورة الحالية هي $price  ريال " ;

            String depta=" مجموع الديون السابقة هو  $debt ريال ";

             print("is sent");

             sendSms(numberPhone,sa+ s +depta,id);

            return;



          }

      );



    } else if (snapshot.hasError) {

    return Text("${snapshot.error}");
    }

    // By default, show a loading spinner.

    return CircularProgressIndicator();

    },

    ):Text(ipisnot,style: TextStyle(color: Colors.red),)

    ],

  ),
),
),
);
}
}