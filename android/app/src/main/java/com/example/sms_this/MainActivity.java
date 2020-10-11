package com.example.sms_this;

import android.Manifest;
import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
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
    String SENT ="SMS_SENT";
    String DELIVERED ="SMS_DELIVERED";
    String resultSend ="";
     PendingIntent sentPI,deliveredPI;
     BroadcastReceiver smsSentReciever ,smsDeliveredReciever ;

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
        sentPI =PendingIntent.getBroadcast(this,0,new Intent(SENT),0);
        deliveredPI =PendingIntent.getBroadcast(this,0,new Intent(DELIVERED),0);
                    }
    @Override
    protected void onPause() {
        super.onPause();
        unregisterReceiver(smsDeliveredReciever);
        unregisterReceiver(smsSentReciever);
    }

    @Override
    protected void onResume() {
        super.onResume();
        smsSentReciever =new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                switch (getResultCode())
                {
                    case Activity.RESULT_OK:
                        Toast.makeText(getBaseContext(), "SMS sent",
                            Toast.LENGTH_SHORT).show();
                        resultSend = "SMS Sent";
                        break;
                    case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
                        Toast.makeText(getBaseContext()," Generic failure",
                                Toast.LENGTH_SHORT).show();
                        resultSend = "Generic failure";
                        break;
                    case SmsManager.RESULT_ERROR_NO_SERVICE:
                        Toast.makeText(getBaseContext(), "No service",
                                Toast.LENGTH_SHORT).show();
                        resultSend = "no service";

                        break;
                    case SmsManager.RESULT_ERROR_NULL_PDU:
                        Toast.makeText(getBaseContext(), "Null PDU",
                        Toast.LENGTH_SHORT).show();
                        resultSend = "null PDU";
                        break;
                    case SmsManager.RESULT_ERROR_RADIO_OFF:
                        Toast.makeText(getBaseContext(), "Radio off ",
                                Toast.LENGTH_SHORT).show();
                        resultSend = "Radio off";
                        break;
                }
            }
        };
        smsDeliveredReciever =new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                switch (getResultCode())
                {
                    case Activity.RESULT_OK:
                        Toast.makeText(getBaseContext(), "SMS delivered",
                         Toast.LENGTH_SHORT).show();
                        resultSend = "sms delivered";
                        break;
                    case Activity.RESULT_CANCELED:
                        Toast.makeText(getBaseContext(),
                                "SMS not delivered",
                                Toast.LENGTH_SHORT
                        ).show();
                        resultSend = "sms not delivered";
                        break;
                }
            }
        };

registerReceiver(smsSentReciever,new IntentFilter(SENT));
registerReceiver(smsDeliveredReciever,new IntentFilter(DELIVERED));

    }

    protected void sendSMS(String phoneNo, String msg ,MethodChannel.Result result) {

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
                try {

                    SmsManager smsManager = SmsManager.getDefault();
                    smsManager.sendTextMessage(phoneNo, null, msg,sentPI, deliveredPI);
                    result.success(resultSend);

                    } catch (Exception ex) {
                    ex.printStackTrace();
                    result.error("Err","Sms Not Sent","");
                }
        }else{
         result.error("Err","Sms Not Sent","");
         }
            }
}
