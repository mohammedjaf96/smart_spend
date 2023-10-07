import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartspend/controller_pages/dashboardController.dart';
import 'package:smartspend/controller_pages/mainBinding.dart';
import 'package:smartspend/controller_pages/mainController.dart';
import 'package:smartspend/model_pages/initNotifications.dart';
import 'package:smartspend/screen_pages/dashboardPage.dart';
import 'package:smartspend/screen_pages/profilePage.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {

  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  final InitNotifications initNotifications = InitNotifications();
  await initNotifications.initNotifications();
  /// Initialize locale data for the Arabic locale
  await initializeDateFormatting('ar',null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Spend',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: (){
          return GetBuilder<mainController>(
            init: mainController(),
            builder: (controller){
              return dashboardPage();
            },
          );
        }),
      ],
      initialBinding: mainBinding(),
    );
  }
}


