import '/code/home_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/FleetStack.dart';
import '../common/widgets.dart';
import 'language.dart';

class navsetting extends StatefulWidget {
  const navsetting({Key? key}) : super(key: key);

  @override
  State<navsetting> createState() => _navsettingState();
}

class _navsettingState extends State<navsetting> {
  late List<String> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaylist();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  displaylist() async {
    var navigationsetting = await FleetStack.getlocal("navsetting");
    if (navigationsetting.length > 0) {
      items.clear();
      items = navigationsetting
          .substring(1, navigationsetting.length - 1)
          .split(", ")
          .toList();
      setState(() {
        items;
      });
    } else {
      items = ["status", "Map", "list", "utility", "Other"];
      setState(() {
        items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('navigation_setting'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            height: appcolor.height / 2.3,
            child: ReorderableListView(
              children: [
                for (final item in items)
                  ListTile(
                    key: ValueKey(item),
                    leading: Icon(Icons.drag_indicator_sharp),
                    title: Text(item),
                    trailing: Text(
                      "Drag me",
                      style: TextStyle(
                          color: appcolor.lightblack,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),

                    // style: ListTileStyle.list,
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                  FleetStack.savelocal("navsetting", items.toString());
                  Get.find<home_code>().displaynavigation();
                });
              },
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //New
                          blurRadius: 5.0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "reset_nav".tr,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.construction_sharp,
                            size: 20,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                    )),
                onTap: () {
                  FleetStack.deletelocal("navsetting");
                  Get.snackbar('success'.tr, 'updated_successfully'.tr);
                  Get.find<home_code>().displaynavigation();
                },
              ),
            ],
          ),
          SizedBox(height: 35),
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            decoration: BoxDecoration(
              color: appcolor.idlelight,
              border: Border.all(
                color: appcolor.idle,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Text(
                  "Note:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: appcolor.idle,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  "Tap and Drag the navigation which you want to reorder, kindly restart the application after make the navigation change.",
                  style: TextStyle(fontSize: 15, color: appcolor.black),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
