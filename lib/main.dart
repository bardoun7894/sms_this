
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
  String status_msg = "";
  bool enableFocus ;
  String ipisnot="";
  TextEditingController _textController =new TextEditingController();
  bool isCorrect =false;
  bool edit =false;
static const platform = const MethodChannel('sendSms');
  Future<Bills> getFactureData() async {
    var url =  'http://${_textController.text}:8000/api/getFacture/';

    var response = await http.get( url,headers:{
      HttpHeaders.contentTypeHeader: "application/json",'api_password':'12345678'// or whatever
    } );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return data.fromJson(jsonResponse).bills;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
}
Future<Bills> sendData(int id ,String status) async{
   var url = 'http://${_textController.text}:8000/api/smsSended';
     http.post(url,headers:{ "Accept": "application/json",'api_password':'12345678'},body: {
      "facture_id":"$id",
      "status": status
    }) ;
}
Future<Bills> futureBi;
Future sendSms(String numb,String msg ,int id ) async {

final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"});
if(result=="SMS Sent"){
  sendData(id,"success");
}else{
    sendData(id,"failed");
}

print("Send//SMS");

}

RegExp regExp = new RegExp(
 r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
  caseSensitive: false,
  multiLine: true,
);

@override
Widget build(BuildContext context) {
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
        switch(snapshot.connectionState){
          case ConnectionState.none:
            print('none') ;
         CircularProgressIndicator(backgroundColor: Colors.blue,);
            break;
          case ConnectionState.waiting:
            // TODO: Handle this case.
            print('waiting');
      CircularProgressIndicator(backgroundColor: Colors.blue,);
            break;
          case ConnectionState.active:

          case ConnectionState.done:
            print('done');

            return new  ListView.builder(
                shrinkWrap: true,
                itemCount:snapshot.data.facture.length,
                itemBuilder: (BuildContext ctxt, int i) {
                  List<Facture> l = snapshot.data.facture;

                  sendSms(l[i].home.phone, "msg", 1);

                  String s = " ${l[i].home.landlord} عزيزنا العميل "  ;
                  String sa =   " \n قيمة الفاتورة الحالية هي ${l[i].price}  ريال " ;
                  String depta=" مجموع الديون السابقة هو  ${l[i].home.debt} ريال ";
                  String smsMessage =sa + s +depta;
                  sendSms(l[i].home.phone, smsMessage,l[i].id);


                  switch(status_msg){
                    case "failed":
                      return Center(child: Text("تعذر ارسال الرسالة",style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),));
                      break;
                    case"success":
                      return Center(child: Text("تم ارسال الرسالة بنجاح",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),));
                      break;
                    default:
                      return Text("");
                      break;
                  }
                }
            );

            break;
        }

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
),
);
}
}