import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/FleetStack.dart';

class log_code extends GetxController{

  var all = [].obs;

  final selectedvehicle = 0.obs;
  Rx<List<Map<String, dynamic>>> vehiclelist = Rx([]);
  var fromdtselection = DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 00,00 ).obs;
  var todtselection = DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 23,58 ).obs;
  var isloading = false.obs;


 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fillvehiclelist();
   // testing();
  }


  testing() async{

    var result = await FleetStack.getauthdata('getListOfallDevice');
    if (result["respcode"] == true) {
      var vehiclelist = await FleetStack.stringtojson(result["data"]);
      print(vehiclelist);
      all.value = vehiclelist;
    }

    }


  showresult() async{

   print("submit to the server");
   isloading.value = true;

   if(selectedvehicle.value == 0)
   {
     Get.snackbar('input_validation'.tr, 'kindly_select_vehicle'.tr);
     isloading.value = false;
     return;
   }

   all.value = [];

  // var fromdate = Uri.encodeComponent(fromdtselection.value.toString()).replaceAll(".000", "");

   var date =  '${fromdtselection.value.year}-${fromdtselection.value.month}-${fromdtselection.value.day}';


   // var result = await FleetStack.getauthdata(
   //     'getHistoryReplayDta?deviceid=${selectedvehicle.value}&startdt=${fromdate}&enddt=${todate}');

   var result=  await FleetStack.getauthdata('getDevicelogReport?deviceid=${selectedvehicle.value}&ondate=${date}');


   if (result["respcode"] == true) {
     var data = await FleetStack.stringtojson(result["data"]);

     if(data.length > 0) {
       all.value = data;
     }

     }

   isloading.value = false;
   Get.back();
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