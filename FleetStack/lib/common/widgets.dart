import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../code/map_code.dart';
import '../ui/addpoint.dart';
import '../ui/replay.dart';
import '../ui/vehiclesetting.dart';
import 'FleetStack.dart';
import '../ui/livetracking.dart';
import '../ui/history.dart';

class appcolor {
  static var white = Color(0xffffffff);
  static var gray = Color(0xFFecedee);
  static var lightblack = Color(0xFF2e2e2f);
  static var grayblack = Colors.black54;
  static var black = Color(0xFF000000);
  static var running = Color(0xff1f9404);
  static var stop = Color(0xffd21e06);
  static var idle = Color(0xffcd9f00);
  static var idlelight = Color(0xfff6eccb);
  static var runninglight = Color(0xffebffeb);
  // static var runninglight = Colors.green[100];
  // static var stoplight = Colors.red[100];
  static var stoplight = Color(0xffffe4e4);

  static var blue = Colors.blueAccent;
  static var bluelight = Color(0xff85bcff);

  static var runningripple = Color(0xff3a7b3a).withOpacity(0.3);
  static var stopripple = Color(0xfff17070).withOpacity(0.3);
  static var idleripple = Color(0xffb5a83b).withOpacity(0.3);

  static var preline = Colors.green.withOpacity(0.3);
  static var trackline = Color(0xff057d27);

  static var height = MediaQuery.of(Get.context!).size.height;
  static var width = MediaQuery.of(Get.context!).size.width;

  static var dbdatetimerequest = 'yyyy-MM-dd hh:mm';

  static var appdate = "dd MMM yyyy";
  static var applongdate = "dd MMMM yyyy";
  static var appdatetime = "dd MMM yyyy hh:mm a";
  static var appdatetimesecond = "dd MMM yyyy hh:mm:ss a";
  static var apptime = "hh:mm a";
  static var apptimesecond = "hh:mm a";
  static var appinputdate = 'yyyy-MM-dd';
  static var appinputdatetime = 'yyyy-MM-dd hh:mm:ss';

  static var historydate = 'dd MMMM';
}

