import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/FleetStack.dart';

class list_code extends GetxController {
  static list_code get to => Get.find();

  TextEditingController searchController = TextEditingController();

  var all = [].obs;
  var vehicles = [].obs;
  final total = 0.obs;
  final running = 0.obs;
  final stop = 0.obs;
  final idle = 0.obs;

  Future onRefreshPage() {
    vehilcelist();
    list_code.to.loadrunning('');
    return Future.value();
  }

  void vehilcelist() async {
    print("loding list .... ");
    var result = await FleetStack.getauthdata('getListOfallDevice');

    print(result);

    if (result["respcode"] == true) {
      var vehiclelist = await FleetStack.stringtojson(result["data"]);
      vehicles.value = vehiclelist;
      all.value = vehiclelist;
      print(vehiclelist);
    }

    var analytics = await FleetStack.getauthdata('getAllDeviceStatus');
    if (analytics["respcode"] == true) {
      print("analytics");
      var vehicleanalitics = await FleetStack.stringtojson(analytics["data"]);

      total.value = vehicleanalitics[0]["total"];
      running.value = vehicleanalitics[0]["running"];
      stop.value = vehicleanalitics[0]["stop"];
      idle.value = vehicleanalitics[0]["ideal"];
    }
  }

  void loadrunning(String status) async {
    var result = await FleetStack.getauthdata(
        'getListOfallDevice?DeviceState=${status}');
    if (result["respcode"] == true) {
      var vehiclelist = await FleetStack.stringtojson(result["data"]);
      vehicles.value = vehiclelist;
    } else {
      vehicles.value = [];
    }
  }

  void vsearch(String text) {
    vehicles.value = all
        .where((vehicle) => vehicle["vehicleno"]
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase()))
        .toList();
  }
}
