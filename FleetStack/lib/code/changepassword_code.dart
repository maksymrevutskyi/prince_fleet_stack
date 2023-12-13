import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/FleetStack.dart';

class changepassword_code extends GetxController{
  final oldpass = TextEditingController();
  final newpass = TextEditingController();
  final confirmpass = TextEditingController();

  changepassword() async{

    print("changing the password process");
    var current_pass = oldpass.value.text;
    var new_pass = newpass.value.text;
    var confirm_pass = confirmpass.value.text;

    if (current_pass == '' || new_pass == '' || confirm_pass == "") {
      Get.snackbar('validation'.tr, 'kindly_fill'.tr);
      return;
    }

    if( new_pass != confirm_pass){
      Get.snackbar('validation'.tr, 'Confirm Password not match'.tr);
      return;
    }

    Map<String, dynamic> postdata = {};
    postdata["oldpassword"] = current_pass;
    postdata["password"] = new_pass;

    var result = await FleetStack.postauthdata('UpdateUserPassword', postdata);
    print(result);
    if (result["respcode"] == true) {
      var data = FleetStack.stringtojson(result["data"]);
      if (data[0]["error"] == 1) {
        Get.snackbar("success".tr, "password_changed_successfully".tr);
        oldpass.clear();
        newpass.clear();
        confirmpass.clear();
      }
      else if(data[0]["error"] == 0){
        Get.snackbar("result".tr, data[0]["msg"]);
        return;
      }
    }



  }

}