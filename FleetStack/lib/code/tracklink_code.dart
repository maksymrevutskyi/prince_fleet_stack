import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


import '../common/FleetStack.dart';

class tracklink_code extends GetxController{

  var all = [].obs;

  final selectedvehicle = 0.obs;
  Rx<List<Map<String, dynamic>>> vehiclelist = Rx([]);
  var fordtselection =  DateTime.now().add(Duration(days: 1)).obs;
   var isloading = false.obs;

   final  isgeofence = true.obs;
   final ispoi = true.obs;
   final isdriverdetails = true.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    bindlist();
  }



  bindlist() async{
     print("binding the list of tracking");
     //externallinklist
     all.value = [];
     var result=  await FleetStack.getauthdata('externallinklist');


     if (result["respcode"] == true) {
       var data = await FleetStack.stringtojson(result["data"]);

       if(data.length > 0) {
         all.value = data;
         print(all.value);
         print(all.value.length);
       }

     }

    // isloading.value = false;

     fillvehiclelist();

  }

  copytext(String text){
    print("coping the text ${text}");
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Copied", "Text has been copied to clipboard");
  }

  deletelink(int id) async{
    print('Deleting the ${id}');



    Map<String, dynamic> postdata = {};
    postdata["id"] = id.toString();

    var result = await FleetStack.delauthdata('deletelink', postdata);
    print(result);
    if(result["respcode"] == true)
    {
      var data = FleetStack.stringtojson(result["data"]);
      print(data);
      print(data[0]["error"].runtimeType);
      if(data[0]["error"] == 1){
        Get.snackbar( "deleted".tr, "deleted_successfully".tr );
        bindlist();
      }

    }




  }

  createlink() async{
    print("creating the link");

    isloading.value = true;


    if(selectedvehicle.value == 0)
    {
      Get.snackbar('input_validation'.tr, 'kindly_select_vehicle'.tr);
      isloading.value = false;
      return;
    }

    var addons = '${isgeofence.value ==true?1:0},${ispoi.value ==true?1:0},${isdriverdetails.value ==true?1:0}';

    Map<String, dynamic> queryParameters = {};
    queryParameters["deviceId"] = selectedvehicle.value;
    queryParameters["uptodate"] = fordtselection.value.toString().substring(0,16);
    queryParameters["addons"] =  addons;

    var result = await FleetStack.postauthdata('createtracklink', queryParameters);

     if(result["respcode"] == true)
       {
          var data = FleetStack.stringtojson(result["data"]);
          Get.snackbar( data[0]["msg"], data[0]["ulink"] );
       }

     await bindlist();
    isloading.value = false;

    Navigator.pop(Get.context!);

  }


  fillvehiclelist() async{
    var data = await FleetStack.getauthdata('getDevices');
    if(data["respcode"] == true)
    {
      var vlist = await FleetStack.stringtojson(data["data"]);
      vehiclelist.value =  List<Map<String, dynamic>>.from(vlist);
    }
  }

  Widget customdropdown(  {required int currentvalue , required List<Map<String, dynamic>> list }) {
    return Expanded(
      child: Container(
        // width:  double.infinity,

        child: DropdownButton<int>(
          iconSize: 30,
          // focusColor: appcolor.runninglight,
          alignment: Alignment.center,
          value: currentvalue,
          onChanged:    (int? newValue) {
            if(newValue !=null) {
              selectedvehicle.value = newValue!;
            }
          },
          items: [
            DropdownMenuItem<int>(
              value: 0,
              child: Text("Select Vehicle"),
            ),
            ...list.map((Map<String, dynamic> vehicle) {
              return DropdownMenuItem<int>(
                value: vehicle["deviceid"],
                child: Text(vehicle["vehicleno"]),
              );
            }),
          ],
        ),
      ),
    );
  }


}