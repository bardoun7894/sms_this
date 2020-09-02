
import 'dart:async';
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
static const platform = const MethodChannel('sendSms');
  Future<Bills> getFactureData() async{
    var url =  'http://10.0.2.2:8000' ;
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url,headers:{"password":"12345678","Accept": "application/json, text/plain, */*"} );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return Bills.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
}
Future<Bills> sendData(int id ,String status) async{
    var url = 'http://10.0.2.2:8000';
    // Await the http get response, then decode the json-formatted response.
     http.post(url,headers:{ "Accept": "application/json","password":"12345678"},body: {
      "facture_id":"$id",
      "status":status
    }).then((value) =>print(value));

}
Future<Bills> futureBi;
Future sendSms(String numb,String msg) async {
try {
final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"$numb","msg":"$msg"}); //Replace a 'X' with 10 digit phone number
print(result);
print("Send//SMS");
} on PlatformException catch(e){
print(e.toString());
}
}

@override
Widget build(BuildContext context) {

return new Material(
child: new Container(
alignment: Alignment.center,
child: Column(
  children: [
  FutureBuilder<Bills>(
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
          String s = "$userName عزيزنا العميل ";
          String sa =   "\n قيمة الفاتورة الحالية هي $price  ريال " ;
          String depta=" مجموع الديون السابقة هو  $debt ريال ";
          sendSms(numberPhone,sa+s+depta);
          sendData(id," success ");
          return Column(
            children: [
              Text(sa+s),
              Text(depta),
            ],
          );

        }
    );

  } else if (snapshot.hasError) {
  return Text("${snapshot.error}");
  }
  // By default, show a loading spinner.
  return CircularProgressIndicator();
  },
  )
  ],
),
),
);
}
}