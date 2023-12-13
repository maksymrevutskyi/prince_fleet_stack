import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import '/common/get_list_of_latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../common/FleetStack.dart';
import '../common/widgets.dart';

class livetracking_code extends GetxController {
  late MapController mapController;
  late Timer timer;

  final mymaplocation = Rxn<Marker>();
  Rx<List<LatLng>> line = Rx([]);
  Rx<List<LatLng>> lineM = Rx([]);
  Rx<List<Marker>> locationmarker = Rx([]);

  Rx<List<Map<String, dynamic>>> requesteddates = Rx([]);

  Rx<List<Map<String, dynamic>>> rawdata = Rx([]);
  Rx<List<dynamic>> filterlist = Rx([]);
  final isloading = false.obs;
  final tabindex = 0.obs;

  final runningtime = 0.0.obs;
  final stoptime = 0.0.obs;
  final totalkm = 0.0.obs;
  final runningtimestr = "".obs;
  final stoptimestr = ''.obs;

  final deviceid = "".obs;
  final status = "".obs;
  final speed = 0.0.obs;
  final vehicleno = "".obs;
  final ignition = false.obs;
  final address = "".obs;
  final drivenkm = 0.0.obs;
  final sat = 0.obs;
  final lat = 0.0.obs;
  final lon = 0.0.obs;
  final vtype = "".obs;
  final imei = "".obs;
  final devicetype = "".obs;
  final drivername = "".obs;
  final drivermobile = "".obs;
  final isparking = false.obs;
  final isimmobilize = true.obs;

  final isgeofence = true.obs;
  final ispoi = true.obs;
  final isripple = true.obs;
  final ismylocation = false.obs;
  final istrackline = true.obs;
  RxBool issmooth_tracking = true.obs;
  List<LatLng> latLongList = [];
  var tile =
      "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;
  final currentlanguage = "en_US".obs;

  RxList<Marker> markers = <Marker>[].obs;

  Widget widgetCar = Container();

  Rx<LatLng> point = Rx(LatLng(27.605466, 75.771649));
  Rx<LatLng> pointM = Rx(LatLng(27.605466, 75.771649));

  List<LatLng> latLongListM = [];

  LatLng? loc1M;

  //Rx<List<dynamic>> sensorlist = Rx([]);
  var sensorlist = [].obs;

  final isprocess = false.obs;
  final processresult = "".obs;
  LatLng? markerLatlng;

  //for Poi
  Rx<List<Marker>> poimarkers = Rx([]);
  Rx<List<CircleMarker>> poipolycircle = Rx([]);

  //for geofence
  Rx<List<Polygon>> polygons = Rx([]);
  Rx<List<Polyline>> polylines = Rx([]);
  Rx<List<CircleMarker>> polycircle = Rx([]);

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    mapController = MapController();

