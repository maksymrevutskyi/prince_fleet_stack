import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../code/profile_code.dart';
import '../common/widgets.dart';
import 'aboutus.dart';
import 'setting.dart';
import 'support.dart';

class profile extends StatelessWidget {
  profile({Key? key}) : super(key: key);

  final profile_code stack = Get.put(profile_code());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
          backgroundColor: appcolor.white,
          foregroundColor: appcolor.blue,
          elevation: 0,
          centerTitle: true,
          title: Text('profile'.tr)),
      body: Column(
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                ClipPath(
                  clipper: customshape(),
                  child: Container(
                    height: 150,
                    color: appcolor.white,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0.0),
                        height: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: appcolor.gray, width: 3),
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                  'assets/images/profile.png',
                                ))),
                      ),
                      Obx(
                        () => Text(
                          '${stack.name.value}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: appcolor.lightblack,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Obx(
                        () => Text(
                          '${stack.company.value}',
                          style: TextStyle(
                            fontSize: 14,
                            color: appcolor.grayblack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Color(0xFFf6f9ff), Color(0xFFf6f9ff)]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, //New
                      blurRadius: 25.0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // drawmenu(iconsrc: Icon(Icons.account_circle_rounded),title:"Profile", redirect: '/'),
                    drawmenu(
                        iconsrc: Icon(Icons.business),
                        title: "about_us".tr,
                        icontap: () {
                          Get.to(aboutus());
                        }),
                    drawmenu(
                        iconsrc: Icon(Icons.textsms),
                        title: "support".tr,
                        icontap: () {
                          Get.to(support());
                        }),
                    drawmenu(
                        iconsrc: Icon(Icons.settings),
                        title: "settings".tr,
                        icontap: () {
                          Get.to(setting());
                        }),
                  ],
                )),
          ),
          SizedBox(
            height: 40.0,
          ),
          GestureDetector(
            child: SizedBox(
              width: 183,
              height: 45,
              child: Image.asset('assets/images/logo.png'),
            ),
            onTap: () {
              stack.logoclick();
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          GestureDetector(
            onTap: () {
              stack.logout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('logout'.tr,
                    style: TextStyle(
                      color: appcolor.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),
                SizedBox(width: 15),
                Icon(
                  Icons.logout,
                  color: appcolor.blue,
                  size: 25,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
