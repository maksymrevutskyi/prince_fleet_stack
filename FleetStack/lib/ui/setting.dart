import '/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/widgets.dart';
import 'changepassword.dart';
import 'language.dart';
import 'navsetting.dart';
import 'setnotify.dart';

class setting extends StatelessWidget {
  const setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAll(homepage(), predicate: (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: appcolor.gray,
        appBar: AppBar(
          title: Text('settings'.tr),
          backgroundColor: appcolor.white,
          foregroundColor: appcolor.lightblack,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>
                Get.offAll(homepage(), predicate: (route) => false),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 15),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  nav(
                      iconsrc: Icon(Icons.language,
                          color: Color(0xff2e2e2f), size: 30),
                      title: 'language'.tr,
                      des:
                          'change_the_application_language_as_per_your_compatibility'
                              .tr,
                      navtap: () {
                        Get.to(language());
                      }),
                  nav(
                      iconsrc: Icon(Icons.add_alert,
                          color: Color(0xff2e2e2f), size: 30),
                      title: 'notifications'.tr,
                      des:
                          'set_the_notification_preference_according_to_the_use_cases'
                              .tr,
                      navtap: () {
                        Get.to(setnotify());
                      }),
                  nav(
                      iconsrc:
                          Icon(Icons.lock, color: Color(0xff2e2e2f), size: 30),
                      title: 'change_password'.tr,
                      des: 'protect_user_account'.tr,
                      navtap: () {
                        Get.to(changepassword());
                      }),
                  nav(
                      iconsrc: Icon(Icons.menu_open_sharp,
                          color: Color(0xff2e2e2f), size: 30),
                      title: 'navigation_setting'.tr,
                      des: 'set_navigation_as'.tr,
                      navtap: () {
                        Get.to(navsetting());
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
