import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../code/history_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';

class history extends StatelessWidget {
  history({Key? key}) : super(key: key);

  final history_code stack = Get.put(history_code());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: stack.slidecontroller,
        panel: Container(
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      height: 65,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/listicons/${stack.vtype.value}${stack.status.value}.png'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(stack.vnumber.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF757576),
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xff5575b6),
                            ),
                            SizedBox(width: 7),
                            Container(
                              width: appcolor.width / 2.5,
                              child: Text(
                                stack.address.value.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0.0, 5.0),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.directions_car,
                                            size: 20, color: Colors.blueAccent),
                                      ],
                                    ),
                                  )),
                              Text(
                                stack.runningtimestr.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12),
                              ),
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.timeline_rounded,
                                            size: 20, color: Colors.blueAccent),
                                      ],
                                    ),
                                  )),
                              Text(
                                '${stack.totalkm.value.toStringAsFixed(2)} KM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12),
                              ),
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.local_parking,
                                            size: 20, color: Colors.blueAccent),
                                      ],
                                    ),
                                  )),
                              Text(stack.stoptimestr.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 12)),
                            ],
                          )),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  height: 340,
                  child: SingleChildScrollView(
                      child: Column(
                    children: stack.filterlist.value
                        .map(
                          (element) => Column(
                            children: [
                              element["type"] == 2
                                  ? startpoint(
                                      motion: element["motion"],
                                      address: element["address"],
                                      starttime: DateFormat(
                                              appcolor.appdatetime,
                                              stack.currentlanguage.value)
                                          .format(DateTime.parse(
                                              element["device_dt"].toString())),
                                      lat: element["lat"],
                                      lon: element["lon"])
                                  : element["type"] == 3
                                      ? endpoint(
                                          motion: element["motion"],
                                          address: element["address"],
                                          endtime: DateFormat(
                                                  appcolor.appdatetime,
                                                  stack.currentlanguage.value)
                                              .format(DateTime.parse(
                                                  element["device_dt"]
                                                      .toString())),
                                          lat: element["lat"],
                                          lon: element["lon"])
                                      : element["type"] == 0
                                          ? stoppoint(
                                              duration: FleetStack.mintostr(
                                                  element["duration"]),
                                              fromdate: DateFormat(
                                                      appcolor.apptime,
                                                      stack.currentlanguage
                                                          .value)
                                                  .format(DateTime.parse(
                                                      element["fromdate"]
                                                          .toString())),
                                              todate: DateFormat(
                                                      appcolor.apptime,
                                                      stack.currentlanguage
                                                          .value)
                                                  .format(DateTime.parse(
                                                      element["todate"]
                                                          .toString())),
                                              address: element["address"],
                                              lat: element["lat"],
                                              lon: element["lon"],
                                            )
                                          : runningpoint(
                                              duration: FleetStack.mintostr(element["duration"]),
                                              fromdate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["fromdate"].toString())),
                                              todate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["todate"].toString())),
                                              distance: element["distance"],
                                              fromdatetime: element["fromdate"],
                                              todatetime: element["todate"])
                            ],
                          ),
                        )
                        .toList(),
                  )),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Obx(() => FlutterMap(
                            mapController: stack.mapController,
                            options: MapOptions(
                              center: stack.point.value,
                              zoom: 10,
                              interactiveFlags:
                                  InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: stack.tile.value,
                                userAgentPackageName: 'com.example.app',
                              ),

                              //for Geofence
                              stack.isgeofence.value
                                  ? PolygonLayer(
                                      polygons: stack.polygons.value,
                                    )
                                  : Text(""),

                              stack.isgeofence.value
                                  ? PolylineLayer(
                                      polylines: stack.polylines.value,
                                    )
                                  : Text(""),

                              stack.isgeofence.value
                                  ? CircleLayer(
                                      circles: stack.polycircle.value,
                                    )
                                  : Text(""),

                              //for POI

                              stack.ispoi.value
                                  ? CircleLayer(
                                      circles: stack.poipolycircle.value,
                                    )
                                  : Text(""),
                              stack.ispoi.value
                                  ? MarkerLayer(
                                      markers: stack.poimarkers.value,
                                    )
                                  : Text(""),

                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: stack.line.value,
                                    strokeWidth: 2,
                                    color: appcolor.grayblack,
                                    // gradientColors: [
                                    //   const Color(0xffE40203),
                                    //   const Color(0xffFEED00),
                                    //   const Color(0xff007E2D),
                                    // ],
                                  ),
                                ],
                              ),

                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: stack.postline.value,
                                    strokeWidth: 3,
                                    color: appcolor.black,
                                    // gradientColors: [
                                    //   const Color(0xffE40203),
                                    //   const Color(0xffFEED00),
                                    //   const Color(0xff007E2D),
                                    // ],
                                  ),
                                ],
                              ),

                              stack.isstoppage.value == true
                                  ? MarkerLayer(markers: stack.stopage.value)
                                  : Text(''),

                              // My location

                              //Display My current location
                              stack.ismylocation.value == false
                                  ? Text("")
                                  : stack.mymaplocation.value != null
                                      ? MarkerLayer(markers: [
                                          stack.mymaplocation.value!,
                                        ])
                                      : Text(""),
                            ],
                          ))),
                  Positioned(
                      top: 60,
                      left: 18,
                      width: 38,
                      height: 38,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black87,
                          size: 30,
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.height / 10.5,
                      right: 15,
                      child: Column(
                        children: [
                          mapicon(
                              micon: Icon(Icons.filter_list,
                                  size: 21, color: Color(0xff6a6a6a)),
                              icontap: () {
                                return filterSheet(context);
                              }),
                          SizedBox(height: 30),
                          mapicon(
                              micon: Icon(Icons.layers_sharp,
                                  size: 21, color: Color(0xff6a6a6a)),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        color: Colors.white,
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 30),
                                                Text(
                                                  'map_types'.tr,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff535454)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            1.5), // Border width
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              SizedBox.fromSize(
                                                            size: Size.fromRadius(
                                                                30), // Image radius
                                                            child: Image.asset(
                                                                'assets/images/default_map.png',
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        stack.changemap(1);
                                                      },
                                                    ),
                                                    SizedBox(height: 7),
                                                    Text(
                                                      'default'.tr,
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            1.5), // Border width
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              SizedBox.fromSize(
                                                            size: Size.fromRadius(
                                                                30), // Image radius
                                                            child: Image.asset(
                                                                'assets/images/satellite_map.png',
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        print(
                                                            "changing map to the sattelite");
                                                        stack.changemap(2);
                                                      },
                                                    ),
                                                    SizedBox(height: 7),
                                                    Text(
                                                      'satellite'.tr,
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            1.5), // Border width
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              SizedBox.fromSize(
                                                            size: Size.fromRadius(
                                                                30), // Image radius
                                                            child: Image.asset(
                                                                'assets/images/terrain_map.png',
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        stack.changemap(3);
                                                      },
                                                    ),
                                                    SizedBox(height: 7),
                                                    Text(
                                                      'terrain'.tr,
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }),
                          SizedBox(height: 150),
                          mapicon(
                              micon: Icon(Icons.settings,
                                  size: 21, color: Color(0xff6a6a6a)),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Container(
                                          height: appcolor.height / 2.8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(25),
                                          child: Obx(() => Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('map_settings'.tr,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xff535454))),
                                                  SizedBox(height: 15),
                                                  mapsettinglist(
                                                    title: 'poi'.tr,
                                                    type: 'poi',
                                                    status: stack.ispoi.value,
                                                  ),
                                                  mapsettinglist(
                                                    title: 'geofence'.tr,
                                                    type: 'geofence',
                                                    status:
                                                        stack.isgeofence.value,
                                                  ),
                                                  mapsettinglist(
                                                      title: 'stoppage'.tr,
                                                      type: 'stoppage',
                                                      status: stack
                                                          .isstoppage.value),
                                                  mapsettinglist(
                                                    title: 'my_location'.tr,
                                                    type: 'mylocation',
                                                    status: stack
                                                        .ismylocation.value,
                                                  ),
                                                ],
                                              )));
                                    });
                              }),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// on map bottom toggle button list
