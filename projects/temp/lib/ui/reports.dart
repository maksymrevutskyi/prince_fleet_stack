import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets.dart';
import 'reports/log.dart';
import 'reports/overspeed.dart';


class reports extends StatelessWidget {
  const reports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('reports'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              nav( iconsrc : Icon(Icons.car_repair, color: appcolor.stop , size: 30), title: 'log_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
                Get.to(log());
              } ),
              nav( iconsrc : Icon(Icons.local_taxi, color: appcolor.running, size: 30), title: 'over_speed_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
                Get.to(overspeed());
              } ),

              // nav( iconsrc : Icon(Icons.car_repair, color: appcolor.stop , size: 30), title: 'stopage_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
              //   Get.to(log());
              // } ),
              //
              // nav( iconsrc : Icon(Icons.summarize, color: appcolor.lightblack , size: 30), title: 'day_wise_summary'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
              //   Navigator.pushNamed(context, '/replay');
              // } ),
              // nav( iconsrc : Icon(Icons.timeline, color: appcolor.lightblack, size: 30), title: 'trip_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
              //   Navigator.pushNamed(context, '/replay');
              // } ),
              // nav( iconsrc : Icon(Icons.sensors, color: appcolor.lightblack, size: 30), title: 'sensor_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
              //   Navigator.pushNamed(context, '/replay');
              // } ),
              // nav( iconsrc : Icon(Icons.taxi_alert, color: appcolor.lightblack, size: 30), title: 'alert_report'.tr, des: 'checkout the playback history of your vehicle' , navtap: (){
              //   Navigator.pushNamed(context, '/replay');
              // } ),



            ],

          ),
        ),
      ),
    );
  }
}
