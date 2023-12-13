import '/ui/dashboard.dart';
import '/ui/other.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/FleetStack.dart';
import '../ui/list.dart';
import '../ui/map.dart';
import '../common/widgets.dart';
import '../ui/utility.dart';

class home_code extends GetxController {
  late var screens = [dashboard(), map(), list(), utility(), other()];
  RxList<BottomNavigationBarItem> bottomitems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        activeIcon: Icon(Icons.home),
        label: 'status'.tr),
    BottomNavigationBarItem(
        icon: Icon(Icons.map), activeIcon: Icon(Icons.map), label: 'map'.tr),
    BottomNavigationBarItem(
        icon: Icon(Icons.list_rounded),
        activeIcon: Icon(Icons.list_rounded),
        label: 'list'.tr),
    BottomNavigationBarItem(
        icon: Icon(Icons.explore_outlined),
        activeIcon: Icon(Icons.explore_outlined),
        label: 'utility'.tr),
    BottomNavigationBarItem(
        icon: Icon(Icons.video_library_outlined),
        activeIcon: Icon(Icons.video_library_outlined),
        label: 'other'.tr)
  ].obs;
  final currentlanguage = "en_US".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final currenttime =
        DateFormat(appcolor.apptime, "en_US").format(DateTime.now()).obs;
    displaynavigation();
  }

  displaynavigation() async {
    var navigationsetting = await FleetStack.getlocal("navsetting");
    if (navigationsetting.length > 0) {
      List<String> navigations = navigationsetting
          .substring(1, navigationsetting.length - 1)
          .split(", ")
          .toList();
      screens.clear();
      bottomitems.clear();
      for (int i = 0; i < navigations.length; i++) {
        switch (navigations[i]) {
          case 'Map':
            screens.add(map());
            bottomitems.add(BottomNavigationBarItem(
                icon: Icon(Icons.map),
                activeIcon: Icon(Icons.map),
                label: 'map'.tr));
            break;
          case 'list':
            screens.add(list());
            bottomitems.add(BottomNavigationBarItem(
                icon: Icon(Icons.list_rounded),
                activeIcon: Icon(Icons.list_rounded),
                label: 'list'.tr));
            break;
          case 'status':
            screens.add(dashboard());
            bottomitems.add(BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home),
                label: 'status'.tr));
            break;
          case 'utility':
            screens.add(utility());
            bottomitems.add(BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore_outlined),
                label: 'utility'.tr));
            break;
          case 'Other':
            screens.add(other());
            bottomitems.add(BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.video_library_outlined),
                label: 'other'.tr));
            break;
          default:
            print('Invalid action');
        }
      }
    } else {
      screens = [dashboard(), map(), list(), utility(), other()];
    }
  }
}