class mapsettinglist extends StatelessWidget {
  mapsettinglist(
      {Key? key, required this.title, required this.status, required this.type})
      : super(key: key);

  final history_code stack = Get.put(history_code());
  final String title;
  final String type;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              FleetStack.savelocal('is${type}', value.toString());
              // type == "label"?stack.islabel.value = value:
              type == "geofence"
                  ? stack.isgeofence.value = value
                  : type == "poi"
                      ? stack.ispoi.value = value
                      : type == "mylocation"
                          ? stack.ismylocation.value = value
                          : stack.isstoppage.value = value;

              Get.snackbar(title, 'updated_successfully'.tr);
              print(await FleetStack.getlocal('is${type}'));
              //stack.addvehicles();
              //stack.tracking();
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }
}

class startpoint extends StatelessWidget {
  startpoint(
      {Key? key,
      required this.motion,
      required this.address,
      required this.starttime,
      required this.lat,
      required this.lon})
      : super(key: key);
  final history_code stack = Get.put(history_code());
  final bool motion;
  final String address;
  final String starttime;
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              // color: appcolor.stoplight,
              width: appcolor.width / 4.9,
              child: Text(
                "Start Point",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            Container(
              // color: appcolor.white,
              width: appcolor.width / 6,
              child: Center(
                child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: motion ? appcolor.running : appcolor.stop,
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.emoji_transportation,
                            size: 20,
                            color: motion ? appcolor.running : appcolor.stop,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Container(
                // color: appcolor.blue,
                width: appcolor.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(starttime,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xff5575b6),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: appcolor.width / 2.5,
                          child: Text(
                            address,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        onTap: () {
          stack.postline.value = [];
          stack.point.value = LatLng(lat, lon);
          stack.mapController.move(stack.point.value, 18);
          stack.slidecontroller.close();
        },
      ),
    );
  }
}

class stoppoint extends StatelessWidget {
  stoppoint(
      {Key? key,
      required this.duration,
      required this.fromdate,
      required this.todate,
      required this.address,
      required this.lat,
      required this.lon})
      : super(key: key);
  final history_code stack = Get.put(history_code());

  final String duration;
  final String fromdate;
  final String todate;
  final String address;
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.stoplight,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              width: appcolor.width / 4.9,
              child: Text(
                duration,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            Container(
              width: appcolor.width / 6,
              child: Center(
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        // border: Border.all(
                        //   color: appcolor.stop,
                        //   style: BorderStyle.solid,
                        //   width: 1.0,
                        // ),
                      ),
                      child: Image.asset(
                        'assets/images/stop-point.png',
                        width: 30,
                        height: 30,
                      )
                      // Padding(
                      //   padding: const EdgeInsets.all(2.0),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Icon(Icons.local_parking, size: 20, color: appcolor.stop,),
                      //     ],
                      //   ),
                      // ),
                      )),
            ),
            Container(
                width: appcolor.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${fromdate.toString()} to ${todate.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xff5575b6),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: appcolor.width / 2.5,
                          child: Text(
                            address,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        onTap: () {
          stack.postline.value = [];
          stack.point.value = LatLng(lat, lon);
          stack.mapController.move(stack.point.value, 18);
          stack.slidecontroller.close();
        },
      ),
    );
  }
}

