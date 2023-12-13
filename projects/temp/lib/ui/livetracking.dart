import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../code/livetracking_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';


class livetracking extends StatefulWidget {
  final String deviceid;

  livetracking({super.key, required this.deviceid});

  @override
  State<livetracking> createState() => _livetrackingState(deviceid);
}

class _livetrackingState extends State<livetracking> {
  final livetracking_code stack = Get.put(livetracking_code());

  _livetrackingState(String deviceid) {
    stack.tracking(deviceid);
  }

  // final aj = "testing";

  @override
  void dispose() {
    stack.timer.cancel();
    stack.mapController.dispose();
    //Get.deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFecedee),
      body: SlidingUpPanel(
        panel: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10))
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 70,
                    height: 65,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Obx(
                                  () => Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/listicons/${stack.vtype.value}${stack.status.value == 'Ideal' ? 'Stop' : stack.status.value}.png'))),
                              ),
                            )),
                        Align(
                            alignment: Alignment.topRight,
                            child: Obx(
                                  () => Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: stack.status == "Running"
                                        ? appcolor.runninglight
                                        : stack.status == "Stop"
                                        ? appcolor.stoplight
                                        : appcolor.idlelight,
                                    border: Border.all(
                                        color: stack.status == "Running"
                                            ? appcolor.running
                                            : stack.status == "Stop"
                                            ? appcolor.stop
                                            : appcolor.idle,
                                        width: 1.5)),
                                child: Center(
                                    child: Obx(() => Text(
                                      '${stack.speed} \n KM/HR',
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                        color: stack.status == "Running"
                                            ? appcolor.running
                                            : stack.status == "Stop"
                                            ? appcolor.stop
                                            : appcolor.idle,
                                        fontSize: 7,
                                      ),
                                    ))),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(
                                () => Text(stack.vehicleno.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF757576),
                                )),
                          ),
                          const SizedBox(width: 12),
                          Obx(() => Container(
                              padding: const EdgeInsets.fromLTRB(7, 3, 7, 3),
                              decoration: BoxDecoration(
                                  color: stack.ignition == true
                                      ? appcolor.runninglight
                                      : appcolor.stoplight,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: stack.ignition == true
                                          ? appcolor.running
                                          : appcolor.stop,
                                      width: 1.5)),
                              child: Icon(Icons.key,
                                  size: 15,
                                  color: stack.ignition == true
                                      ? appcolor.running
                                      : appcolor.stop)))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xff5575b6),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: 260,
                            child: Obx(() => Text(
                              stack.address.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            // SizedBox(height: 20),

            Obx(() => DefaultTabController(
                length: 4, // length of tabs
                initialIndex: stack.tabindex.value,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          labelColor: Colors.blueAccent,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'info'.tr),
                            Tab(text: 'history'.tr),
                            Tab(text: 'sensors'.tr),
                            Tab(text: 'details'.tr),
                          ],
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height / 2 -
                              120, //height of TabBarView
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          child: TabBarView(children: <Widget>[
                            // this container for Information Binding
                            Container(
                              padding: const EdgeInsets.all(12),
                              child: SingleChildScrollView(
                                  child: Obx(
                                        () => Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        vinfo(
                                            infoicon: Icon(
                                              Icons.directions_car_filled,
                                              color: stack.status == "Running"
                                                  ? appcolor.running
                                                  : stack.status == "Stop"
                                                  ? appcolor.stop
                                                  : appcolor.idle,
                                              size: 30,
                                            ),
                                            title: 'vehicle_status'.tr,
                                            subtitle: 'vehicle_current_status'.tr,
                                            infovalue: stack.status.toString()),
                                        vinfo(
                                            infoicon: Icon(
                                              Icons.key,
                                              color: stack.ignition == true
                                                  ? appcolor.running
                                                  : appcolor.stop,
                                              size: 30,
                                            ),
                                            title: 'ignition'.tr,
                                            subtitle: 'ignition_status'.tr,
                                            infovalue: stack.ignition == true
                                                ? "ON"
                                                : "Off"),
                                        vinfo(
                                            infoicon: const Icon(
                                              Icons.timeline,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            title: 'today_distance'.tr,
                                            subtitle: 'till_now_driven_km'.tr,
                                            infovalue: '${stack.drivenkm} KM'),
                                        vinfo(
                                            infoicon: const Icon(
                                              Icons.satellite_alt,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            title: 'satellite'.tr,
                                            subtitle: 'connected_satellite'.tr,
                                            infovalue: stack.sat.toString()),
                                        vinfo(
                                            infoicon: const Icon(
                                              Icons.directions_run,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            title: 'speed'.tr,
                                            subtitle:
                                            'vehicle_moving_km_per_hour'.tr,
                                            infovalue: '${stack.speed} KM/ HR'),
                                        vinfo(
                                            infoicon: const Icon(
                                              Icons.place,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            title: 'lat_lon'.tr,
                                            subtitle: 'latitude_and_longitude'.tr,
                                            infovalue:
                                            '${stack.lat} / ${stack.lon}'),
                                      ],
                                    ),
                                  )),
                            ),
                            // this container for History binding
                            Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: stack.requesteddates.value
                                            .map(
                                              (element) => hdatebtn(
                                              text: element["text"],
                                              date: element["date"]),
                                        )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    //writing a code for the list ittration

                                    stack.isloading.value == true
                                        ? const CircularProgressIndicator()
                                        : stack.filterlist.value.length > 0
                                        ? Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical: 15,
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(
                                                    0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        35),
                                                    border:
                                                    Border.all(
                                                      color: Colors
                                                          .blueAccent,
                                                      style:
                                                      BorderStyle
                                                          .solid,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(2.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .directions_car,
                                                            size: 20,
                                                            color: Colors
                                                                .blueAccent),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                  width: 2),
                                              Text(
                                                stack.runningtimestr
                                                    .value
                                                    .toString(),
                                                style:
                                                const TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color: Colors
                                                        .black,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                  width: 15),
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        35),
                                                    border:
                                                    Border.all(
                                                      color: Colors
                                                          .blueAccent,
                                                      style:
                                                      BorderStyle
                                                          .solid,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(2.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .timeline_rounded,
                                                            size: 20,
                                                            color: Colors
                                                                .blueAccent),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                  width: 2),
                                              Text(
                                                '${(stack.totalkm.value / 1000).toStringAsFixed(2)} KM',
                                                style:
                                                const TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color: Colors
                                                        .black,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                  width: 15),
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        35),
                                                    border:
                                                    Border.all(
                                                      color: Colors
                                                          .blueAccent,
                                                      style:
                                                      BorderStyle
                                                          .solid,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(2.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .local_parking,
                                                            size: 20,
                                                            color: Colors
                                                                .blueAccent),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                  width: 2),
                                              Text(
                                                  stack.stoptimestr
                                                      .value
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Colors
                                                          .black,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(
                                          children:
                                          stack.filterlist.value
                                              .map(
                                                (element) =>
                                                Column(
                                                  children: [
                                                    element["type"] ==
                                                        2
                                                        ? startpoint(
                                                        motion: element[
                                                        "motion"],
                                                        address: element[
                                                        "address"],
                                                        starttime: DateFormat(appcolor.appdatetime, stack.currentlanguage.value).format(DateTime.parse(element["device_dt"]
                                                            .toString())))
                                                        : element["type"] ==
                                                        3
                                                        ? endpoint(
                                                        motion: element["motion"],
                                                        address: element["address"],
                                                        endtime: DateFormat(appcolor.appdatetime, stack.currentlanguage.value).format(DateTime.parse(element["device_dt"].toString())))
                                                        : element["type"] == 0
                                                        ? stoppoint(
                                                      duration: FleetStack.mintostr(element["duration"]),
                                                      fromdate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["fromdate"].toString())),
                                                      todate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["todate"].toString())),
                                                      address: element["address"],
                                                    )
                                                        : runningpoint(
                                                      duration: FleetStack.mintostr(element["duration"]),
                                                      fromdate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["fromdate"].toString())),
                                                      todate: DateFormat(appcolor.apptime, stack.currentlanguage.value).format(DateTime.parse(element["todate"].toString())),
                                                      distance: element["distance"],
                                                    )
                                                  ],
                                                ),
                                          )
                                              .toList(),
                                        )
                                      ],
                                    )
                                        : const Text("No Data Found"),

                                    // stopunit(),
                                    // movingunit(),
                                    // stopunit(),
                                    // movingunit(),
                                    // stopunit(),
                                    // movingunit(),
                                    // stopunit(),
                                    // movingunit(),
                                  ],
                                ),
                              ),
                            ),
                            //this is for sensor data binding
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     Container(
                                      //         height: 35,
                                      //         decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(8),
                                      //           color: Colors.white,
                                      //           boxShadow: [
                                      //             BoxShadow(
                                      //               color: Colors.grey, //New
                                      //               blurRadius: 5.0,
                                      //             )
                                      //           ],
                                      //         ),
                                      //         child: Padding(
                                      //           padding: const EdgeInsets.all(5.0),
                                      //           child: Row(
                                      //             crossAxisAlignment: CrossAxisAlignment.center,
                                      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      //             children: [
                                      //               SizedBox(width: 20.0,),
                                      //
                                      //               Text("add_new_sensor".tr, style: TextStyle(color:  Colors.black87, fontWeight: FontWeight.bold),),
                                      //               SizedBox(width: 10.0,),
                                      //               Icon(Icons.settings,
                                      //                 size: 20,),
                                      //               SizedBox(width: 20.0,),
                                      //             ],
                                      //           ),
                                      //         )
                                      //     ),
                                      //   ],
                                      // ),

                                      const SizedBox(height: 5),

                                      stack.sensorlist.length>0?
                                      Obx(() => Column(
                                        children: stack.sensorlist
                                            .map((element) => sensorlist(
                                            id: element["sensorid"],
                                            sensorname:
                                            element["sensorname"]??"",
                                            sensoricon:
                                            element["sensoricon"]??"",
                                            type: element["sersortype"] == "1"?"Digital": "Analog",
                                            value: "${element["formulavalue"]} ${element["sersortype"] == "1"?"": element["sersorunit"]} " ,
                                            device_dt: DateTime.parse(
                                                element["device_dt"])))
                                            .toList(),
                                      )):
                                      Container(
                                        child: Text("No Data"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //this is for the details binding
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                    child: Obx(
                                          () => Column(
                                        children: [
                                          vinfo(
                                              infoicon: Icon(
                                                Icons.drive_eta,
                                                color: stack.status == "Running"
                                                    ? Colors.green
                                                    : stack.status == "Stop"
                                                    ? Colors.redAccent
                                                    : const Color(0Xffc08c07),
                                                size: 30,
                                              ),
                                              title: 'vehicle'.tr,
                                              subtitle: 'type_of_vehicle'.tr,
                                              infovalue: stack.vtype.toString()),

                                          vinfo(
                                              infoicon: const Icon(
                                                Icons.settings_ethernet,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                              title: 'imei'.tr,
                                              subtitle: 'gps_device_imei'.tr,
                                              infovalue: stack.imei.toString()),

                                          stack.drivername.value.length > 0
                                              ? Column(
                                            children: [
                                              vinfo(
                                                  infoicon: Icon(
                                                    Icons.person,
                                                    color: appcolor.blue,
                                                    size: 30,
                                                  ),
                                                  title: 'driver_name'.tr,
                                                  subtitle:
                                                  'currently the person driving',
                                                  infovalue: stack.drivername
                                                      .toString()),
                                              vinfo(
                                                  infoicon: Icon(
                                                    Icons.phone_android,
                                                    color: appcolor.grayblack,
                                                    size: 30,
                                                  ),
                                                  title: 'driver_number'.tr,
                                                  subtitle:
                                                  'contact number of the driver',
                                                  infovalue: stack
                                                      .drivermobile
                                                      .toString()),
                                            ],
                                          )
                                              : const Text(""),

                                          // vinfo( infoicon: Icon(Icons.edgesensor_high,
                                          //   color: Colors.black87,
                                          //   size: 30,
                                          // ), title: 'GPS Device', subtitle: 'device type', infovalue: 'GT06' ),
                                          //
                                          // vinfo( infoicon: Icon(Icons.accessible,
                                          //   color: Colors.black87,
                                          //   size: 30,
                                          // ), title: 'Driver', subtitle: 'the person driving', infovalue: 'Alok Kumar' ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ]))
                    ]))),
          ],
        ),
        body: Column(
          children: [
            Container(
              // covers 20% of total height
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  GetBuilder<livetracking_code>(
                      id: 'UpdateView',
                      builder: (logic) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          /*child: FlutterMap(
                            mapController: logic.mapControllerM,
                            // ignore: sort_child_properties_last
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: logic.latLongListM[0],
                                    builder: (contx) {
                                      return const Icon(Icons.location_pin);
                                    },
                                  ),
                                  Marker(
                                    point: logic.loc1M,
                                    builder: (contx) {
                                      return const Icon(Icons.location_pin);
                                    },
                                  ),
                                ],
                              ),
                              // PolylineLayer(
                              //   polylines: [
                              //     Polyline(points: points, strokeWidth: 4, color: Colors.purple),
                              //   ],
                              // ),
                            ],
                            options: MapOptions(
                              center: logic.loc1M,
                              zoom: 14.0,
                              maxZoom: 18,
                              interactiveFlags:
                                  InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                          ),*/
                          child: Obx(
                                () => FlutterMap(
                              mapController: stack.mapController,
                              options: MapOptions(
                                zoom: 16,
                                maxZoom: 18.33,
                                center: stack.point.value,
                                interactiveFlags: InteractiveFlag.all &
                                ~InteractiveFlag.rotate,
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
                                    : const Text(""),

                                stack.isgeofence.value
                                    ? PolylineLayer(
                                  polylines: stack.polylines.value,
                                )
                                    : const Text(""),

                                stack.isgeofence.value
                                    ? CircleLayer(
                                  circles: stack.polycircle.value,
                                )
                                    : const Text(""),

                                //for POI

                                stack.ispoi.value
                                    ? CircleLayer(
                                  circles: stack.poipolycircle.value,
                                )
                                    : const Text(""),
                                stack.ispoi.value
                                    ? MarkerLayer(
                                  markers: stack.poimarkers.value,
                                )
                                    : const Text(""),

                                //Display My current location
                                stack.ismylocation.value == false
                                    ? const Text("")
                                    : stack.mymaplocation.value != null
                                    ? MarkerLayer(markers: [
                                  stack.mymaplocation.value!,
                                ])
                                    : const Text(""),

                                stack.istrackline.value == true
                                    ? PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      // points: stack.line.value,
                                      points:
                                      stack.issmooth_tracking.value
                                          ? stack.lineM.value
                                          : stack.line.value,
                                      strokeWidth: 2,
                                      color: appcolor.trackline,
                                      // gradientColors: [
                                      //   const Color(0xffE40203),
                                      //   const Color(0xffFEED00),
                                      //   const Color(0xff007E2D),
                                      // ],
                                    ),
                                  ],
                                )
                                    : const Text(""),

                                (stack.issmooth_tracking.value)
                                    ? /*MarkerLayer(
                                        markers: stack.markersM,
                                      )*/
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      // point: logic.point.value,
                                      point: logic.pointM.value,
                                      builder: (contx) {
                                        return logic.widgetCar;
                                        /*return logic.isripple.value == true
                                                  ? RippleWave(
                                                  childTween: Tween(begin: 0, end: 1),
                                                  color: logic.status.value == "Running"
                                                      ? appcolor.runningripple
                                                      : logic.status.value == "Stop"
                                                      ? appcolor.stopripple
                                                      : appcolor.idleripple,
                                                  child: Image.asset(
                                                    'assets/images/icons/car2-red.png',
                                                    // 'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
                                                    // 'assets/images/icons/${details[4]}${details[3]}.png',
                                                    width: 30,
                                                    height: 30,
                                                  ))
                                                  : Image.asset(
                                                'assets/images/icons/car2-red.png',
                                                // 'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
                                                // 'assets/images/icons/${details[4]}${details[3]}.png',
                                                width: 30,
                                                height: 30,
                                              );*/
                                      },
                                    ),
                                  ],
                                )
                                    : MarkerLayer(
                                  markers: stack.markers,
                                  //     markers: [
                                  //       Marker(
                                  //         point: stack.point.value ,
                                  //         //  point: LatLng(25.2546, 78.2568),
                                  //         width: 40,
                                  //         height: 40,
                                  //         builder: (context) =>
                                  //             GestureDetector(
                                  //               child: Image.asset(
                                  //                 'assets/images/icons/${stack.vtype}${stack.status}.png',
                                  //               ),
                                  //               onTap: (){
                                  //                 print("icon clicked live tracking");
                                  //               },
                                  //             ),
                                  //       ),
                                  //     ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  Positioned(
                      top: MediaQuery.of(context).size.height / 7,
                      right: 15,
                      child: Obx(() => Column(
                        children: [
                          mapicon(
                              micon: const Icon(Icons.layers_sharp,
                                  size: 21, color: Color(0xff6a6a6a)),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                    const Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Container(
                                        height: MediaQuery.of(context)
                                            .size
                                            .height /
                                            5,
                                        color: Colors.white,
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 30),
                                                Text(
                                                  'map_types'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Color(
                                                          0xff535454)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(1.5),
                                                        // Border width
                                                        decoration: BoxDecoration(
                                                            color:
                                                            Colors.grey,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          child: SizedBox
                                                              .fromSize(
                                                            size: const Size
                                                                .fromRadius(30),
                                                            // Image radius
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
                                                    const SizedBox(
                                                        height: 7),
                                                    Text(
                                                      'default'.tr,
                                                      style:
                                                      const TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(1.5),
                                                        // Border width
                                                        decoration: BoxDecoration(
                                                            color:
                                                            Colors.grey,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          child: SizedBox
                                                              .fromSize(
                                                            size: const Size
                                                                .fromRadius(30),
                                                            // Image radius
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
                                                    const SizedBox(
                                                        height: 7),
                                                    Text(
                                                      'satellite'.tr,
                                                      style:
                                                      const TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(1.5),
                                                        // Border width
                                                        decoration: BoxDecoration(
                                                            color:
                                                            Colors.grey,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          child: SizedBox
                                                              .fromSize(
                                                            size: const Size
                                                                .fromRadius(30),
                                                            // Image radius
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
                                                    const SizedBox(
                                                        height: 7),
                                                    Text(
                                                      'terrain'.tr,
                                                      style:
                                                      const TextStyle(
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

                          const SizedBox(height: 150),
                          mapicon(
                            micon: const Icon(Icons.settings,
                                size: 21, color: Color(0xff6a6a6a)),
                            icontap: () {
                              return showModalBottomSheet(
                                  context: context,
                                  backgroundColor: const Color(0xFFc1c2c3),
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  // clipBehavior: Clip.hardEdge,
                                  builder: (context) {
                                    return Container(
                                      height: MediaQuery.of(context)
                                          .size
                                          .height /
                                          2.8,
                                      color: Colors.white,
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 5, 25, 0),
                                      child: Obx(() => Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('map_settings'.tr,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Color(
                                                      0xff535454))),
                                          const SizedBox(height: 10),

                                          // mapsettinglist(title: 'label'.tr, type: 'label', status: stack.islabel.value ,),
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
                                            title: 'trackline'.tr,
                                            type: 'trackline',
                                            status:
                                            stack.istrackline.value,
                                          ),
                                          mapsettinglist(
                                            title: 'smooth_tracking'.tr,
                                            type: 'smooth_tracking',
                                            status: stack
                                                .issmooth_tracking
                                                .value,
                                          ),
                                          mapsettinglist(
                                            title: 'ripple'.tr,
                                            type: 'ripple',
                                            status:
                                            stack.isripple.value,
                                          ),
                                          mapsettinglist(
                                            title: 'my_location'.tr,
                                            type: 'mylocation',
                                            status: stack
                                                .ismylocation.value,
                                          ),
                                        ],
                                      )),
                                    );
                                  });
                            },
                          ),
                          const SizedBox(height: 20),

                          mapicon(
                              micon: Icon(
                                  stack.isimmobilize.value
                                      ? Icons.lock_open_rounded
                                      : Icons.lock,
                                  size: 21,
                                  color: stack.isimmobilize.value
                                      ? appcolor.running
                                      : appcolor.stop),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                    const Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Obx(() => Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              2.2,
                                          color: Colors.white,
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              25, 20, 25, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text('immobilize_vehicle'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Color(
                                                          0xff535454))),
                                              const SizedBox(height: 10),
                                              Center(
                                                child: stack.isprocess
                                                    .value ==
                                                    true
                                                    ? beforeresult()
                                                    : stack
                                                    .processresult
                                                    .value
                                                    .length >
                                                    1
                                                    ? Text(
                                                  stack
                                                      .processresult
                                                      .value,
                                                  style: TextStyle(
                                                      color: appcolor
                                                          .blue),
                                                )
                                                    : const SizedBox(
                                                    height: 5),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    child: Image.asset(
                                                      'assets/images/engine-start.png',
                                                      height: 130,
                                                      width: 130,
                                                    ),
                                                    onTap: () {
                                                      stack.startvehicle(
                                                          stack.imei.value);
                                                    },
                                                  ),
                                                  const SizedBox(width: 30),
                                                  GestureDetector(
                                                    child: Image.asset(
                                                      'assets/images/engine-stop.png',
                                                      height: 130,
                                                      width: 130,
                                                    ),
                                                    onTap: () {
                                                      stack.stopvehicle(
                                                          stack.imei.value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    10.0),
                                                decoration: BoxDecoration(
                                                  color: appcolor.idlelight,
                                                  border: Border.all(
                                                    color: appcolor.idle,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      5.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Note:",
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        color:
                                                        appcolor.idle,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 10),
                                                    Expanded(
                                                        child: Text(
                                                          "it may take 2-5 minuts to fatch result from server",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: appcolor
                                                                  .black),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )));
                                    });
                              }),
                          const SizedBox(height: 20),

                          mapicon(
                              micon: Icon(Icons.local_parking,
                                  size: 21,
                                  color: stack.isparking.value == true
                                      ? appcolor.stop
                                      : appcolor.running),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                    const Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              6,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(25),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text('parking_mode'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Color(
                                                          0xff535454))),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                      height: 40,
                                                      width: 100,
                                                      child: Obx(
                                                            () => Switch(
                                                          value: stack
                                                              .isparking
                                                              .value,
                                                          onChanged:
                                                              (value) {
                                                            stack
                                                                .changeparkingmode(
                                                                value);
                                                          },
                                                          activeTrackColor:
                                                          Colors
                                                              .lightGreenAccent,
                                                          activeColor:
                                                          Colors.green,
                                                        ),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ));
                                    });
                              }),

                          const SizedBox(height: 20),

                          mapicon(
                              micon: const Icon(Icons.directions_walk,
                                  size: 21, color: Color(0xff6a6a6a)),
                              icontap: () {
                                return showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                    const Color(0xFFc1c2c3),
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    // clipBehavior: Clip.hardEdge,
                                    builder: (context) {
                                      return Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              5,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(25),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'navigate_to_the_vehicle_location'
                                                      .tr,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Color(
                                                          0xff535454))),
                                              const SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () async {
                                                  await launch(
                                                      'https://www.google.com/maps/dir/?api=1&origin=Current+Location&destination=${stack.lat},${stack.lon}');
                                                },
                                                child: Container(
                                                    height: 50,
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                      gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                1),
                                                            Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                .6),
                                                          ]),
                                                      boxShadow: [
                                                        const BoxShadow(
                                                          color: Colors
                                                              .grey, //New
                                                          blurRadius: 25.0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          const SizedBox(
                                                            width: 30.0,
                                                          ),
                                                          Text(
                                                            "continue".tr,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 30.0,
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ));
                                    });
                              }),

                          const SizedBox(height: 20),
                          // mapicon(micon: Icon(Icons.add_location_alt,
                          //     size: 21,
                          //     color: Color(0xff6a6a6a)),
                          //     icontap: (){
                          //       Get.to(addpoint());
                          //     })
                        ],
                      ))),
                  Positioned(
                      top: 60,
                      left: 18,
                      width: 38,
                      height: 38,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black87,
                          size: 30,
                        ),
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

  final livetracking_code stack = Get.put(livetracking_code());
  final String title;
  final String type;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const Spacer(),
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
                  : type == "ripple"
                  ? stack.isripple.value = value
                  : type == "mylocation"
                  ? stack.ismylocation.value = value
                  : type == "trackline"
                  ? stack.istrackline.value = value
                  : stack.issmooth_tracking.value = value;

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

