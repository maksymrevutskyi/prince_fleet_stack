import '/common/FleetStack.dart';
import 'package:get/get.dart';

class notify_code extends GetxController{

  final device_id = "".obs;
  final vehicleno = "".obs;

  final ispower_cut = false.obs;
  final isignition = false.obs;
  final isover_speed = false.obs;
  final isParkingEnable = false.obs;
  final isignitionOff = false.obs;
  final isaccident = false.obs;
  final isdoor = false.obs;
  final ishardAcceleration = false.obs;
  final ishardBraking = false.obs;
  final ishardCornering = false.obs;
  final islowBattery = false.obs;
  final ispowerOff = false.obs;
  final ispowerOn = false.obs;
  final ispowerRestored = false.obs;
  final isshock = false.obs;
  final issos = false.obs;
  final istampering = false.obs;
  final isvibration = false.obs;





  displaypage(deviceid) async{
    device_id.value = deviceid;
    getnotifydata();


  }

  getnotifydata() async{
    var result = await FleetStack.getauthdata('UserNotificationByDeviceID?deviceid=${device_id.value}');
    print(result);
    if(result["respcode"] == true){
      var data = await FleetStack.stringtojson(result["data"]);
      print(data);
      print(data[0]["power_cut"]);


      ispower_cut.value = data[0]["power_cut"] ?? false;
      isignition.value = data[0]["ignition"] ?? false;
      isover_speed.value = data[0]["over_speed"] ?? false;
      isParkingEnable.value = data[0]["ParkingEnable"] ?? false;
      isignitionOff.value = data[0]["ignitionOff"] ?? false;
      isaccident.value = data[0]["accident"] ?? false;
      isdoor.value = data[0]["door"] ?? false;
      ishardAcceleration.value = data[0]["hardAcceleration"] ?? false;
      ishardBraking.value = data[0]["hardBraking"] ?? false;
      ishardCornering.value = data[0]["hardCornering"] ?? false;
      islowBattery.value = data[0]["lowBattery"] ?? false;
      ispowerOff.value = data[0]["powerOff"] ?? false;
      ispowerOn.value = data[0]["powerOn"] ?? false;
      ispowerRestored.value = data[0]["powerRestored"] ?? false;
      isshock.value = data[0]["shock"] ?? false;
      issos.value = data[0]["sos"] ?? false;
      istampering.value = data[0]["tampering"] ?? false;
      isvibration.value = data[0]["vibration"] ?? false;
      vehicleno.value = data[0]["VehicleNO"];

    }
  }


  updatenotify(String type, bool status) async{
     print('we are getting details');
     print('${type} and ${status}');


     var current_status = status == true? "1":"0";

     Map<String, dynamic> postdata = {};
     postdata["deviceid"] = device_id.value;
     postdata["notifytype"] = type;
     postdata["notifyvalue"] = current_status;

     var result = await FleetStack.patchauthdata('SetNotification', postdata);
     if(result["respcode"]== true){
       getnotifydata();
     }



  }

}