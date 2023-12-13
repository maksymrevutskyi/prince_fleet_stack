import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../code/list_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';
import 'livetracking.dart';

class list extends StatefulWidget {
  list({Key? key}) : super(key: key);

  @override
  State<list> createState() => _listState();
}

class _listState extends State<list> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list_code.to.vehilcelist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: list_code.to.onRefreshPage,
      child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              TextField(
                controller: list_code.to.searchController,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5b73e8)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: "search".tr,
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    // color: appStore.iconColor,
                    size: 25,
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        // color: appStore.iconColor,
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '');
                        print('refresh the file');
                        list_code.to.loadrunning('');
                      }),
                ),
                onChanged: (text) {
                  // Perform search action
                  list_code.to.vsearch(text);
                },
                textInputAction: TextInputAction.done,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 15, 8, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Obx(() =>
                              Text('All ( ${list_code.to.total.toString()} )',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  )))),
                      onTap: () {
                        list_code.to.vehilcelist();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.green, width: 1)),
                        child: Obx(() => Text(
                            'Running ( ${list_code.to.running.toString()} )',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ))),
                      ),
                      onTap: () {
                        list_code.to.loadrunning('Running');
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.red, width: 1)),
                          child: Obx(() =>
                              Text('Stop ( ${list_code.to.stop.toString()} )',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  )))),
                      onTap: () {
                        list_code.to.loadrunning('Stop');
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(0xfff6eccb),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: Color(0xffcd9f00), width: 1)),
                          child: Obx(() =>
                              Text('Idle (${list_code.to.idle.toString()})',
                                  style: TextStyle(
                                    color: Color(0xffcd9f00),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  )))),
                      onTap: () {
                        list_code.to.loadrunning('Ideal');
                      },
                    ),
                  ],
                ),
              ),

              // Obx(() {
              //   return Column(
              //     children: list_code.to.vehicles.map((element) =>
              //     Container(
              //       child: Text(element["vehicleno"]),
              //     ),
              //     ).toList(),
              //   );
              // }),

              //pass int deviceid

              Obx(() {
                return Column(
                  children: list_code.to.vehicles
                      .map((element) => bindvehicle(
                            status: element["status"],
                            vehicleno: element["vehicleno"],
                            speed: element["speed"],
                            statetime: element["lastmin"],
                            ignition: element["ign"],
                            drivenkm: element["driventoday"],
                            address: element["address"],
                            latitude: element["lastlatitude"],
                            longitude: element["lastlongitude"],
                            deviceid: element["deviceid"],
                            vehicletype: element["vehicletype"],
                            drivermobile: element["drivermob"] ?? "",
                            odometer: (element["meter"].runtimeType == double)
                                ? (element["meter"] / 1000)
                                : 0.0,
                          ))
                      .toList(),
                );
              }),

              SizedBox(height: 25),
            ],
          )),
    ));
  }
}

// class displayvehiclelist extends StatelessWidget {
//   const displayvehiclelist(
//       {Key? key,
//       required this.status,
//       required this.vehicleno,
//       required this.speed,
//       this.statetime,
//       this.ignition,
//       this.drivenkm,
//       required this.address,
//       this.latitude,
//       this.longitude,
//       required this.deviceid,
//       required this.vehicletype,
//       required this.odometer,
//       required this.drivermobile})
//       : super(key: key);

//   final String status;
//   final String vehicleno;
//   final double speed;
//   final int? statetime;
//   final bool? ignition;
//   final double? drivenkm;
//   final String address;
//   final double? latitude;
//   final double? longitude;
//   final int deviceid;
//   final String vehicletype;
//   final double odometer;
//   final String drivermobile;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 65,
//                     child: Stack(
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomLeft,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     // image:speed>0? AssetImage('assets/images/listicons/ambulanceRunning.png'):
//                                     // AssetImage('assets/images/vehicle-stop.png'),

//                                     image: AssetImage(
//                                         'assets/images/listicons/${vehicletype}${status}.png'))),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: Container(
//                             width: 38,
//                             height: 38,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: status == "Stop"
//                                     ? appcolor.stoplight
//                                     : status == "Running"
//                                         ? Color(0Xff8db392)
//                                         : Color(0Xfff1b827),
//                                 border: Border.all(
//                                     color: status == "Stop"
//                                         ? Colors.red
//                                         : status == "Running"
//                                             ? Colors.green
//                                             : Color(0Xffa37c1a),
//                                     width: 1.5)),
//                             child: Center(
//                                 child: Text(
//                               '${speed.toString()} \n km/hr',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: speed > 0
//                                     ? appcolor.running
//                                     : appcolor.stop,
//                                 fontSize: 7,
//                               ),
//                             )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                           color: Color(0Xffededed),
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           border: Border.all(
//                               color: status == "Stop"
//                                   ? Colors.red
//                                   : status == "Running"
//                                       ? Colors.green
//                                       : Color(0Xffa37c1a),
//                               width: 1)),
//                       child: Text(FleetStack.mintostr(statetime),
//                           style: TextStyle(
//                             color: status == "Stop"
//                                 ? Colors.red
//                                 : status == "Running"
//                                     ? Colors.green
//                                     : Color(0Xffa37c1a),
//                             fontSize: 9,
//                             fontWeight: FontWeight.w500,
//                           ))),
//                 ],
//               ),
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(vehicleno,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF757576),
//                           )),
//                       SizedBox(width: 12),
//                       Container(
//                           padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
//                           decoration: BoxDecoration(
//                               color: ignition == true
//                                   ? Colors.green[100]
//                                   : Colors.red[100],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                               border: Border.all(
//                                   color: ignition == true
//                                       ? Color(0Xff96de86)
//                                       : Colors.red,
//                                   width: 1.5)),
//                           child: Icon(
//                             Icons.key,
//                             size: 15,
//                             color: ignition == true ? Colors.green : Colors.red,
//                           )),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         "odometer".tr,
//                         style: TextStyle(
//                           fontSize: 9,
//                         ),
//                       ),
//                       SizedBox(width: 5),
//                       Icon(Icons.airline_seat_recline_extra,
//                           size: 18, color: appcolor.blue),
//                       SizedBox(width: 3),
//                       Text(
//                         '${odometer.toStringAsFixed(2)} KM',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                             fontSize: 9),
//                       ),
//                       // SizedBox(width: 8),
//                       // Icon(Icons.access_time_sharp,
//                       //     size: 15,
//                       //     color: Colors.blueAccent
//                       // ),
//                       // SizedBox(width: 4),
//                       // Text('2 h 36 Min.',
//                       //   style: TextStyle(
//                       //       fontWeight: FontWeight.bold,
//                       //       color: Colors.black,
//                       //       fontSize: 12
//                       //   ),),
//                       SizedBox(width: 10),
//                       Text(
//                         "driven_today".tr,
//                         style: TextStyle(fontSize: 9),
//                       ),
//                       SizedBox(width: 5),
//                       Icon(Icons.timeline_rounded,
//                           size: 18, color: Colors.blueAccent),
//                       SizedBox(width: 4),
//                       Text('${drivenkm} km',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                               fontSize: 9)),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: Color(0xff5575b6),
//                       ),
//                       SizedBox(width: 7),
//                       Container(
//                         width: 230,
//                         child: Text(
//                           address,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
