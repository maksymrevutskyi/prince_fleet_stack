import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../code/notify_code.dart';
import '../common/widgets.dart';


class notify extends StatefulWidget {
  final String deviceid;
  const notify({Key? key, required this.deviceid}) : super(key: key);

  @override
  State<notify> createState() => _notifyState(deviceid);
}

class _notifyState extends State<notify> {

  final notify_code stack = Get.put(notify_code());

  _notifyState(String deviceid) {
    stack.displaypage(deviceid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecedee),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF175ff0) ,
        ),
        title: Obx(() =>
            Text( stack.vehicleno.value,
              style: TextStyle(
                color: Color(0xFF175ff0),
              ),),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              //  height: MediaQuery.of(context).size.height/3.8,
                color: Colors.white,
                padding: EdgeInsets.all(25),

                child: Obx(() =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('basic_notification'.tr,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff535454)
                            )),
                        SizedBox(height: 15),



                        notifylist(
                          title: 'ignition_on'.tr ,
                          type: "ignition",
                          status: stack.isignition.value,
                        ),

                        notifylist(
                          title: 'ignition_off'.tr ,
                          type: "ignitionOff",
                          status: stack.isignitionOff.value,
                        ),

                        notifylist(
                          title: 'sos'.tr ,
                          type: "sos",
                          status: stack.issos.value,
                        ),
                        notifylist(
                          title: 'power_cut'.tr ,
                          type: "power_cut",
                          status: stack.ispower_cut.value,
                        ),
                        notifylist(
                          title: 'parking_enable'.tr ,
                          type: "ParkingEnable",
                          status: stack.isParkingEnable.value,
                        ),
                        notifylist(
                          title: 'vibration'.tr ,
                          type: "vibration",
                          status: stack.isvibration.value,
                        ),
                        notifylist(
                          title: 'low_battery'.tr ,
                          type: "lowBattery",
                          status: stack.islowBattery.value,
                        ),
                        notifylist(
                          title: 'hard_braking'.tr ,
                          type: "hardBraking",
                          status: stack.ishardBraking.value,
                        ),

                        notifylist(
                          title: 'hard_acceleration'.tr ,
                          type: "hardAcceleration",
                          status: stack.ishardAcceleration.value,
                        ),
                        notifylist(
                          title: 'hard_cornering'.tr ,
                          type: "hardCornering",
                          status: stack.ishardCornering.value,
                        ),

                        notifylist(
                          title: 'tampering'.tr ,
                          type: "tampering",
                          status: stack.istampering.value,
                        ),

                        notifylist(
                          title: 'power_on'.tr ,
                          type: "powerOn",
                          status: stack.ispowerOn.value,
                        ),
                        notifylist(
                          title: 'power_off'.tr ,
                          type: "powerOff",
                          status: stack.ispowerOff.value,
                        ),
                        notifylist(
                          title: 'accident'.tr ,
                          type: "accident",
                          status: stack.isaccident.value,
                        ),
                        notifylist(
                          title: 'power_restored'.tr ,
                          type: "powerRestored",
                          status: stack.ispowerRestored.value,
                        ),
                        notifylist(
                          title: 'shock'.tr ,
                          type: "shock",
                          status: stack.isshock.value,
                        ),
                        notifylist(
                          title: 'door'.tr ,
                          type: "door",
                          status: stack.isdoor.value,
                        ),








                      ],
                    )
                )
            ),


          ],
        ),
      ),
    );
  }
}


class notifylist extends StatelessWidget {
   notifylist({Key? key, required this.title, required this.type, required this.status}) : super(key: key);
   final notify_code stack = Get.put(notify_code());
   final String title;
  final String type;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        Spacer(),
        Container(
          height: 40,
          width: 90,
          child: Switch(
            value: status,
            onChanged: (bool value) async {

               stack.updatenotify(type,value);

            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }
}
