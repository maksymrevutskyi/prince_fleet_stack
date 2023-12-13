import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../code/changepassword_code.dart';
import '../common/widgets.dart';

class changepassword extends StatelessWidget {
  changepassword({Key? key}) : super(key: key);
  final changepassword_code stack = Get.put(changepassword_code());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('change_password'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),

                TextField(
                  controller: stack.oldpass,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'current_password'.tr,
                  ),
                ),

                SizedBox(height: 30),

                TextField(
                  controller: stack.newpass,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'new_password'.tr,
                  ),
                ),
                SizedBox(height: 30),

                TextField(
                  controller: stack.confirmpass,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'confirm_password'.tr,
                  ),
                ),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, //New
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 20.0,),

                                Text("update_password".tr, style: TextStyle(color:  Colors.black87, fontWeight: FontWeight.bold),),
                                SizedBox(width: 10.0,),
                                Icon(Icons.arrow_forward,
                                  size: 20,),
                                SizedBox(width: 20.0,),
                              ],
                            ),
                          )
                      ),
                      onTap: stack.changepassword,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
