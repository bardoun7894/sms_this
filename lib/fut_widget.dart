import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_this/facture.dart';

import 'model/bills.dart';

Widget FWidget(BuildContext context){
  var b =Provider.of<FactureData>(context,listen: false);
  return FutureBuilder<Bills>(
    future:b.getFactureData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        switch(snapshot.connectionState){
          case ConnectionState.none:
            print('none') ;
           Text("لا يوجد بيانات");
            break;
          case ConnectionState.waiting:
          // TODO: Handle this case.
            print('waiting');
            CircularProgressIndicator(backgroundColor: Colors.blue,);
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            print('done');
            return Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount:snapshot.data.facture.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      List<Facture> l = snapshot.data.facture ;
                      String smsMessage =" عزيزنا العميل${l[i].home.landlord } قيمة الفاتورة ${l[i].price} مجموع الديون هي ${l[i].home.debt} ";
                     b.sendSms(l[i].home.phone,smsMessage,l[i].id).then(
                      (value) => print(value)
                     );
                      print("${b.status_message} m ");
                   return;
                    }
                 ),
         Center(child:b.status_message=="success"? Text( "تم ارسال الرسالة بنجاح",style:TextStyle(color: Colors.green,fontSize: 20,fontWeight:FontWeight.bold),):( b.status_message=="failed"?Text("لم يتم ارسال الرسالة تأكد من الاتصال ؟",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.red),):Text("")))
                  ],
            );
            break;
        }
      } else if (snapshot.hasError) {
        return Center(child: Text("لا يوجد اتصال او وقع خطأ من جهة الويب",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.red)));
      }else{
        return Center(child: Text(" لا يوجد انترنت او فاتورة غير متاحة",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.red)));
      }

      // By default, show a loading spinner.

      return CircularProgressIndicator();
    },

  ) ;
}