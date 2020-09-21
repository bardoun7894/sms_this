package com.example.sms_this;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.security.acl.Permission;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {
    private static final int MY_PERMISSIONS_REQUEST_SEND_SMS =0 ;

    private static final String CHANNEL = "sendSms";

    private MethodChannel.Result callResult;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.SEND_SMS},MY_PERMISSIONS_REQUEST_SEND_SMS );
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if(call.method.equals("send")){
                            String num = call.argument("phone");
                            String msg = call.argument("msg");
                            sendSMS(num,msg,result);
                        }else{
                            result.notImplemented();
                            }
                         }
                       });
                    }
    protected void sendSMS(String phoneNo, String msg,MethodChannel.Result result) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
                try {
                    SmsManager smsManager = SmsManager.getDefault();
                    smsManager.sendTextMessage(phoneNo, null, msg,null, null);
                    result.success("SMS Sent");
                    } catch (Exception ex) {
                    ex.printStackTrace();
                    result.error("Err","Sms Not Sent","");
                }
        }else{
         result.error("Err","Sms Not Sent","");
         }
            }
//protected void sendSMS(String phoneNo, String msg,MethodChannel.Result result) {
//
//    if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
//        if (ActivityCompat.shouldShowRequestPermissionRationale(this,Manifest.permission.SEND_SMS)) {
//            try{
//            SmsManager smsManager = SmsManager.getDefault();
//            smsManager.sendTextMessage(phoneNo, null, msg, null, null);
//            result.success("SMS Sent");
//          Toast.makeText(getApplicationContext(), "SMS sent.",Toast.LENGTH_LONG).show();
//            }catch(Exception ex){
//                ex.printStackTrace();
//         result.error("Err","Sms Not Sent","");
//            }
//                 } else {
//            ActivityCompat.requestPermissions(this,  new String[]{Manifest.permission.SEND_SMS},MY_PERMISSIONS_REQUEST_SEND_SMS );
//                     }
//                 }
//          }

//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//        switch (requestCode) {
//            case MY_PERMISSIONS_REQUEST_SEND_SMS: {
//         if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//
//                } else {
//
//                    Toast.makeText(getApplicationContext(), "SMS faild, please try again.", Toast.LENGTH_LONG).show();
//                    return;
//                }
//            }
//        }
//
//    }
}