class runningpoint extends StatelessWidget {
  runningpoint(
      {Key? key,
      required this.duration,
      required this.fromdate,
      required this.todate,
      required this.distance,
      required this.fromdatetime,
      required this.todatetime})
      : super(key: key);
  final history_code stack = Get.put(history_code());
  final String duration;
  final String fromdate;
  final String todate;
  final double distance;
  final DateTime fromdatetime;
  final DateTime todatetime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.runninglight,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              width: appcolor.width / 4.9,
              child: Text(
                duration,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            Container(
              width: appcolor.width / 6,
              child: Center(
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: appcolor.running,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.directions_car_filled,
                              size: 20,
                              color: appcolor.running,
                            ),
                          ],
                        ),
                      ))),
            ),
            Container(
                width: appcolor.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${fromdate.toString()} to ${todate.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.timeline, color: Colors.green),
                        SizedBox(width: 5),
                        Text(distance.toString()),
                        SizedBox(width: 25),
                        // Icon(Icons.directions_run, color: Colors.green),
                        // SizedBox(width: 5),
                        // Text('56 KM/HR'),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        onTap: () {
          stack.drawoutline(fromdatetime, todatetime);
        },
      ),
    );
  }
}

class endpoint extends StatelessWidget {
  endpoint(
      {Key? key,
      required this.motion,
      required this.address,
      required this.endtime,
      required this.lat,
      required this.lon})
      : super(key: key);
  final history_code stack = Get.put(history_code());
  final bool motion;
  final String address;
  final String endtime;
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              // color: appcolor.stoplight,
              width: appcolor.width / 4.9,
              child: Text(
                "End Point",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            Container(
              // color: appcolor.white,
              width: appcolor.width / 6,
              child: Center(
                child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: motion ? appcolor.running : appcolor.stop,
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.emoji_transportation,
                            size: 20,
                            color: motion ? appcolor.running : appcolor.stop,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Container(
                // color: appcolor.blue,
                width: appcolor.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(endtime.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xff5575b6),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: appcolor.width / 2.5,
                          child: Text(
                            address,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        onTap: () {
          stack.postline.value = [];
          stack.point.value = LatLng(lat, lon);
          stack.mapController.move(stack.point.value, 18);
          stack.slidecontroller.close();
        },
      ),
    );
  }
}

filterSheet(BuildContext context) {
  final history_code stack = Get.put(history_code());
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      stack.customdropdown(
                        currentvalue: stack.selectedvehicle.value,
                        list: stack.vehiclelist.value,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Text('From Date',
                      style: TextStyle(
                        fontSize: 21,
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: appcolor.white,
                              border: Border.all(
                                color: appcolor.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            // child: Center(child: Text(stack.fromdtselection.value.toString() ,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                  DateFormat(appcolor.appdatetime)
                                      .format(stack.fromdtselection.value)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: appcolor.grayblack),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            var selecteddate = await FleetStack.pickdatetime(
                                currentdatetime: stack.fromdtselection.value);
                            stack.fromdtselection.value = selecteddate!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text('To Date',
                      style: TextStyle(
                        fontSize: 21,
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: appcolor.white,
                              border: Border.all(
                                color: appcolor.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            // child: Center(child: Text(stack.fromdtselection.value.toString() ,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                  DateFormat(appcolor.appdatetime)
                                      .format(stack.todtselection.value)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: appcolor.grayblack),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            var selecteddate = await FleetStack.pickdatetime(
                                currentdatetime: stack.todtselection.value);
                            stack.todtselection.value = selecteddate!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: appcolor.blue,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    stack.isloading.value
                                        ? "loading...".tr
                                        : "show_result".tr,
                                    style: TextStyle(
                                        color: appcolor.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  stack.isloading.value
                                      ? CircularProgressIndicator(
                                          color: appcolor.white,
                                        )
                                      : Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                          color: appcolor.white,
                                        ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    onTap: stack.isloading.value ? () {} : stack.showresult,
                  ),
                ],
              ),
            ));
      });
}
