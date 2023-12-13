import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/FleetStack.dart';

class support_code extends GetxController{

  final titleController = TextEditingController();
  final desController = TextEditingController();


  sendfeedback() async {
    var title = titleController.value.text;
    var des = desController.value.text;

    if (title == '' || des == '') {
      Get.snackbar('validation'.tr, 'kindly_fill'.tr);
      return;
    }


    Map<String, dynamic> postdata = {};
    postdata["title"] = title;
    postdata["detail"] = des;

    var result = await FleetStack.postauthdata('Createfeedback', postdata);
    print(result);
    if (result["respcode"] == true) {
      var data = FleetStack.stringtojson(result["data"]);
      if (data[0]["error"] == 1) {
        Get.snackbar("success".tr, "request_sent_to_admin".tr);
        titleController.clear();
        desController.clear();
      }
    }
  }


}