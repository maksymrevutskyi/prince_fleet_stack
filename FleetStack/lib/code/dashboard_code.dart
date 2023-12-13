import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:core';

import '../common/FleetStack.dart';
import '../common/widgets.dart';
import '../ui/dashboard.dart';

class dashboard_code extends GetxController {
  late Timer tm;

  final driven = 0.0.obs;
  final total = 0.obs;
  final running = 0.obs;
  final stop = 0.obs;
  final idle = 0.obs;
  double lvalue = 50;
  double interval = 1;
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.redAccent,
  ];
  List graphData = [];
  RxList<ChartSampleData> graphDataDisplay = <ChartSampleData>[].obs;
  final lastweekkm = "".obs;
  final growth = 0.obs;
  final utility = 0.obs;
  double maxKmValue = 0;
  List<String> titles = [];
  final currentlanguage = "en_US".obs;

  final is_announcement = false.obs;
  final announcementtype = "".obs;
  final announcementtitle = "".obs;
  final announcementcontent = "".obs;


  final currenttime =
      DateFormat(appcolor.apptime, "en_US").format(DateTime.now()).obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getchartData();
    checking();
    getData();
    announcement();

    tm = Timer.periodic(Duration(seconds: 55), (timer) {
      currenttime.value = DateFormat(appcolor.apptime, currentlanguage.value)
          .format(DateTime.now());
      getData();
    });
  }

  Future onRefreshPage() {
    currenttime.value = DateFormat(appcolor.apptime, currentlanguage.value)
        .format(DateTime.now());
    getData();
    getchartData();
    return Future.value();
  }

  getchartData() async {
    graphDataDisplay.clear();
    var result = await FleetStack.postauthdata(
        'getApiForDashboardGraph', {"vehicleid": "0"});
    if (result["respcode"] == true) {
      graphData = jsonDecode(result["data"]);
      for (int i = 0; i < graphData.length; i++) {
        titles.add(graphData[i]["device_dt"].toString().substring(8, 10));
        graphDataDisplay
            .add(ChartSampleData(x: titles[i], y: graphData[i]["TotalKm"]));
        if (graphData[i]["TotalKm"] > maxKmValue) {
          maxKmValue = graphData[i]["TotalKm"];
        }
      }
    }
  }

  void checking() async {
    String languagevalue = await FleetStack.getlocal("language");
    currentlanguage.value = languagevalue == '' ? "en_US" : languagevalue;
    initializeDateFormatting(currentlanguage.value);
    FleetStack.setlanguage();
  }

  void getData() async {
    var result = await FleetStack.getauthdata('getAllDeviceStatus');
    if (result["respcode"] == true) {
      var vehicledata = FleetStack.stringtojson(result["data"]);

      driven.value = vehicledata[0]["tottodaykm"];
      total.value = vehicledata[0]["total"];
      running.value = vehicledata[0]["running"];
      stop.value = vehicledata[0]["stop"];
      idle.value = vehicledata[0]["ideal"];
    }
    result = await FleetStack.getauthdata('getDashboardOther');

    if (result["respcode"] == true) {
      var dashboarddata = FleetStack.stringtojson(result["data"]);
      lastweekkm.value = '${dashboarddata[0]["lastweekkm"]} KM';
      growth.value = dashboarddata[0]["growth"];
      utility.value = dashboarddata[0]["utile"];
      // update();
    }
  }

  void announcement() async{
    is_announcement.value = false;
    var result = await FleetStack.getauthdata('getAnnoucment');
    if (result["respcode"] == true) {
      var announcementdata = FleetStack.stringtojson(result["data"]);
      if(announcementdata.length >0){
        is_announcement.value = true;
        announcementtitle.value =  announcementdata[0]["title"];
        announcementtype.value = announcementdata[0]["anntype"];
        announcementcontent.value = announcementdata[0]["detail"];
      }
      else{
        is_announcement.value = false;
      }
    }

  }

  void showvehicle(String type) {}
}