class bindvehicle extends StatelessWidget {
  const bindvehicle({
    Key? key,
    required this.vehicleno,
    required this.speed,
    this.statetime,
    this.ignition,
    this.drivenkm,
    required this.address,
    this.latitude,
    this.longitude,
    required this.status,
    required this.deviceid,
    required this.vehicletype,
    required this.odometer,
    required this.drivermobile,
  }) : super(key: key);
  final String status;
  final String vehicleno;
  final double speed;
  final int? statetime;
  final bool? ignition;
  final double? drivenkm;
  final String address;
  final double? latitude;
  final double? longitude;
  final int deviceid;
  final String vehicletype;
  final double odometer;
  final String drivermobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        child: Material(
            child: InkWell(
          onTap: () {
            Get.to(() => livetracking(
                deviceid:
                    '${deviceid},${latitude},${longitude},${vehicletype},${status}'));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: [Color(0xFFf6f9ff), Color(0xFFf6f9ff)]),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, //New
                  blurRadius: 25.0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  // showModalBottomSheet(
                  //     context: context,
                  //     backgroundColor: Color(0xFFc1c2c3),
                  //     isScrollControlled: true,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.vertical(top: Radius.circular(25.0)),
                  //     ),
                  //     // clipBehavior: Clip.hardEdge,
                  //     builder: (context) {
                  //       return Container(
                  //         height: MediaQuery.of(context).size.height / 4.5,
                  //         padding: EdgeInsets.only(top: 15, bottom: 15),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceEvenly,
                  //               children: [
                  //                 btmnav(
                  //                     navicon: Icon(Icons.location_pin,
                  //                         size: 32, color: Color(0xff606060)),
                  //                     title: 'live_tracking'.tr,
                  //                     tap: () {
                  //                       Get.to(() => livetracking(
                  //                           deviceid: '${deviceid}'));
                  //                     }),
                  //                 btmnav(
                  //                     navicon: Icon(Icons.manage_search,
                  //                         size: 32, color: Color(0xff606060)),
                  //                     title: 'view_history'.tr,
                  //                     tap: () {
                  //                       Get.to(history());
                  //                     }),
                  //                 btmnav(
                  //                     navicon: Icon(Icons.add_location_alt,
                  //                         size: 32, color: Color(0xff606060)),
                  //                     title: 'add_location'.tr,
                  //                     tap: () {
                  //                       Get.to(addpoint());
                  //                     }),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     });
                  Row(
                    children: [
                      Column(
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
                                            // image:speed>0? AssetImage('assets/images/listicons/ambulanceRunning.png'):
                                            // AssetImage('assets/images/vehicle-stop.png'),

                                            image: AssetImage(
                                                'assets/images/listicons/$vehicletype${status == 'carIdeal' ? 'carStop' : status}.png'))),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: status == "Stop"
                                            ? appcolor.stoplight
                                            : status == "Running"
                                                ? appcolor.runninglight
                                                : appcolor.idlelight,
                                        border: Border.all(
                                            color: status == "Stop"
                                                ? appcolor.stop
                                                : status == "Running"
                                                    ? appcolor.running
                                                    : appcolor.idle,
                                            width: 1.5)),
                                    child: Center(
                                        child: Text(
                                      '${speed.toString()} \n km/hr',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: status == "Stop"
                                            ? appcolor.stop
                                            :  status == "Running"
                                            ? appcolor.running
                                            : appcolor.idle,
                                        fontSize: 7,
                                      ),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0Xffededed),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: status == "Stop"
                                          ? appcolor.stop
                                          : status == "Running"
                                              ? appcolor.running
                                              : appcolor.idle,
                                      width: 1)),
                              child: Text(FleetStack.mintostr(statetime),
                                  style: TextStyle(
                                    color: status == "Stop"
                                        ? appcolor.stop
                                        : status == "Running"
                                            ? appcolor.running
                                            : appcolor.idle,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ))),
                        ],
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(vehicleno,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF757576),
                                  )),
                              SizedBox(width: 12),
                              Container(
                                  padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
                                  decoration: BoxDecoration(
                                      color: ignition == true
                                          ? Colors.green[100]
                                          : Colors.red[100],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: ignition == true
                                              ? Color(0Xff96de86)
                                              : Colors.red,
                                          width: 1.5)),
                                  child: Icon(
                                    Icons.key,
                                    size: 15,
                                    color: ignition == true
                                        ? Colors.green
                                        : Colors.red,
                                  )),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "odometer".tr,
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.airline_seat_recline_extra,
                                  size: 18, color: appcolor.blue),
                              SizedBox(width: 3),
                              Text(
                                '${odometer.toStringAsFixed(2)} KM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 9),
                              ),
                              // SizedBox(width: 8),
                              // Icon(Icons.access_time_sharp,
                              //     size: 15,
                              //     color: Colors.blueAccent
                              // ),
                              // SizedBox(width: 4),
                              // Text('2 h 36 Min.',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.black,
                              //       fontSize: 12
                              //   ),),
                              SizedBox(width: 10),
                              Text(
                                "driven_today".tr,
                                style: TextStyle(fontSize: 9),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.timeline_rounded,
                                  size: 18, color: Colors.blueAccent),
                              SizedBox(width: 4),
                              Text('${drivenkm} km',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 9)),
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
                                width: 230,
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
                      )
                    ],
                  ),

                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 8),
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Color(0xFFd5dbe8),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (drivermobile != "") {
                            launch("tel://${drivermobile}");
                          } else {
                            Get.snackbar(
                                'driver'.tr, 'number_mobile_not_available'.tr);
                          }
                        },
                        child: Icon(Icons.call,
                            size: 24, color: Colors.blueAccent),
                      ),

                      GestureDetector(
                        onTap: () {
                          // Get.to(replay());
                          Get.to(
                            replay(
                                deviceid:
                                    '${deviceid},${latitude},${longitude},${status},${vehicletype}'),
                          );
                        },
                        child: Icon(Icons.play_circle_outline,
                            size: 24, color: Colors.blueAccent),
                      ),

                      GestureDetector(
                        child: Icon(Icons.assistant_direction,
                            size: 24, color: Colors.blueAccent),
                        onTap: () {
                          showModalBottomSheet(
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
                                        MediaQuery.of(context).size.height / 5,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'navigate_to_the_vehicle_location'
                                                .tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff535454))),
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  Color.fromRGBO(
                                                      255, 255, 255, .6),
                                                ]),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey, //New
                                                    blurRadius: 25.0,
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: 30.0,
                                                    ),
                                                    Text(
                                                      "Continue".tr,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 30.0,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          onTap: () async {
                                            await launch(
                                                'https://www.google.com/maps/dir/?api=1&origin=Current+Location&destination=${latitude},${longitude}');
                                          },
                                        ),
                                      ],
                                    ));
                              });
                        },
                      ),

                      // Icon(Icons.timeline,
                      //     size: 24,
                      //     color: Colors.blueAccent),

                      // GestureDetector(
                      //   child: Icon(Icons.settings,
                      //       size: 24, color: Colors.blueAccent),
                      //   onTap: () {
                      //     Get.to(vehiclesetting());
                      //   },
                      // ),

                      GestureDetector(
                        child: Icon(Icons.share,
                            size: 24, color: Colors.blueAccent),
                        onTap: () {
                          Share.share(
                              'checkout the live location for ${vehicleno} using the given below link :  https:\/\/www.google.com\/maps\/search\/?api=1&query=${latitude},${longitude}',
                              subject: 'Live Location- ${vehicleno}');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )));
  }
}

//Profile page custom size shape

class customshape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

// profile page list menu

