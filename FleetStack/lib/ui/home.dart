import '/code/home_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

ValueNotifier<int> selectedindex = ValueNotifier(0);

class _homepageState extends State<homepage> {
  final home_code stack = Get.put(home_code());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedindex,
        builder: (context, value, child) {
          return Obx(
            () => Scaffold(
              backgroundColor: Color(0xFFecedee),
              body: stack.screens[selectedindex.value],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedindex.value,
                onTap: (i) => selectedindex.value = i,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,

                selectedItemColor: Color(0xFF064ad3),
                unselectedItemColor: Color(0xFF515151),
                selectedFontSize: 14.0,
                unselectedFontSize: 11.0,
                elevation: 10.0,
                // ignore: avoid_function_literals_in_foreach_calls
                items: [
                  BottomNavigationBarItem(
                      icon: stack.bottomitems[0].icon,
                      activeIcon: stack.bottomitems[0].activeIcon,
                      label: stack.bottomitems[0].label?.tr),
                  BottomNavigationBarItem(
                      icon: stack.bottomitems[1].icon,
                      activeIcon: stack.bottomitems[1].activeIcon,
                      label: stack.bottomitems[1].label?.tr),
                  BottomNavigationBarItem(
                      icon: stack.bottomitems[2].icon,
                      activeIcon: stack.bottomitems[2].activeIcon,
                      label: stack.bottomitems[2].label?.tr),
                  BottomNavigationBarItem(
                      icon: stack.bottomitems[3].icon,
                      activeIcon: stack.bottomitems[3].activeIcon,
                      label: stack.bottomitems[3].label?.tr),
                  BottomNavigationBarItem(
                      icon: stack.bottomitems[4].icon,
                      activeIcon: stack.bottomitems[4].activeIcon,
                      label: stack.bottomitems[4].label?.tr),
                ],
              ),
            ),
          );
        });
  }
}
