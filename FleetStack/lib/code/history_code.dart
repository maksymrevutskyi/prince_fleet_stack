import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

import '../common/FleetStack.dart';
import '../common/widgets.dart';
import '../ui/history.dart';

class history_code extends GetxController {
  late MapController mapController;
  final mymaplocation = Rxn<Marker>();
  Rx<List<dynamic>> filterlist = Rx([]);

  late PanelController slidecontroller = new PanelController();

  final isgeofence = true.obs;
  final ispoi = true.obs;
  final ismylocation = false.obs;
  final isstoppage = true.obs;
  var tile =
      "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;
  final currentlanguage = "en_US".obs;

  Rx<LatLng> point = Rx(LatLng(24.650683, 76.978658));
  var points = [];
  Rx<List<Marker>> locationmarker = Rx([]);
  Rx<List<LatLng>> line = Rx([]);
  Rx<List<LatLng>> postline = Rx([]);
  Rx<List<Marker>> stopage = Rx([]);
  Rx<List<Map<String, dynamic>>> rawdata = Rx([]);

  final selectedvehicle = 0.obs;
  Rx<List<Map<String, dynamic>>> vehiclelist = Rx([]);
  var fromdtselection = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00)
      .obs;
  var todtselection = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 58)
      .obs;
  var isloading = false.obs;

  final runningtimestr = "".obs;
  final stoptimestr = "".obs;
  final totalkm = 0.0.obs;

  final status = "Running".obs;
  final vtype = "car".obs;
  final vnumber = "".obs;
  final address = "".obs;

  //for Poi
  Rx<List<Marker>> poimarkers = Rx([]);
  Rx<List<CircleMarker>> poipolycircle = Rx([]);

  //for geofence
  Rx<List<Polygon>> polygons = Rx([]);
  Rx<List<Polyline>> polylines = Rx([]);
  Rx<List<CircleMarker>> polycircle = Rx([]);

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

    mapController = MapController();
    // if (slidecontroller.isAttached) {
    //   slidecontroller.hide();
    // }

    localsetting();

    Future.delayed(Duration(milliseconds: 500), () {
      filterSheet(Get.context!);
      slidecontroller.hide();
    });
  }

  void localsetting() async {
    isgeofence.value =
        (await FleetStack.getlocal("isgeofence") == 'false') ? false : true;
    ispoi.value =
        (await FleetStack.getlocal("ispoi") == 'false') ? false : true;
    ismylocation.value =
        (await FleetStack.getlocal("ismylocation") == 'true') ? true : false;
    isstoppage.value =
        (await FleetStack.getlocal("isstoppage") == 'false') ? false : true;
    final String temptile = await FleetStack.getlocal("tile");
    tile.value = temptile.length > 0
        ? temptile.toString()
        : "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}";

    String languagevalue = await FleetStack.getlocal("language");
    currentlanguage.value = languagevalue == '' ? "en_US" : languagevalue;
    initializeDateFormatting(currentlanguage.value);

    fillvehiclelist();

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

  Widget customdropdown(
      {required int currentvalue, required List<Map<String, dynamic>> list}) {
    return Expanded(
      child: Container(
        // width:  double.infinity,

        child: DropdownButton<int>(
          iconSize: 30,
          // focusColor: appcolor.runninglight,
          alignment: Alignment.center,
          value: currentvalue,
          onChanged: (int? newValue) {
            if (newValue != null) {
              selectedvehicle.value = newValue!;
            }
          },
          items: [
            DropdownMenuItem<int>(
              value: 0,
              child: Text("Select Vehicle"),
            ),
            ...list.map((Map<String, dynamic> vehicle) {
              return DropdownMenuItem<int>(
                value: vehicle["deviceid"],
                child: Text(vehicle["vehicleno"]),
              );
            }),
          ],
        ),
      ),
    );
  }

  fillvehiclelist() async {
    var data = await FleetStack.getauthdata('getDevices');
    if (data["respcode"] == true) {
      var vlist = await FleetStack.stringtojson(data["data"]);
      vehiclelist.value = List<Map<String, dynamic>>.from(vlist);
    }
  }

  Future<void> showresult() async {
    isloading.value = true;
    final difference =
        todtselection.value.difference(fromdtselection.value).inHours;
    print('printing the final gap ${difference}');
    if (selectedvehicle.value == 0) {
      Get.snackbar('input_validation'.tr, 'kindly_select_vehicle'.tr);
      isloading.value = false;
      return;
    }
    if (difference > 72) {
      Get.snackbar(
          'input_validation'.tr, 'you_have_selected_more_then_days'.tr);
      isloading.value = false;
      return;
    } else if (difference == 0 || difference < 0) {
      Get.snackbar(
          'input_validation'.tr, 'todate_should_be_greater_than_fromdate'.tr);
      isloading.value = false;
      return;
    }

    var fromdate = Uri.encodeComponent(fromdtselection.value.toString())
        .replaceAll(".000", "");
    var todate = Uri.encodeComponent(todtselection.value.toString())
        .replaceAll(".000", "");

    clearpage();

    var vdetails = await FleetStack.getauthdata(
        'getDeviceDeta?Deviceid=${selectedvehicle.value}');

    if (vdetails["respcode"] == true) {
      var vdata = await FleetStack.stringtojson(vdetails["data"]);
      status.value = vdata[0]["status"];
      vtype.value = vdata[0]["vehicletype"];
      vnumber.value = vdata[0]["vehicleno"];
      address.value = vdata[0]["address"];
    }

    //var requestdate = Uri.encodeComponent(dtselection.value.toString()).replaceAll(".000", "");

    // var fromdate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(dtselection.value)} 00:00:00');
    // var todate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(dtselection.value)} 23:58:00');

    var result = await FleetStack.getauthdata(
        'getHistoryReplayDta?deviceid=${selectedvehicle.value}&startdt=${fromdate}&enddt=${todate}');

    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);

      if (data.length > 0) {
        rawdata.value = List<Map<String, dynamic>>.from(data);

        bindmapdata(data);
        print('Printing main data');
        print(data);

        // point.value = LatLng(data[0]["lat"], data[0]["lon"]);

        var refinedata = await FleetStack.refinedata(data, 5);

        print('Printing data from machine');
        print(refinedata);

        if (refinedata.length > 0) {
          filterlist.value.add({
            "type": 2,
            "device_dt": DateTime.parse(data[0]["device_dt"].toString()),
            "motion": data[0]["motion"],
            "address": data[0]["address"],
            "lat": data[0]["lat"],
            "lon": data[0]["lon"],
          });

          stopage.value.add(
            Marker(
                point: LatLng(data[0]["lat"], data[0]["lon"]),
                builder: (context) => Image.asset(
                      'assets/images/start-point.png',
                      width: 32,
                      height: 32,
                    )),
          );

          stopage.value.add(
            Marker(
                point: LatLng(
                    data[data.length - 1]["lat"], data[data.length - 1]["lon"]),
                builder: (context) => Image.asset(
                      'assets/images/end-point.png',
                      width: 32,
                      height: 32,
                    )),
          );

          totalkm.value = 0.0;
          // runningtime.value = 0.0;
          // stoptime.value = 0.0;
          double runningtime = 0.0;
          double stoptime = 0.0;

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
                "maxspeed": refinedata[i][6],
              });

              totalkm.value += double.parse(refinedata[i][6].toString());
              runningtime += double.parse(refinedata[i][8].toString());
            } else {
              filterlist.value.add({
                "type": 0,
                "duration": refinedata[i][8],
                "fromdate": DateTime.parse(refinedata[i][2]),
                "todate": DateTime.parse(refinedata[i][3]),
                "address": data[refinedata[i][1]]["address"],
                "lat": data[refinedata[i][1]]["lat"],
                "lon": data[refinedata[i][1]]["lon"],
              });

              stopage.value.add(
                Marker(
                    point: LatLng(data[refinedata[i][1]]["lat"],
                        data[refinedata[i][1]]["lon"]),
                    builder: (context) => Image.asset(
                          'assets/images/stop-point.png',
                          width: 32,
                          height: 32,
                        )),
              );
            }
          }

          filterlist.value.add({
            "type": 3,
            "device_dt": DateTime.parse(data[data.length - 1]["device_dt"]),
            "motion": data[data.length - 1]["motion"],
            "address": data[data.length - 1]["address"],
            "lat": data[data.length - 1]["lat"],
            "lon": data[data.length - 1]["lon"],
          });

          Duration diff = DateTime.parse(data[data.length - 1]["device_dt"])
              .difference(DateTime.parse(data[0]["device_dt"]));

          stoptime = (diff.inSeconds / 60).ceil() - runningtime;

          int tempstop = stoptime.toInt();
          int temprunning = runningtime.toInt();

          runningtimestr.value = FleetStack.mintostr(temprunning);
          stoptimestr.value = FleetStack.mintostr(tempstop);

          totalkm.value = totalkm.value / 1000;

          mapController.move(point.value, mapController.zoom);
        }

        isloading.value = false;

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(Get.context!);
        });

        slidecontroller.show();

        print("refinedata filterlist");
        print(filterlist);
      } else {
        Get.snackbar('result'.tr, 'no_result'.tr);
      }
    }

    isloading.value = false;
  }

  clearpage() {
    status.value = "";
    vtype.value = "";
    vnumber.value = "";
    address.value = "";
    filterlist.value = [];
    totalkm.value = 0.0;
    runningtimestr.value = "";
    stoptimestr.value = "";
    line.value = [];
    stopage.value = [];
    rawdata.value = [];
    postline.value = [];
    slidecontroller.hide();
  }

  Future<void> bindmapdata(List<dynamic> result) async {
    for (var i = 0; i < result.length; i++) {
      line.value.add(LatLng(result[i]["lat"], result[i]["lon"]));

      var temppoint = [result[i]["lat"], result[i]["lon"]];
      points.add(temppoint);
    }

    var ak = await FleetStack.getCenterFromDegrees(points);
    point.value = ak;
  }

  drawoutline(DateTime fromtime, DateTime totime) async {
    //postline
    print(fromtime);
    print(fromtime.runtimeType);
    print(totime);

    postline.value = [];
    points = [];

    for (var i = 0; i < rawdata.value.length; i++) {
      var currentdt = DateTime.parse(rawdata.value[i]["device_dt"].toString());

      if (currentdt.compareTo(fromtime) >= 0 &&
          currentdt.compareTo(totime) <= 0) {
        postline.value
            .add(LatLng(rawdata.value[i]["lat"], rawdata.value[i]["lon"]));

        var temppoint = [rawdata.value[i]["lat"], rawdata.value[i]["lon"]];
        points.add(temppoint);
      }
    }

    var ak = await FleetStack.getCenterFromDegrees(points);
    point.value = ak;

    if (mapController.zoom > 12) {
      mapController.move(point.value, mapController.zoom - 4);
    } else {
      mapController.move(point.value, mapController.zoom);
    }

    slidecontroller.close();
  }

  showpoi() async {
    var result = await FleetStack.getauthdata('PoiAllList');

    if (result["respcode"] == true) {
      var poidata = FleetStack.stringtojson(result["data"]);

      print('Printing Poi Data');
      print(poidata);

      if (poidata.length > 0) {
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
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Type:".tr),
                                    SizedBox(width: 25),
                                    Text(poidata[i]["pcatname"])
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Title:".tr),
                                    SizedBox(width: 25),
                                    Text(poidata[i]["title"])
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Details:".tr),
                                    SizedBox(width: 25),
                                    Text(poidata[i]["des"])
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Radius:".tr),
                                    SizedBox(width: 25),
                                    Text('${poidata[i]["pmeter"]} Meters')
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Created at:".tr),
                                    SizedBox(width: 25),
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
      if (geodata.length > 0) {
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
              isFilled: true, // By default it's false
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
                padding: EdgeInsets.all(6),
              ),
            ],
          ),
          onTap: () {},
        ),
      );
    }
  }
}
