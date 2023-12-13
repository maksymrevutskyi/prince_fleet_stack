import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/FleetStack.dart';
import '../common/notificationservice.dart';
import '../ui/home.dart';

class login_code extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordText = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checklogin();
  }

  void checklogin() async {
    FleetStack.setlanguage();
    var userdetails = await FleetStack.getlocal("userdetails");
    var token = await FleetStack.getlocal("token");

    print('printing the value of token & user details');
    print(userdetails);
    print(token);

    if (token.length > 5) {
      Get.to(homepage());
    }
  }

  void loginsubmit() async {
    var username = usernameController.text;
    var password = passwordController.text;

    if (username == "") {
      Get.snackbar('login'.tr, 'kindly_enter_username'.tr);
      return;
    } else if (password == "") {
      Get.snackbar('login'.tr, 'kindly_enter_password'.tr);
      return;
    } else {
      var result = await FleetStack.login(username, password);
      if (result["token"] != null) {
        Get.snackbar('login'.tr, 'login_success'.tr);
        FleetStack.savelocal("token", result["token"]);
        FleetStack.savelocal("userdetails", result["data"]);

        var data = await FleetStack.stringtojson(result["data"]);

        var token = await LocalNotificationService.notifytoken();

        Map<String, dynamic> queryParameters = {};
        queryParameters["userid"] = data[0]["userid"].toString();
        // queryParameters["playerid"] = "e_bcGzGGSziW0E0P7uQkPa:APA91bH3hyKBv2BI3B66hUZfHFjBSMl1qctR1PXqhjlMd8NtBxheCY4qRBtI2-e4dSOZQzKi9pGtuDu43v2MY8TAc67wdYwCkbOIXNHVOAb-NFRwH0gpICRWz4SCKpfNa-CYaPjkslOg";
        queryParameters["playerid"] = token;
        queryParameters["notifyfor"] = "1";

        result = await FleetStack.postauthdata('setPlayerId', queryParameters);
        print(result);
        if (result["respcode"] == true) {
          Get.offAll(homepage());
        }
      } else {
        Get.snackbar('login'.tr, 'invalid_username_password'.tr);
        return;
      }
    }
  }

  void demologin() async {
    var result = await FleetStack.login("akhilesher13@gmail.com", "123456");
    if (result["token"] != null) {
      Get.snackbar('login'.tr, 'demo_account_login_success'.tr);
      FleetStack.savelocal("token", result["token"]);
      FleetStack.savelocal("userdetails", result["data"]);
      var data = await FleetStack.stringtojson(result["data"]);
      var token = await LocalNotificationService.notifytoken();
      Map<String, dynamic> queryParameters = {};
      queryParameters["userid"] = data[0]["userid"].toString();
      queryParameters["playerid"] = token;
      // queryParameters["playerid"] = "e_bcGzGGSziW0E0P7uQkPa:APA91bH3hyKBv2BI3B66hUZfHFjBSMl1qctR1PXqhjlMd8NtBxheCY4qRBtI2-e4dSOZQzKi9pGtuDu43v2MY8TAc67wdYwCkbOIXNHVOAb-NFRwH0gpICRWz4SCKpfNa-CYaPjkslOg";
      queryParameters["notifyfor"] = "1";
      result = await FleetStack.postauthdata('setPlayerId', queryParameters);
      if (result["respcode"] == true) {
        Get.to(homepage());
      }
    }

    // var token = await LocalNotificationService.notifytoken();

    // print(token);

    // print(result);
    // print(result["data"].runtimeType);
  }
}
