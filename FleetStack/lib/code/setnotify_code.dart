import '/common/FleetStack.dart';
import 'package:get/get.dart';

import '../common/notificationservice.dart';

class setnotify_code extends GetxController{
  var all = [].obs;
  var notifytoken = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    displaylist();
  }


  displaylist() async{

    print("displaying the entire vehilce list");
    var result = await FleetStack.getauthdata("getDevices");
    print(result);
    if(result["respcode"] == true){
      all.value  = await FleetStack.stringtojson(result["data"]);
    }
    print(all.value);

  }

  displaybottomsheet() async{
    print("tring to access token and print");

     notifytoken.value = await LocalNotificationService.notifytoken();
   // notifytoken.value = "e_bcGzGGSziW0E0P7uQkPa:APA91bH3hyKBv2BI3B66hUZfHFjBSMl1qctR1PXqhjlMd8NtBxheCY4qRBtI2-e4dSOZQzKi9pGtuDu43v2MY8TAc67wdYwCkbOIXNHVOAb-NFRwH0gpICRWz4SCKpfNa-CYaPjkslOg";
  // notifytoken.value = "";
  }

  configurenotify() async {



    var userdetails = await FleetStack.getlocal("userdetails");
    var result = await FleetStack.stringtojson(userdetails);


     Map<String, dynamic> queryParameters = {};
     queryParameters["userid"] = result[0]["userid"];
     queryParameters["playerid"] = notifytoken.value;
     queryParameters["notifyfor"] =  "1";

     var serverresult = await FleetStack.postauthdata('setPlayerId', queryParameters);
      print(serverresult);
     if(serverresult["respcode"] == true){
       Get.back();
       Get.snackbar('notifications'.tr, 'notification_set_success'.tr);

     }
     else{
       Get.snackbar('notifications'.tr, 'unable_to_update'.tr);
     }



  }



}