class hdatebtn extends StatelessWidget {
  hdatebtn({Key? key, required this.text, required this.date})
      : super(key: key);
  final livetracking_code stack = Get.put(livetracking_code());
  final String text;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
      onTap: () {
        print('here is the date ${date}');
        stack.requesthistory(date: date);
      },
    );
  }
}

class startpoint extends StatelessWidget {
  startpoint(
      {Key? key,
        required this.motion,
        required this.address,
        required this.starttime})
      : super(key: key);

  final bool motion;
  final String address;
  final String starttime;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.white,
        border: const Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: Row(
        children: [
          Container(
            // color: appcolor.stoplight,
            width: appcolor.width / 4.9,
            child: const Text(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xff5575b6),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: appcolor.width / 2.5,
                        child: Text(
                          address,
                          style: const TextStyle(
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
    );
  }
}

class stoppoint extends StatelessWidget {
  const stoppoint(
      {Key? key,
        required this.duration,
        required this.fromdate,
        required this.todate,
        required this.address})
      : super(key: key);

  final String duration;
  final String fromdate;
  final String todate;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.stoplight,
        border: const Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: appcolor.width / 4.9,
            child: Text(
              duration,
              style: const TextStyle(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xff5575b6),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: appcolor.width / 2.5,
                        child: Text(
                          address,
                          style: const TextStyle(
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
    );
  }
}

class runningpoint extends StatelessWidget {
  const runningpoint(
      {Key? key,
        required this.duration,
        required this.fromdate,
        required this.todate,
        required this.distance})
      : super(key: key);

  final String duration;
  final String fromdate;
  final String todate;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.runninglight,
        border: const Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: appcolor.width / 4.9,
            child: Text(
              duration,
              style: const TextStyle(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.timeline, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(distance.toString()),
                      const SizedBox(width: 25),
                      // Icon(Icons.directions_run, color: Colors.green),
                      // SizedBox(width: 5),
                      // Text('56 KM/HR'),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class endpoint extends StatelessWidget {
  const endpoint(
      {Key? key,
        required this.motion,
        required this.address,
        required this.endtime})
      : super(key: key);
  final bool motion;
  final String address;
  final String endtime;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
        color: appcolor.white,
        border: const Border(
          bottom: BorderSide(width: 0.5, color: Colors.red),
          top: BorderSide(width: 0.5, color: Colors.red),
        ),
      ),
      child: Row(
        children: [
          Container(
            // color: appcolor.stoplight,
            width: appcolor.width / 4.9,
            child: const Text(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xff5575b6),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: appcolor.width / 2.5,
                        child: Text(
                          address,
                          style: const TextStyle(
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
    );
  }
}

class sensorlist extends StatelessWidget {
  sensorlist(
      {Key? key,
        required this.id,
        required this.sensorname,
        required this.sensoricon,
        required this.type,
        required this.value,
        required this.device_dt})
      : super(key: key);

  final int id;
  final String sensorname;
  final String sensoricon;
  final String type;
  final String value;
  final DateTime device_dt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            // Text(sensoricon),

            const Icon(
              FontAwesomeIcons.car,
              color: Colors.black,
              size: 30,
            ),

            // Icon(Icons.directions_car_filled,
            //   size: 35,
            //   color: Color(0xff2e2e2f),
            // ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sensorname,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(type)
                // Text(
                //   subtitle,
                //   style: TextStyle(fontSize: 13, color: Color(0xFF757576)),
                //   overflow: TextOverflow.ellipsis,
                // )
              ],
            ),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(width: 12),
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

Widget beforeresult() {
  return Container(
    child: Column(
      children: [
        const Text(
          "command sent, waiting for result....",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator()
      ],
    ),
  );
}
