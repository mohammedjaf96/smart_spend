import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartspend/model_pages/categoryModel.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class postMovmentController extends GetxController {


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    checkVisibilityKeyboard();
  }

  @override
  void onClose(){
    // TODO: implement onInit
    super.onClose();
  }

  bool loading = false;
  changeLoading(){
    loading = !loading;
    update();
  }


  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  /// this for postMovmentPage when selectcategory
  categoryModel? categorySelected;
  selectCategory(categoryModel value){
    categorySelected = value;
    update();
  }



  showSnakBar(title,des){
    Get.snackbar(title, des,
        titleText: Text(title,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),),messageText:
        Text(des,textAlign: TextAlign.right,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.white),));
  }


  /// check if the keyBoard visibility or not
  bool visibilityKeyboard = false;
  checkVisibilityKeyboard(){
    KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      visibilityKeyboard = visible;
    });
    update();
  }




  /// i use this function to set schedul in local notification
  Future<void> scheduleNotifications(DateTime time,title,body) async {


    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
        provisional: true
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        convertTime(time.hour,time.minute),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',sound: RawResourceAndroidNotificationSound('sound'))),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time
    );
  }

  /// this function convert time to country time zone and set schedul for notifications
  tz.TZDateTime convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime schedulDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);

    if(schedulDate.isBefore(now)){
      schedulDate = schedulDate.add(const Duration(days: 1));
    }
    return schedulDate;
  }
}