    binddates();

    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      debugPrint("Call API");
      livetracking();
    });

    Future.delayed(const Duration(seconds: 6), () {
      requesthistory(date: DateTime.now());
      getsensor();
    });
  }

  Future<void> tracking(String param) async {
    debugPrint(param);

    var details = param.split(',');

    deviceid.value = details[0];
    status.value = details[4];
    vtype.value = details[3];

    line.value.add(LatLng(double.parse(details[1]), double.parse(details[2])));
    lineM.value.add(LatLng(double.parse(details[1]), double.parse(details[2])));

    point.value = LatLng(double.parse(details[1]), double.parse(details[2]));
    pointM.value = LatLng(double.parse(details[1]), double.parse(details[2]));

    latLongListM = [LatLng(double.parse(details[1]), double.parse(details[2]))];
    loc1M = LatLng(double.parse(details[1]), double.parse(details[2]));

    /////------------------------------
    ///------------ MAULIK
    loc1M = latLongListM[0];

    positionM = [
      // loc1.latitude,
      latLongListM[0].latitude,
      latLongListM[0].longitude,
      // loc1.longitude
    ]; //initial position of moving marker
    pos1M = loc1M!;
    pos2M = loc1M!;

    /////------------------------------

    markers.value = [
      Marker(
        height: 35,
        width: 35,
        point: point.value,
        builder: (context) => isripple.value == true
            ? RippleWave(
                childTween: Tween(begin: 0, end: 1),
                color: status.value == "Running"
                    ? appcolor.runningripple
                    : status.value == "Stop"
                        ? appcolor.stopripple
                        : appcolor.idleripple,
                child: Image.asset(
                  'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
                  // 'assets/images/icons/${details[4]}${details[3]}.png',
                  width: 30,
                  height: 30,
                ))
            : Image.asset(
                'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
                // 'assets/images/icons/${details[4]}${details[3]}.png',
                width: 30,
                height: 30,
              ),
      ),
    ];

    widgetCar = isripple.value == true
        ? RippleWave(
            childTween: Tween(begin: 0, end: 1),
            color: status.value == "Running"
                ? appcolor.runningripple
                : status.value == "Stop"
                    ? appcolor.stopripple
                    : appcolor.idleripple,
            child: Image.asset(
              'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
              // 'assets/images/icons/${details[4]}${details[3]}.png',
              width: 30,
              height: 30,
            ))
        : Image.asset(
            'assets/images/icons/${details[3]}${details[4] == 'carIdeal' ? 'carStop' : details[4]}.png',
            // 'assets/images/icons/${details[4]}${details[3]}.png',
            width: 30,
            height: 30,
          );
    update(['UpdateView']);

    localsetting();

    debugPrint("debugPrinting the label ${details[4]}");

    debugPrint("strt calling live");
    livetracking();
    //  mapController.move(point.value, mapController.zoom??12);
    // var sensordata = await FleetStack.getauthdata('getsensorlist?deviceid=${deviceid}');
    // debugPrint('prinint sensor data \n ${sensordata}');

    //  binddates();
  }

  void localsetting() async {
    isgeofence.value =
        (await FleetStack.getlocal("isgeofence") == 'false') ? false : true;
    ispoi.value =
        (await FleetStack.getlocal("ispoi") == 'false') ? false : true;
    isripple.value =
        (await FleetStack.getlocal("isripple") == 'false') ? false : true;
    ismylocation.value =
        (await FleetStack.getlocal("ismylocation") == 'true') ? true : false;
    final String temptile = await FleetStack.getlocal("tile");
    tile.value = temptile.isNotEmpty
        ? temptile.toString()
        : "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}";

    String languagevalue = await FleetStack.getlocal("language");
    currentlanguage.value = languagevalue == '' ? "en_US" : languagevalue;
    initializeDateFormatting(currentlanguage.value);

    if (ismylocation.value) {
      showlocation();
    }

    if (ispoi.value) {
      showpoi();
    }

    if (isgeofence.value) {
      showfence();
    }
  }

  changemap(int type) {
    switch (type) {
      case 1:
        tile.value =
            "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile',
            "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      case 2:
        tile.value =
            "http://www.google.com/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile',
            "http://www.google.com/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      case 3:
        tile.value =
            "http://www.google.com/maps/vt?lyrs=p@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile',
            "http://www.google.com/maps/vt?lyrs=p@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      default:
        tile.value =
            "http://www.google.com/maps/vt?lyrs=h@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile',
            "http://www.google.com/maps/vt?lyrs=h@189&gl=cn&x={x}&y={y}&z={z}");
        break;
    }
  }

  // LatLng? storedLat;

  Future<void> livetracking() async {
    var result =
        await FleetStack.getauthdata('getDeviceDeta?Deviceid=$deviceid');
    // localsetting();

    isCompleted = false;
    debugPrint(mapController.zoom.toString());


    if (result["respcode"] == true) {
      var data = FleetStack.stringtojson(result["data"]);
      // var val = [data[0]["lastlatitude"], data[0]["lastlongitude"]];
      // position = val;
      // transition(val);
      status.value = data[0]["status"];
      speed.value = data[0]["speed"];
      vehicleno.value = data[0]["vehicleno"];
      ignition.value = data[0]["ign"];
      address.value = data[0]["address"];
      drivenkm.value = data[0]["driventoday"];
      sat.value = data[0]["sat"];
      speed.value = data[0]["speed"];
      lat.value = data[0]["lastlatitude"];
      lon.value = data[0]["lastlongitude"];

      debugPrint("LIST OF DATA ==> ${data.toList().toString()}");

      /////------------------------------
      /// MAULIK
      // point.value = latLongListM[0];
      mapController.move(point.value, mapController.zoom);
      latLongListM = [];
      latLongListM.add(LatLng(lat.value, lon.value));

      onChangeValueM();
      /////------------------------------

      vtype.value = data[0]["vehicletype"];
      imei.value = data[0]["deviceimei"];
      isparking.value = data[0]["parkingenable"];
      isimmobilize.value = data[0]["immobilize"];
      if (point.value.latitude != data[0]["lastlatitude"] ||
          point.value.longitude != data[0]["lastlongitude"]) {
        line.value
            .add(LatLng(data[0]["lastlatitude"], data[0]["lastlongitude"]));
      }

      point.value = LatLng(data[0]["lastlatitude"] ?? pos2M.latitude,
          data[0]["lastlongitude"] ?? pos2M.longitude);
      drivername.value = data[0]["drivername"] ?? "--";
      drivermobile.value = data[0]["drivermob"] ?? "--";
      latLongList.clear();
      data[0]["status"].toString() == "Running"
          ? latLongList = getPointsBetween(
              LatLng(data[0]["preLatitude"], data[0]["preLongitude"]),
              LatLng(data[0]["lastlatitude"], data[0]["lastlongitude"]))
          : null;
      markers.value = [];
      widgetCar = Container();
      update(['UpdateView']);
      if (latLongList.isNotEmpty) {
        debugPrint("LIST OF LAT LANG ==> ${latLongList.toList().toString()}");
        for (var i = 0; i < latLongList.length - 1; i++) {
          if (latLongList[i].latitude != latLongList[i + 1].latitude &&
              latLongList[i].longitude != latLongList[i + 1].longitude) {
            line.value
                .add(LatLng(latLongList[i].latitude, latLongList[i].longitude));
          }

          point.value =
              LatLng(latLongList[i].latitude, latLongList[i].longitude);
          debugPrint(point.value.toString());
          lat.value = latLongList[i].latitude;
          lon.value = latLongList[i].longitude;
          markers.value = [];
          widgetCar = Container();
          update(['UpdateView']);

          /*double calculatedRotation = Geolocator.bearingBetween(
            latLongList[0].latitude,
            latLongList[0].longitude,
            latLongList[1].latitude,
            latLongList[1].longitude,
          );*/

          /// TODO: CHANGE BY MAULIK

          debugPrint("latLongListM -->> $pos2M");
          debugPrint("latLongListM -->> $i ${latLongList.length}");
          debugPrint("latLongListM -->> $i ${latLongList.length - 2}");

          double calculatedRotationA = FleetStack.bearing(
            pos2M.latitude,
            pos2M.longitude,
            latLongList[i + 1].latitude,
            latLongList[i + 1].longitude,
          );

          double calculatedRotationB = FleetStack.bearing(
            data[0]["preLatitude"],
            data[0]["preLongitude"],
            data[0]["lastlatitude"],
            data[0]["lastlongitude"],
          );

          // double calculatedRotation = (i == (latLongList.length - 2))
          double calculatedRotation = (isCompleted)
              ? FleetStack.bearing(
                  data[0]["preLatitude"],
                  data[0]["preLongitude"],
                  data[0]["lastlatitude"],
                  data[0]["lastlongitude"],
                )
              : FleetStack.bearing(
                  pos2M.latitude,
                  pos2M.longitude,
                  latLongList[i + 1].latitude,
                  latLongList[i + 1].longitude,
                );

          debugPrint("LIST OF LAT LANG ROTATION ==> A $calculatedRotationA");
          debugPrint("LIST OF LAT LANG ROTATION ==> B $calculatedRotationB");
          debugPrint("LIST OF LAT LANG ROTATION ==> IF $calculatedRotation");

          /*markers.add(
            Marker(
              height: isripple.value == false ? 30 : 90,
              width: isripple.value == false ? 30 : 90,
              point: LatLng(latLongList[i].latitude, latLongList[i].longitude),
              builder: (context) => Transform.rotate(
                // angle: calculatedRotation,
                angle: calAngle,
                child: isripple.value == true
                    ? RippleWave(
                        color: data[0]["status"].toString() == "Stop"
                            ? appcolor.stopripple
                            : data[0]["status"].toString() == "Running"
                                ? appcolor.runningripple
                                : appcolor.idleripple,
                        child: Image.asset(
                          'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'carIdeal' ? 'carStop' : data[0]["status"]}.png',
                          height: 35,
                          width: 35,
                        ))
                    : Image.asset(
                        'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'carIdeal' ? 'carStop' : data[0]["status"]}.png',
                        height: 35,
                        width: 35,
                      ),
              ),
            ),
          );*/

          widgetCar = Transform.rotate(
            // angle: (LatLng(data[0]["lastlatitude"], data[0]["lastlongitude"]) == storedLat) ? calculatedRotation2 : calculatedRotation,
            angle: calculatedRotation,
            child: isripple.value == true
                ? RippleWave(
                    color: data[0]["status"].toString() == "Stop"
                        ? appcolor.stopripple
                        : data[0]["status"].toString() == "Running"
                            ? appcolor.runningripple
                            : appcolor.idleripple,
                    child: Image.asset(
                      'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'carIdeal' ? 'carStop' : data[0]["status"]}.png',
                      height: 35,
                      width: 35,
                    ))
                : Image.asset(
                    'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'carIdeal' ? 'carStop' : data[0]["status"]}.png',
                    height: 35,
                    width: 35,
                  ),
          );
          update(['UpdateView']);

          // mapController.move(point.value, mapController.zoom);
          update();
        }
        // storedLat = LatLng(data[0]["lastlatitude"], data[0]["lastlongitude"]);
      } else {
        debugPrint("LIST OF LAT LANG ==> ELSE");

        /// TODO: CHANGE BY MAULIK
        /*double calculatedRotation = FleetStack.bearing(
          pos2M.latitude,
          pos2M.longitude,
          data[0]["lastlatitude"],
          data[0]["lastlongitude"],
        );*/

        double calculatedRotation = FleetStack.bearing(
          data[0]["preLatitude"],
          data[0]["preLongitude"],
          data[0]["lastlatitude"],
          data[0]["lastlongitude"],
        );

        /*markers.add(
          Marker(
            height: isripple.value == false ? 30 : 90,
            width: isripple.value == false ? 30 : 90,
            point: LatLng(data[0]["lastlatitude"], data[0]["lastlongitude"]),
            builder: (context) => Transform.rotate(
              angle: calculatedRotation,
              // angle: calAngle,
              child: isripple.value == true
                  ? RippleWave(
                      color: data[0]["status"].toString() == "Stop"
                          ? appcolor.stopripple
                          : data[0]["status"].toString() == "Running"
                              ? appcolor.runningripple
                              : appcolor.idleripple,
                      child: Image.asset(
                        'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'Ideal' ? 'Stop' : data[0]["status"]}.png',
                        height: 35,
                        width: 35,
                      ))
                  : Image.asset(
                      'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'Ideal' ? 'Stop' : data[0]["status"]}.png',
                      height: 35,
                      width: 35,
                    ),
            ),
          ),
        );*/

        widgetCar = Transform.rotate(
          angle: calculatedRotation,
          child: isripple.value == true
              ? RippleWave(
                  color: data[0]["status"].toString() == "Stop"
                      ? appcolor.stopripple
                      : data[0]["status"].toString() == "Running"
                          ? appcolor.runningripple
                          : appcolor.idleripple,
                  child: Image.asset(
                    'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'Ideal' ? 'Stop' : data[0]["status"]}.png',
                    height: 35,
                    width: 35,
                  ))
              : Image.asset(
                  'assets/images/icons/${data[0]["vehicletype"]}${data[0]["status"] == 'Ideal' ? 'Stop' : data[0]["status"]}.png',
                  height: 35,
                  width: 35,
                ),
        );
        update(['UpdateView']);

        // mapController.move(point.value, mapController.zoom);
      }
    }

    if (ismylocation.value == true) {
      var mylocation = await FleetStack.currentLocation();
      if (mylocation?.latitude != null && mylocation?.longitude != null) {
        locationmarker.value.add(
          Marker(
            height: 35,
            width: 35,
            point: LatLng(
              mylocation?.latitude ?? 28.244746,
              mylocation?.longitude ?? 77.140898,
            ),
            builder: (ctx) => GestureDetector(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          spreadRadius: 7.0,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
        );
      }
    }

    // othersetting();
  }

  void binddates() async {
    requesteddates.value.clear();
    var now = DateTime.now();
    for (var i = 0; i < 7; i++) {
      if (i == 0) {
        requesteddates.value
            .add({'text': 'today', 'date': now.subtract(Duration(days: i))});
      } else {
        requesteddates.value.add({
          'text': DateFormat(appcolor.historydate)
              .format(now.subtract(Duration(days: i))),
          'date': now.subtract(Duration(days: i))
        });
      }
    }
  }

  Future<void> requesthistory({required DateTime date}) async {
    filterlist.value.clear();
    isloading.value = true;
    tabindex.value = 0;
    tabindex.value = 1;

    // var fromdate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(DateTime.now())} 00:00:00');
    // var todate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(DateTime.now())} 23:58:00');
    var fromdate = Uri.encodeComponent(
        '${DateFormat(appcolor.appinputdate).format(date)} 00:00:00');
    var todate = Uri.encodeComponent(
        '${DateFormat(appcolor.appinputdate).format(date)} 23:58:00');
    var result = await FleetStack.getauthdata(
        'getHistoryReplayDta?deviceid=${deviceid.value}&startdt=$fromdate&enddt=$todate');

    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);

      if (data.isNotEmpty) {
        var refinedata = await FleetStack.refinedata(data, 5);

        filterlist.value.add({
          "type": 2,
          "device_dt": DateTime.parse(data[0]["device_dt"].toString()),
          "motion": data[0]["motion"],
          "address": data[0]["address"]
        });

        totalkm.value = 0.0;
        runningtime.value = 0.0;
        stoptime.value = 0.0;

        for (var i = 0; i < refinedata.length; i++) {
          if (refinedata[i][4] == true) {
            filterlist.value.add({
              "type": 1,
              "duration": refinedata[i][8],
              "fromdate": DateTime.parse(refinedata[i][2]),
              "todate": DateTime.parse(refinedata[i][3]),
              "distance": double.parse(
                  (double.parse(refinedata[i][6].toString()) / 1000)
                      .toStringAsFixed(2)),
              "maxspeed": refinedata[i][6]
            });

            totalkm.value += double.parse(refinedata[i][6].toString());
            runningtime.value += double.parse(refinedata[i][8].toString());
          } else {
            filterlist.value.add({
              "type": 0,
              "duration": refinedata[i][8],
              "fromdate": DateTime.parse(refinedata[i][2]),
              "todate": DateTime.parse(refinedata[i][3]),
              "address": data[refinedata[i][1]]["address"],
            });
          }
        }

        filterlist.value.add({
          "type": 3,
          "device_dt": DateTime.parse(data[data.length - 1]["device_dt"]),
          "motion": data[data.length - 1]["motion"],
          "address": data[data.length - 1]["address"]
        });

        Duration diff = DateTime.parse(data[data.length - 1]["device_dt"])
            .difference(DateTime.parse(data[0]["device_dt"]));

        stoptime.value = (diff.inSeconds / 60).ceil() - runningtime.value;

        int tempstop = stoptime.value.toInt();
        int temprunning = runningtime.value.toInt();

        runningtimestr.value = FleetStack.mintostr(temprunning);
        stoptimestr.value = FleetStack.mintostr(tempstop);

        tabindex.value = 0;
        tabindex.value = 1;
      }
    }

    isloading.value = false;
  }

  getsensor() async {
    print(deviceid.value);
    var result = await FleetStack.getauthdata( 'getsensorlist?deviceid=${deviceid.value}');
    debugPrint('prinint sensor data \n $result');
    if (result["respcode"] == true) {
      sensorlist.value = FleetStack.stringtojson(result["data"]);
      debugPrint(sensorlist.value.toString());
      debugPrint(sensorlist.value.runtimeType.toString());

      // sensorlist.value = [
      //   {
      //     "sensorid": 2,
      //     "sensorname": "Distance Sensor",
      //     "sensoricon": "road",
      //     "sersortype": "Analog",
      //     "Value": "1450 KM",
      //     "device_dt": "2023-11-29T09:40:33.72",
      //   },
      // ];
    }
  }

  changeparkingmode(bool status) async {
    //deviceid

    var parking = (status) ? "1" : "0";

    Map<String, dynamic> postdata = {};
    postdata["deviceid"] = deviceid.value;
    postdata["status"] = parking;

    var result = await FleetStack.patchauthdata('ParkingOnOFF', postdata);
    debugPrint(result);
    if (result["respcode"] == true) {
      var data = FleetStack.stringtojson(result["data"]);
      if (data[0]["error"] == 1) {
        isparking.value = status;
        if (status) {
          Get.snackbar("success".tr, "parking_mode_enabled".tr);
        } else {
          Get.snackbar("success".tr, "parking_mode_disable".tr);
        }
      } else if (data[0]["error"] == 0) {
        Get.snackbar("result".tr, data[0]["msg"]);
        return;
      }
    }
  }

  showpoi() async {
    var result = await FleetStack.getauthdata('PoiAllList');

    if (result["respcode"] == true) {
      var poidata = FleetStack.stringtojson(result["data"]);

      debugPrint('Printing Poi Data');
      debugPrint(poidata.toString());

      if (poidata.isNotEmpty) {
        poimarkers.value = [];
        poipolycircle.value = [];

        for (int i = 0; i < poidata.length; i++) {
          List<String> startstr = poidata[i]["startstr"].split(",");
          double ilat = double.parse(startstr[1]);
          double ilon = double.parse(startstr[0]);

          poimarkers.value.add(Marker(
              height: 15,
              width: 15,
              point: LatLng(
                ilat,
                ilon,
              ),
              builder: (context) => GestureDetector(
                    child: Image.asset(
                      'assets/images/poi-marker.png',
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          barrierDismissible: true,
                          title: 'Poi Details:',
                          content: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Type:".tr),
                                    const SizedBox(width: 25),
                                    Text(poidata[i]["pcatname"])
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Title:".tr),
                                    const SizedBox(width: 25),
                                    Text(poidata[i]["title"])
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Details:".tr),
                                    const SizedBox(width: 25),
                                    Text(poidata[i]["des"])
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Radius:".tr),
                                    const SizedBox(width: 25),
                                    Text('${poidata[i]["pmeter"]} Meters')
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Created at:".tr),
                                    const SizedBox(width: 25),
                                    Text(DateFormat(appcolor.appdatetime,
                                            currentlanguage.value)
                                        .format(DateTime.parse(
                                            poidata[i]["createdate"])))
                                  ],
                                ),
                              ],
                            ),
                          ));
                    },
                  )));

          poipolycircle.value.add(CircleMarker(
              point: LatLng(ilat, ilon),
              color: Color(int.parse(poidata[i]["color"].substring(1, 7),
                          radix: 16) +
                      0xFF000000)
                  .withOpacity(0.7),
              borderStrokeWidth: 2,
              borderColor: Color(
                  int.parse(poidata[i]["color"].substring(1, 7), radix: 16) +
                      0xFF000000),
              useRadiusInMeter: true,
              radius: poidata[i]["pmeter"] // 2000 meters | 2 km
              ));
        }
      }
    }
  }

  showfence() async {
    var result = await FleetStack.getauthdata('GeofanceAllList');
    if (result["respcode"] == true) {
      var geodata = FleetStack.stringtojson(result["data"]);
      if (geodata.isNotEmpty) {
        polygons.value = [];
        polylines.value = [];
        polycircle.value = [];
        for (int i = 0; i < geodata.length; i++) {
          List<LatLng> coordinates = geodata[i]["startstr"]
              .split("\$")
              .map((coord) => LatLng(double.parse(coord.split(",")[1]),
                  double.parse(coord.split(",")[0])))
              .toList()
              .cast<LatLng>();

          if (geodata[i]["geotype"] == 3) {
            polylines.value.add(
              Polyline(
                points: coordinates,
                strokeWidth: 4,
                color: Color(int.parse(
                        geodata[i]["displaycolor"].substring(1, 7),
                        radix: 16) +
                    0xFF000000),
              ),
            );
          }
          if (geodata[i]["geotype"] == 2) {
            polygons.value.add(Polygon(
              points: coordinates,
              isFilled: true,
              // By default it's false
              borderColor: Color(int.parse(
                      geodata[i]["displaycolor"].substring(1, 7),
                      radix: 16) +
                  0xFF000000),
              color: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7),
                          radix: 16) +
                      0xFF000000)
                  .withOpacity(0.2),
              borderStrokeWidth: 1,
              label: geodata[i]["geofname"],
            ));
          }

          if (geodata[i]["geotype"] == 1) {
            polycircle.value.add(
              CircleMarker(
                  point: coordinates[0],
                  color: Color(int.parse(
                              geodata[i]["displaycolor"].substring(1, 7),
                              radix: 16) +
                          0xFF000000)
                      .withOpacity(0.2),
                  borderStrokeWidth: 2,
                  borderColor: Color(int.parse(
                          geodata[i]["displaycolor"].substring(1, 7),
                          radix: 16) +
                      0xFF000000),
                  useRadiusInMeter: true,
                  radius: geodata[i]["geodistance"] // 2000 meters | 2 km
                  ),
            );
          }
        }
      }
    }
  }

  showlocation() async {
    var mylocation = await FleetStack.currentLocation();
    if (mylocation?.latitude != null && mylocation?.longitude != null) {
      mymaplocation.value = Marker(
        height: 35,
        width: 35,
        point: LatLng(
          mylocation?.latitude ?? 28.244746,
          mylocation?.longitude ?? 77.140898,
        ),
        builder: (ctx) => GestureDetector(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      spreadRadius: 7.0,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
          onTap: () {},
        ),
      );
    }
  }

  startvehicle(String imei) async {
    isprocess.value = true;
    debugPrint('Start Vehicle $imei');

    await Future.delayed(const Duration(seconds: 3), () {
      debugPrint("waiting for 5 seconds");
    });

    var url = FleetStack.url.substring(0, FleetStack.url.length - 1);
    // debugPrint(url);

    Map<String, dynamic> postdata = {};
    postdata["imei"] = imei;
    postdata["Isonof"] = 1;
    postdata["url"] = url;

    var result = await FleetStack.patchauthdata('immobilizDevice', postdata);
    debugPrint(result);
    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);
      debugPrint(data.toString());
      if (data.isNotEmpty) {
        List<dynamic> retrievalList =
            jsonDecode(data[0]["data"]).entries.toList();
        processresult.value = retrievalList[0].value;
        // showvehicles();
      } else {
        processresult.value = "unable to fatch the result.";
      }
      // if (data[0]["error"] == 1) {
      //   // isparking.value = status;
      //
      //    // Get.snackbar("success".tr, "parking_mode_enabled".tr);
      //
      //
      //  // showvehicles();
      //
      // }
      // else if(data[0]["error"] == 0){
      //   Get.snackbar("result".tr, data[0]["msg"]);
      //   return;
      // }
    }

    isprocess.value = false;
  }

  stopvehicle(String imei) async {
    isprocess.value = true;
    debugPrint('Stop Vehicle $imei');

    await Future.delayed(const Duration(seconds: 3), () {
      debugPrint("waiting for 5 seconds");
    });

    var url = FleetStack.url.substring(0, FleetStack.url.length - 1);
    // debugPrint(url);

    Map<String, dynamic> postdata = {};
    postdata["imei"] = imei;
    postdata["Isonof"] = 0;
    postdata["url"] = url;

    var result = await FleetStack.patchauthdata('immobilizDevice', postdata);
    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);
      debugPrint(data.toString());
      if (data.isNotEmpty) {
        List<dynamic> retrievalList =
            jsonDecode(data[0]["data"]).entries.toList();
        processresult.value = retrievalList[0].value;
        //showvehicles();
      } else {
        processresult.value = "unable to fatch the result.";
      }
    }

    isprocess.value = false;
  }

  /// MAULIK
  /*List<LatLng> latLongListM = [
    LatLng(27.605466, 75.771649),
  ];

  LatLng loc1M = LatLng(27.605466, 75.771649);*/
  List<LatLng> pointsM = [];

  // int pos = 1;

  int numDeltasM = 50; //number of delta to devide total distance
  int delayM = 100; //milliseconds of delay to pass each delta
  var iM = 0;
  double? deltaLatM;
  double? deltaLngM;

  // ignore: prefer_typing_uninitialized_variables
  var positionM; //position variable while moving marker

  late LatLng pos1M; //positions for polylines
  late LatLng pos2M;

  onChangeValueM() {
    var result = [latLongListM[0].latitude, latLongListM[0].longitude];
    transitionM(result);
  }

  transitionM(result) {
    iM = 0;
    deltaLatM = (result[0] - positionM[0]) / numDeltasM;
    deltaLngM = (result[1] - positionM[1]) / numDeltasM;
    moveMarkerM();
  }

  bool isCompleted = false;

  moveMarkerM() {
    positionM[0] += deltaLatM;
    positionM[1] += deltaLngM;
    var latlng = LatLng(positionM[0], positionM[1]);

    mapController.move(
      latlng,
      mapController.zoom,
    );

    loc1M = latlng;
    point.value = latlng;
    pointM.value = latlng;

    pointsM.add(loc1M!);
    lineM.value.add(loc1M!);

    pos1M = pos2M;
    pos2M = LatLng(positionM[0], positionM[1]);

    update(['UpdateView']);

    if (iM != numDeltasM) {
      iM++;
      // debugPrint("iM -->> $iM");
      Future.delayed(Duration(milliseconds: delayM), () {
        moveMarkerM();
      });
    } else {
      isCompleted = true;
    }
    debugPrint("isCompleted -->> $isCompleted");
  }
}
