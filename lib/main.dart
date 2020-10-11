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
  runApp(
    new MaterialApp(
      title: "Rotation Demo",
      home: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return FactureData();
          },
        )
      ], child: new SendSms()),
    ),
  );
}

class SendSms extends StatelessWidget {
  TextEditingController _textController = new TextEditingController();

  static const platform = const MethodChannel('sendSms');
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FactureData>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        primary: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, left: 10),
                          child: TextFormField(
                            decoration:
                                InputDecoration(hintText: " ip أدخل ال  "),
                            controller: _textController,
                            enabled: bloc.enableFocus,
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: FlatButton(

                                onPressed: () {
                                  bloc.ip_url = _textController.text;
                                  bloc.changeVis(bloc.ip_url);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right:18.0),
                                      child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                    ),
                                    Text(
                                      "   ارسل الرسائل   ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color:  bloc.edit ? Colors.grey : Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20)),
                            ),

                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 50),

                      ),
                      // FlatButton(
                      //   onPressed: () {
                      //     bloc.editIp();
                      //   },
                      //   color: bloc.edit ? Colors.green : Colors.grey,
                      //   child:Text(
                      //     "تعديل",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      bloc.isCorrect
                          ? FWidget(context)
                          : Center(
                              child: Text(
                              "${bloc.ip_is_not}",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
