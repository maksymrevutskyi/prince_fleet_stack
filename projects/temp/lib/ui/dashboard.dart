import '/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;
import '../code/dashboard_code.dart';
import '../code/list_code.dart';
import 'notifications.dart';
import 'profile.dart';

class dashboard extends StatefulWidget {
  dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final dashboard_code stack = Get.put(dashboard_code());

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   stack.tm.cancel();
  //   stack.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: stack.onRefreshPage,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 15.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 216,
                    height: 53,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(width: 10.0),
                  // IconButton(onPressed: () {
                  //   showSearch(context: context, delegate: searchdata());
                  // }, icon: Icon(Icons.search)),

                  GestureDetector(
                    onTap: () {
                      Get.to(notifications());
                    },
                    child: Container(
                      width: 42,
                      height: 50,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.notifications_active,
                              size: 28,
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Container(
                          //     width: 26,
                          //     height: 26,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle, color: Colors.blueAccent,
                          //     ),
                          //     child: Center(child: Text('24',
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 10,
                          //       ),)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.to(profile())?.then((value) {});
                      // Navigator.pushNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      foregroundColor: Colors.blueAccent,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 4, bottom: 8, top: 16),
                            child: Text(
                              'running_all'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  //fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: Colors.black87),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 4, bottom: 3),
                                    child: Obx(
                                      () => Text(
                                        '${stack.driven.value}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),

                                    // Text(
                                    //   '206.8',
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //    // fontFamily: FitnessAppTheme.fontName,
                                    //     fontWeight: FontWeight.w600,
                                    //     fontSize: 32,
                                    //     color: Colors.blue,
                                    //   ),
                                    // ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 8),
                                    child: Text(
                                      'km'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey.withOpacity(0.5),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Obx(
                                          () => Text(
                                            '${stack.currenttime.value}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                        ),

                                        // Text(
                                        //   'Today 8:26 AM',
                                        //   textAlign: TextAlign.center,
                                        //   style: TextStyle(
                                        //    // fontFamily:
                                        //    // FitnessAppTheme.fontName,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontSize: 14,
                                        //     letterSpacing: 0.0,
                                        //     color: Colors.grey
                                        //         .withOpacity(0.5),
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 4, bottom: 14),
                                    child: Text(
                                      'ai_smartscale'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 24, right: 24, top: 8, bottom: 8),
                    //   child: Container(
                    //     height: 2,
                    //     decoration: const BoxDecoration(
                    //       color: Color(0xFFf0f0f0),
                    //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 24, right: 24, top: 8, bottom: 16),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: <Widget>[
                    //             Obx(
                    //               () => Text(
                    //                 '${stack.lastweekkm.value}',
                    //                 textAlign: TextAlign.center,
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 16,
                    //                   letterSpacing: -0.2,
                    //                   color: Colors.black87,
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //             // const Text(
                    //             //   '1524 KM',
                    //             //   textAlign: TextAlign.center,
                    //             //   style: TextStyle(
                    //             //    // fontFamily: FitnessAppTheme.fontName,
                    //             //     fontWeight: FontWeight.w500,
                    //             //     fontSize: 16,
                    //             //     letterSpacing: -0.2,
                    //             //     color: Colors.black87,
                    //             //   ),
                    //             // ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 6),
                    //               child: Text(
                    //                 'last_week'.tr,
                    //                 textAlign: TextAlign.center,
                    //                 style: TextStyle(
                    //                   // fontFamily: FitnessAppTheme.fontName,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 12,
                    //                   color: Colors.grey.withOpacity(0.5),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Obx(
                    //                   () => Text(
                    //                     '${stack.growth.value} %',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 16,
                    //                       letterSpacing: -0.2,
                    //                       color: stack.growth.value > 0
                    //                           ? Colors.green
                    //                           : Colors.red,
                    //                     ),
                    //                   ),
                    //                 ),
                    //
                    //                 // const Text(
                    //                 //   '-15 %',
                    //                 //   textAlign: TextAlign.center,
                    //                 //   style: TextStyle(
                    //                 //    // fontFamily: FitnessAppTheme.fontName,
                    //                 //     fontWeight: FontWeight.w500,
                    //                 //     fontSize: 16,
                    //                 //     letterSpacing: -0.2,
                    //                 //     color: Colors.red,
                    //                 //   ),
                    //                 // ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 6),
                    //                   child: Text(
                    //                     'growth'.tr,
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       // fontFamily: FitnessAppTheme.fontName,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color: Colors.grey.withOpacity(0.5),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: <Widget>[
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.end,
                    //               children: <Widget>[
                    //                 Obx(
                    //                   () => Text(
                    //                     '${stack.utility.value} %',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 16,
                    //                       letterSpacing: -0.2,
                    //                       color: stack.utility.value > 0
                    //                           ? Colors.green
                    //                           : Colors.redAccent,
                    //                     ),
                    //                   ),
                    //                 ),
                    //
                    //                 // const Text(
                    //                 //   '65%',
                    //                 //   style: TextStyle(
                    //                 //    // fontFamily: FitnessAppTheme.fontName,
                    //                 //     fontWeight: FontWeight.w500,
                    //                 //     fontSize: 16,
                    //                 //     letterSpacing: -0.2,
                    //                 //     color: Colors.black87,
                    //                 //   ),
                    //                 // ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 6),
                    //                   child: Text(
                    //                     'fleet_utilization'.tr,
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       // fontFamily: FitnessAppTheme.fontName,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color: Colors.grey.withOpacity(0.5),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 10, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 75,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => selectedindex.value = 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 2),
                                                  child: Text(
                                                    'all_vehicles'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      //fontFamily:
                                                      //FitnessAppTheme.fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      letterSpacing: -0.1,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 55,
                                                      height: 55,
                                                      child: Image.asset(
                                                          'assets/images/vehicle-all.png'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              bottom: 15),
                                                      child: Obx(
                                                        () => Text(
                                                          '${stack.total.value}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),

                                                      // Text(
                                                      //   '15',
                                                      //   textAlign: TextAlign.center,
                                                      //   style: const TextStyle(
                                                      //     //fontFamily:
                                                      //     // FitnessAppTheme
                                                      //     //    .fontName,
                                                      //     fontWeight:
                                                      //     FontWeight.w600,
                                                      //     fontSize: 16,
                                                      //     color: Colors.blue,
                                                      //   ),
                                                      // ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              bottom: 15),
                                                      child: Text(
                                                        'units'.tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          // fontFamily:
                                                          // FitnessAppTheme
                                                          //     .fontName,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          letterSpacing: -0.2,
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 75,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF56E98)
                                              .withOpacity(0.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          selectedindex.value = 2;
                                          Get.find<list_code>()
                                              .loadrunning('Stop');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 2),
                                                child: Text(
                                                  'stop_vehicles'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    // fontFamily:
                                                    // FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: Colors.red
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 55,
                                                    height: 55,
                                                    child: Image.asset(
                                                        'assets/images/vehicle-stop.png'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6,
                                                            bottom: 15),
                                                    child: Obx(
                                                      () => Text(
                                                        '${stack.stop.value}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   '10',
                                                    //   textAlign: TextAlign.center,
                                                    //   style: const TextStyle(
                                                    //     // fontFamily:
                                                    //     // FitnessAppTheme
                                                    //     //     .fontName,
                                                    //     fontWeight:
                                                    //     FontWeight.w600,
                                                    //     fontSize: 16,
                                                    //     color: Colors.blue,
                                                    //   ),
                                                    // ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            bottom: 15),
                                                    child: Text(
                                                      'units'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // fontFamily:
                                                        // FitnessAppTheme
                                                        //     .fontName,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        letterSpacing: -0.2,
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectedindex.value = 2;
                              Get.find<list_code>().loadrunning('Running');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.antiAlias,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(130.0),
                                          ),
                                          border: Border.all(
                                              width: 4,
                                              color: Colors.green
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Obx(
                                              () => Text(
                                                '${stack.running.value}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 30,
                                                  letterSpacing: 0.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   '5',
                                            //   textAlign: TextAlign.center,
                                            //   style: const TextStyle(
                                            //     // fontFamily:
                                            //     // FitnessAppTheme.fontName,
                                            //     fontWeight: FontWeight.normal,
                                            //     fontSize: 30,
                                            //     letterSpacing: 0.0,
                                            //     color: Colors.green,
                                            //   ),
                                            // ),
                                            Text(
                                              'running'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                // fontFamily:
                                                // FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CustomPaint(
                                        painter: CurvePainter(colors: <Color>[
                                          const Color(0xFF017401),
                                          const Color(0xFF0a5f0a)
                                        ], angle: 210),
                                        child: const SizedBox(
                                          width: 135,
                                          height: 135,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFFf0f0f0),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'eco_driving'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: -0.2,
                                    color: Colors.black87,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    height: 4,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF87A0E5)
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          //width: (70 / 1.2) * animation.value,
                                          width: 45,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            gradient:
                                                LinearGradient(colors: <Color>[
                                              const Color(0xFF87A0E5),
                                              const Color(0xFF87A0E5)
                                                  .withOpacity(0.5),
                                            ]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'good'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'driver_behavior'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: -0.2,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        height: 4,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF56E98)
                                              .withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              // width: (70 / 2) *
                                              // animationController.value,
                                              width: 45,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: <Color>[
                                                      const Color(0xFFF56E98)
                                                          .withOpacity(0.1),
                                                      const Color(0xFFF56E98),
                                                    ]),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4.0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'excellent'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'vehicle_health'.tr,
                                      style: TextStyle(
                                        // fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: -0.2,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        height: 4,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1B440)
                                              .withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              // width: (70 / 2.5) *
                                              // animationController.value,
                                              width: 45,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: <Color>[
                                                      const Color(0xFFF1B440)
                                                          .withOpacity(0.1),
                                                      const Color(0xFFF1B440),
                                                    ]),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4.0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'warning'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: 24, right: 24, top: 25, bottom: 25),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: double.infinity,
                    child: Obx(() => SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title:
                              ChartTitle(text: 'Weekly data run by car in kms'),
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              labelFormat: '{value}',
                              majorTickLines: const MajorTickLines(size: 0)),
                          series: <ColumnSeries<ChartSampleData, String>>[
                            ColumnSeries<ChartSampleData, String>(
                              dataSource: stack.graphDataDisplay.value,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x as String,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.y,
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 10)),
                            )
                          ],
                          tooltipBehavior: TooltipBehavior(
                              enable: true, header: '', canShowMarker: false),
                        )))),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            child: SizedBox(
                              height: 74,
                              child: AspectRatio(
                                aspectRatio: 1.714,
                                child: Image.asset('assets/images/back.png'),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 120,
                                      right: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      "you_are_doing".tr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        // fontFamily:
                                        // FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 120,
                                  bottom: 12,
                                  top: 4,
                                  right: 16,
                                ),
                                child: Text(
                                  'keep_it_up'.tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    // fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    letterSpacing: 0.0,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    left: 0,
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.asset('assets/images/infoman.png'),
                    ),
                  )
                ],
              ),
            ),

            Obx(() {
              return             (stack.is_announcement.value == true)?
              Container(
                  margin: const EdgeInsets.only(
                      left: 24, right: 24, top: 25, bottom: 25),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(

                    children: [
                      SizedBox(
                        // height: MediaQuery.of(context).size.height / 2.5,
                        width: double.infinity,
                        child:  Text(
                          stack.announcementtitle.value,
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontFamily:
                            //FitnessAppTheme.fontName,
                            fontWeight:
                            FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.1,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(stack.announcementcontent.value,
                          style: TextStyle(
                            height: 1.4,
                          ),),
                      )
                    ],


                  )



              )
                  :
              Text("");
            }),

          ],
        ),
      ),
    ));
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

class CurvePainter extends CustomPainter {
  CurvePainter({required this.colors, this.angle = 140});

  final double angle;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shdowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final Offset shdowPaintCenter = Offset(size.width / 2, size.height / 2);
    final double shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final SweepGradient gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colors,
    );
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    const SweepGradient gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: <Color>[Colors.white, Colors.white],
    );

    final Paint cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = Colors.white;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final double centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    final double radian = (math.pi / 180) * degree;
    return radian;
  }
}

class searchdata extends SearchDelegate<String> {
  final vehicles = ['HR25HN0212', 'UP21 NH 2546', 'MH 24 fg 2546'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggessionlist = query.isEmpty
        ? vehicles
        : vehicles.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.directions_car_filled),
        title: Text(suggessionlist[index]),
      ),
      itemCount: suggessionlist.length,
    );
  }
}
