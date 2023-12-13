import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'code/list_code.dart';
import 'common/languages.dart';
import 'common/notificationservice.dart';
import 'ui/home.dart';
import 'ui/intro.dart';
import 'ui/login.dart';
import 'common/FleetStack.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  LocalNotificationService.initialize();
 //  await Firebase.initializeApp( options: const FirebaseOptions( apiKey: "AIzaSyD1OLX4qkBbbLDu1qqWW8JAsi3Ifvvq5LQ", appId: "1:268164031420:web:02aac8e9135c50a6f381b9", messagingSenderId: "268164031420", projectId: "fleetstack-7766a" ));
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.notifcationPermitions();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token") ?? '';
  var isintro = prefs.getString("intro") ?? 'false';
  // FleetStack.setlanguage();
  runApp(MyApp(token: token, isintro: isintro));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({Key? key, required this.token, required this.isintro})
      : super(key: key);
  final String token;
  final String isintro;

  @override
  Widget build(BuildContext context) {
    Get.put(list_code());
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Languages(),
        // locale: Get.deviceLocale,
        // fallbackLocale: const Locale('en', 'US'),

        title: 'Fleet Stack',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        // home: intro()
        home: token.length > 1
            ? homepage()
            : isintro == "false"
                ? intro()
                : login());
  }
}