class drawmenu extends StatelessWidget {
  const drawmenu(
      {Key? key,
      required this.title,
      required this.iconsrc,
      required this.icontap})
      : super(key: key);
  final String title;
  final Icon iconsrc;
  final Function() icontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: icontap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        child: Row(
          children: [
            iconsrc,
            SizedBox(
              width: 25,
            ),
            Text(title),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}

// notification list container

class bindnotify extends StatelessWidget {
  const bindnotify(
      {Key? key, required this.vehicle, required this.dt, required this.msg})
      : super(key: key);
  final String vehicle, dt, msg;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient:
              LinearGradient(colors: [Color(0xFFf6f9ff), Color(0xFFf6f9ff)]),
          boxShadow: [
            BoxShadow(
              color: Colors.grey, //New
              blurRadius: 25.0,
            )
          ],
        ),
        child: Padding(
          // padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(Icons.notifications_active),
                    ],
                  )),
              Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vehicle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF175ff0),
                            ),
                          ),
                          Text(
                            dt,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              width: appcolor.width / 1.3,
                              child: Text(
                                msg,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF868686),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// Icon on map
class mapicon extends StatelessWidget {
  const mapicon({Key? key, required this.micon, required this.icontap})
      : super(key: key);

  final Icon micon;
  final Function() icontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: icontap,
      child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Color(0xfff8f8f8),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey, //New
                blurRadius: 5.0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [micon],
            ),
          )),
    );
  }
}

// on map bottom toggle button list
class bottomcheckitem extends StatelessWidget {
  bottomcheckitem(
      {Key? key,
      required this.title,
      required this.status,
      required this.toggletap})
      : super(key: key);

  final map_code map_code_file = Get.put(map_code());
  final String title;
  final bool status;
  final Function() toggletap;
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
              FleetStack.savelocal(title, value.toString());
              map_code_file.islabel.value = value;
              Get.snackbar('updated', 'updated Success');
              print(await FleetStack.getlocal(title));
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }
}

class simplenav extends StatelessWidget {
  const simplenav({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('clicked');
      },
      child: Column(
        children: [
          Row(
            children: [Text(title), Spacer(), Icon(Icons.arrow_forward)],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xffdddee0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// vehicleinfo on livetracking page
class vinfo extends StatelessWidget {
  const vinfo(
      {Key? key,
      required this.title,
      required this.infoicon,
      required this.subtitle,
      required this.infovalue})
      : super(key: key);

  final Icon infoicon;
  final String title;
  final String subtitle;
  final String infovalue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            infoicon,
            // Icon(Icons.directions_car_filled,
            //   size: 35,
            //   color: Color(0xff2e2e2f),
            // ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Color(0xFF757576)),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            Spacer(),
            Text(infovalue,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 12),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 60, right: 15, top: 10, bottom: 10),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              color: Color(0xffdddee0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class btmnav extends StatelessWidget {
  const btmnav(
      {Key? key, required this.title, required this.navicon, required this.tap})
      : super(key: key);
  final String title;
  final Icon navicon;
  final Function() tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 20.0,
              offset: Offset(0, 10))
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: tap,
        child: Column(
          children: [
            navicon,
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

// navigation on utility/other page
class nav extends StatelessWidget {
  const nav(
      {Key? key,
      required this.title,
      required this.des,
      required this.iconsrc,
      required this.navtap})
      : super(key: key);
  final Icon iconsrc;
  final String title, des;
  final Function() navtap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navtap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconsrc
                // size: 35,
                // color: Color(0xff2e2e2f),
                ,
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                    Text(
                      des,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757576),
                          overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios,
                    size: 25, color: Color(0xff2e2e2f)),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 60, right: 25, top: 20, bottom: 20),
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xffdddee0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class venable extends StatelessWidget {
  const venable(
      {Key? key,
      required this.vicon,
      required this.vnumber,
      required this.vaddress})
      : super(key: key);

  final Icon vicon;
  final String vnumber;
  final String vaddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            vicon,
            // Icon(Icons.directions_car_filled,
            //   size: 35,
            //   color: Color(0xff2e2e2f),
            // ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vnumber,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width / 1.85,
                  child: Flexible(
                      child: Text(vaddress,
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF757576)))),
                ),
              ],
            ),
            Spacer(),

            Container(
              height: 40,
              width: 90,
              child: Switch(
                value: true,
                onChanged: (value) {},
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            )
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 60, right: 15, top: 10, bottom: 10),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              color: Color(0xffdddee0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class poilist extends StatelessWidget {
  const poilist(
      {Key? key,
      required this.name,
      required this.address,
      required this.picon})
      : super(key: key);

  final String name;
  final String address;
  final Icon picon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            picon,
            // Icon(Icons.directions_car_filled,
            //   size: 35,
            //   color: Color(0xff2e2e2f),
            // ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width / 1.85,
                  child: Flexible(
                      child: Text(address,
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF757576)))),
                ),
              ],
            ),
            Spacer(),

            Container(
                height: 40,
                width: 90,
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye),
                    SizedBox(width: 10),
                    Icon(Icons.delete),
                  ],
                )),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 60, right: 15, top: 10, bottom: 10),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              color: Color(0xffdddee0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ),
      ],
    );
  }
}
