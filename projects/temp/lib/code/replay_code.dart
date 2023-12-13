import 'dart:async';
import 'package:ripple_wave/ripple_wave.dart';

import '/common/FleetStack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../common/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class replay_code extends GetxController {
  late MapController mapController;
  var tile = "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;
  Rx<LatLng> point = Rx(LatLng(24.650683, 76.978658));
  final mymaplocation = Rxn<Marker>();
  Rx<List<LatLng>> line = Rx([]);
  Rx<List<LatLng>> preline = Rx([]);
  var details;



  final isgeofence = true.obs;
  final ispoi = true.obs;
  final isripple = true.obs;
  final ismylocation = false.obs;
  final isstoppage = true.obs;
  final istrackline = true.obs;
  final currentlanguage = "en_US".obs;

  Rx<Marker> current = Rx(Marker(
      point: LatLng(24.650683, 76.978658),
      builder: (context) => Icon(
            Icons.location_on,
            color: Colors.transparent,
            size: 35,
          )));

  Rx<List<Marker>> stopage = Rx([]);
  // Rx<List<Marker>> locationmarker = Rx([]);

  final List<Map<String, dynamic>> filterlist = [];
  final slider = Rx<double>(1);
  final maxslider = Rx<double>(100.0);

  final isplay = false.obs;
  final playindex = Rx<double>(2.0);
  late Timer playtimer;
  final playspeed = 400.obs;
  final replaydate = "".obs;
  final replaytime = "".obs;
  final replayspeed = "".obs;
  final replaykm = "".obs;
  final replayaddress = "".obs;




  final selectedvehicle = 0.obs;
  Rx<List<Map<String, dynamic>>> vehiclelist = Rx([]);
  var fromdtselection = DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 00,00 ).obs;
  var todtselection = DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 23,58 ).obs;
  var isloading = false.obs;


  //for geofence
  Rx<List<Polygon>> polygons = Rx([]);
  Rx<List<Polyline>> polylines = Rx([]);
  Rx<List<CircleMarker>> polycircle = Rx([]);

  //for Poi
  Rx<List<Marker>> poimarkers = Rx([]);
  Rx<List<CircleMarker>> poipolycircle = Rx([]);


  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    mapController = MapController();
    // update();
    fillvehiclelist();

  }

  tracking(deviceid) async {
    print(deviceid);
    details = deviceid.split(',');

    localsetting();

    if(details[0].toString() == '0')
      {
        point.value = LatLng(double.parse(details[1]), double.parse(details[2]));

      }

    else
      {
        selectedvehicle.value = int.parse(details[0].toString());
        var fromdate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(DateTime.now())} 00:00:00');
        var todate = Uri.encodeComponent('${DateFormat(appcolor.appinputdate).format(DateTime.now())} 23:58:00');

        point.value = LatLng(double.parse(details[1]), double.parse(details[2]));
        current.value = Marker(
          height:35,
          width: 35,
          point: LatLng(double.parse(details[1]), double.parse(details[2])),
          builder: (context) =>
          isripple.value == true?
          RippleWave(
              color: appcolor.runningripple,
              child:   Image.asset(
                'assets/images/icons/${details[4]}Running.png',
                // 'assets/images/icons/${details[4]}${details[3]}.png',
                width: 30,
                height: 30,
              )
          )

              :  Image.asset(
            'assets/images/icons/${details[4]}Running.png',
            // 'assets/images/icons/${details[4]}${details[3]}.png',
            width: 30,
            height: 30,
          ) ,
        );
       // var result = await FleetStack.getauthdata('getHistoryReplayDta?deviceid=${details[0]}&startdt=2023-01-10%2000%3A00%3A00&enddt=2023-01-10%2022%3A00%3A00');
        var result = await FleetStack.getauthdata('getHistoryReplayDta?deviceid=${details[0]}&startdt=${fromdate}&enddt=${todate}');

        binddata(result);
      }




  }

  localsetting() async {
     isgeofence.value =  (await FleetStack.getlocal("isgeofence") == 'false')?false:true;
    ispoi.value = (await FleetStack.getlocal("ispoi") == 'false')?false:true;
    isripple.value = (await FleetStack.getlocal("isripple") == 'false')?false:true;
     ismylocation.value = (await FleetStack.getlocal("ismylocation") == 'true') ? true : false;
     isstoppage.value = (await FleetStack.getlocal("isstoppage") == 'false')?false:true;
     istrackline.value = (await FleetStack.getlocal("istrackline") == 'false')?false:true;



     String languagevalue = await FleetStack.getlocal("language");
     currentlanguage.value = languagevalue == ''?"en_US": languagevalue;
     initializeDateFormatting(currentlanguage.value);


     if(ismylocation.value){
       showlocation();
     }
     if(isgeofence.value) {
       showgeofence();
     }

     if(ispoi.value) {
       showpoi();
     }

  }


  replaydrawline(double spoint) {


    if(filterlist.length == 0)
      {
        Get.snackbar('replay'.tr, 'no_data'.tr);
        isplay.value = false;
        playtimer.cancel();
        return;
      }

    playindex.value = spoint;
    int a = spoint.floor();
    line.value.clear();

    for (var i = 0; i < a; i++) {
      // line.value.add( LatLng(list[i].latitude, list[i].longitude));
      line.value.add(LatLng(
          filterlist[i]["latlon"].latitude, filterlist[i]["latlon"].longitude));
    }

    //point.value = LatLng(list[a].latitude, list[a].longitude);
    point.value = LatLng(filterlist[a - 1]["latlon"].latitude,
        filterlist[a - 1]["latlon"].longitude);
    mapController.move(point.value, mapController.zoom);

    print('assets/images/icons/${details[4]}running.png');
    current.value = Marker(
       height: isripple.value == false?30:90,
        width:  isripple.value == false?30:90,
        point: LatLng(filterlist[a - 1]["latlon"].latitude,
            filterlist[a - 1]["latlon"].longitude),
        builder: (context) =>  Transform.rotate(
          // angle: FleetStack.angle(filterlist[a-1]["latlon"].latitude, filterlist[a-1]["latlon"].longitude, filterlist[a]["latlon"].latitude, filterlist[a]["latlon"].longitude),
          angle: FleetStack.bearing(
              filterlist[a - 2]["latlon"].latitude,
              filterlist[a - 2]["latlon"].longitude,
              filterlist[a - 1]["latlon"].latitude,
              filterlist[a - 1]["latlon"].longitude),
          // angle: 15,
          child:
          isripple.value == true?
          RippleWave(
            color: appcolor.runningripple,
            child:  Image.asset(
              'assets/images/icons/${details[4]}Running.png',
              width: 30,
              height: 30,
            ),
          ):  Image.asset(
            'assets/images/icons/${details[4]}Running.png',
            width: 30,
            height: 30,
          ),

        ),

    );

    print(filterlist[a]);

   // replaydate.value = filterlist[a]["ddate"].toString();
    replaydate.value =  DateFormat(appcolor.applongdate, currentlanguage.value).format(DateTime.parse(filterlist[a]["device_dt"]));
    replaytime.value = filterlist[a]["dtime"].toString();
    replayspeed.value = '${filterlist[a]["speed"].toString()} km/hr';
    replaykm.value = filterlist[a]["meter"].toString();
    replayaddress.value = filterlist[a]["address"].toString();
  }

  play_pause() {
    if (isplay.value) {
      print('start playing from index ${playindex.value}');
      print("start playing the replay");
      playtimer = Timer.periodic(
          Duration(milliseconds: playspeed.value),
          (timer) => {
                replaydrawline(playindex.value),
                playindex.value++,
                slider.value = playindex.value,
                if (playindex.value >= maxslider.value)
                  {
                    playtimer.cancel(),
                    slider.value = 1,
                    playindex.value = 2,
                    isplay.value = false,
                  }
              });
    } else {
      print('pause at index ${playindex.value}');
      print('Pause to play....');
      playtimer.cancel();
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


  fillvehiclelist() async{
    var data = await FleetStack.getauthdata('getDevices');
    if(data["respcode"] == true)
      {
        var vlist = await FleetStack.stringtojson(data["data"]);
        vehiclelist.value =  List<Map<String, dynamic>>.from(vlist);
      }
  }


 Widget customdropdown(  {required int currentvalue , required List<Map<String, dynamic>> list }) {
    return Expanded(
      child: Container(
       // width:  double.infinity,

        child: DropdownButton<int>(
          iconSize: 30,
          // focusColor: appcolor.runninglight,
          alignment: Alignment.center,
          value: currentvalue,
          onChanged:    (int? newValue) {
                 if(newValue !=null) {
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


 Future<void> showresult()  async {
    isloading.value = true;
    final difference = todtselection.value.difference(fromdtselection.value).inHours;
    print('printing the final gap ${difference}');
    if(selectedvehicle.value == 0)
      {
        Get.snackbar('input_validation'.tr, 'kindly_select_vehicle'.tr);
        isloading.value = false;
        return;
      }
    if(difference > 72)
      {
        Get.snackbar('input_validation'.tr, 'you_have_selected_more_then_days'.tr);
        isloading.value = false;
        return;
      }
    else if( difference == 0 || difference < 0)
      {
        Get.snackbar('input_validation'.tr, 'todate_should_be_greater_than_fromdate'.tr);
        isloading.value = false;
        return;
      }

    var fromdate = Uri.encodeComponent(fromdtselection.value.toString()).replaceAll(".000", "");
    var todate = Uri.encodeComponent(todtselection.value.toString()).replaceAll(".000", "");


    var result = await FleetStack.getauthdata(
        'getHistoryReplayDta?deviceid=${selectedvehicle.value}&startdt=${fromdate}&enddt=${todate}');

     clearpage();



    await binddata(result);
    isloading.value = false;

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(Get.context!);
    });




  }



  Future<void> binddata(Map<String, dynamic> result)  async{


    playtimer = Timer.periodic(Duration(milliseconds: 2), (timer) {
    });
    playtimer.cancel();


    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);

      if(data.length > 0)
      {

        maxslider.value = data.length.toDouble();


        point.value = LatLng(data[0]["lat"], data[0]["lon"]);
        current.value = Marker(
          height:35,
          width: 35,
          point: point.value,
          builder: (context) =>
          isripple.value == true?
          RippleWave(
              color: appcolor.runningripple,
              child:   Image.asset(
                'assets/images/icons/${data[0]["VehicleType"]}Running.png',
                // 'assets/images/icons/${details[4]}${details[3]}.png',
                width: 30,
                height: 30,
              )
          )

              :  Image.asset(
            'assets/images/icons/${data[0]["VehicleType"]}Running.png',
            // 'assets/images/icons/${details[4]}${details[3]}.png',
            width: 30,
            height: 30,
          ) ,
        );

        mapController.move(point.value, mapController.zoom);


        var totalkm = 0.0;
        for (var i = 0; i < data.length; i++) {
          totalkm += double.parse(data[i]["meter"].toString());
          filterlist.add({
            "device_dt": data[i]["device_dt"],
            "speed": data[i]["speed"],
            "meter": '${(totalkm / 1000).toStringAsFixed(2)} KM',
            //"meter": data[i]["meter"],
            "ddate": data[i]["ddate"],
            "dtime": data[i]["dtime"],
            "motion": data[i]["motion"],
            "address": data[i]["address"],
            "latlon": LatLng(data[i]["lat"], data[i]["lon"])
          });

          preline.value.add(LatLng(data[i]["lat"], data[i]["lon"]));
        }


        var refinedata = await FleetStack.refinedata(data, 5);


          if (refinedata.length > 0) {
            print("data refined and stopage binding");
            for (var i = 0; i < refinedata.length; i++) {
              if (refinedata[i][4] == false) {
                var listindex = refinedata[i][1];
                stopage.value.add(Marker(
                    point: LatLng(filterlist[listindex]["latlon"].latitude,
                        filterlist[listindex]["latlon"].longitude),
                    builder: (context) =>
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/stop-point.png',
                            width: 35,
                            height: 35,
                          ),

                          onTap: () {
                            Get.defaultDialog(
                                barrierDismissible: true,
                                title: 'Stopage Information',
                                content: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("arrival".tr),
                                          SizedBox(width: 25),
                                          Text(DateFormat(appcolor.appdatetime,
                                              currentlanguage.value).format(
                                              DateTime.parse(refinedata[i][2])))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text("departure".tr),
                                          SizedBox(width: 25),
                                          // Text(refinedata[i][3]),
                                          Text(DateFormat(appcolor.appdatetime,
                                              currentlanguage.value).format(
                                              DateTime.parse(refinedata[i][3]))),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text("stay_time".tr),
                                          SizedBox(width: 25),
                                          Text(FleetStack.mintostr(
                                              refinedata[i][8])),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text("Lat/Lon :"),
                                          SizedBox(width: 25),
                                          Text('${filterlist[listindex]["latlon"]
                                              .latitude} / ${filterlist[listindex]["latlon"]
                                              .longitude} ')
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [

                                          Text('address'.tr),
                                          SizedBox(width: 25),
                                          Container(
                                            width: 180,
                                            child: Text(
                                                filterlist[listindex]["address"]),
                                          )


                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            );
                          },
                        )));
              }
            }
          }

          update();

      }
    }

  }



 Future<void> clearpage() async {

   point.value = LatLng(24.650683, 76.978658);

   current.value = Marker(
       point: LatLng(24.650683, 76.978658),
       builder: (context) => Icon(
         Icons.location_on,
         color: Colors.transparent,
         size: 35,
       ));

   playindex.value = 2.0;
   filterlist.clear();
   preline.value = [];
   line.value = [];
   stopage.value = [];
   slider.value = 1;
   maxslider.value= 100;
   isplay.value =false;
   playindex.value = 2;
   if(playtimer.isActive){ playtimer.cancel(); }


 }


  showgeofence() async {

    var result = await FleetStack.getauthdata('GeofanceAllList');
    if(result["respcode"] ==  true)
    {
      var geodata = FleetStack.stringtojson(result["data"]);
      if(geodata.length >0){

        polygons.value = [];
        polylines.value = [];
        polycircle.value = [];
        for (int i=0; i< geodata.length; i++)
        {
          List<LatLng> coordinates = geodata[i]["startstr"].split("\$").map((coord) => LatLng(double.parse(coord.split(",")[1]), double.parse(coord.split(",")[0]))).toList().cast<LatLng>();

          if(geodata[i]["geotype"] == 3)
          {
            polylines.value.add(
              Polyline(
                points:coordinates,
                strokeWidth: 4,
                color: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000),
              ),
            );

          }
          if(geodata[i]["geotype"] == 2)
          {
            polygons.value.add(
                Polygon(
                  points: coordinates,
                  isFilled: true, // By default it's false
                  borderColor: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000),
                  color: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.2),
                  borderStrokeWidth: 1,
                  label: geodata[i]["geofname"],
                )
            );
          }

          if(geodata[i]["geotype"] == 1)
          {
            polycircle.value.add(
              CircleMarker(
                  point: coordinates[0] ,
                  color: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.2),
                  borderStrokeWidth: 2,
                  borderColor: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000),
                  useRadiusInMeter: true,
                  radius: geodata[i]["geodistance"] // 2000 meters | 2 km
              ),
            );


          }
        }
      }
    }
  }

  showpoi() async{

    var result = await FleetStack.getauthdata('PoiAllList');

    if(result["respcode"] ==  true)
    {
      var poidata = FleetStack.stringtojson(result["data"]);

      print('Printing Poi Data');
      print(poidata);

      if(poidata.length >0){


        poimarkers.value = [];
        poipolycircle.value = [];



        for (int i=0; i< poidata.length; i++)
        {
          List<String> startstr = poidata[i]["startstr"].split(",");
          double ilat = double.parse(startstr[1]);
          double ilon = double.parse(startstr[0]);

          poimarkers.value.add(
              Marker(
                  height: 15,
                  width: 15,
                  point: LatLng(
                    ilat,
                    ilon,
                  ),
                  builder: (context) =>
                      GestureDetector(
                        child: Image.asset(
                          'assets/images/poi-marker.png',
                        ),
                        onTap: (){
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
                                            currentlanguage.value).format(
                                            DateTime.parse(poidata[i]["createdate"])))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                      )
              )
          );

          poipolycircle.value.add(
              CircleMarker(
                  point: LatLng(ilat, ilon),
                  color: Color(int.parse(poidata[i]["color"].substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.7),
                  borderStrokeWidth: 2,
                  borderColor: Color(int.parse(poidata[i]["color"].substring(1, 7), radix: 16) + 0xFF000000),
                  useRadiusInMeter: true,
                  radius: poidata[i]["pmeter"] // 2000 meters | 2 km
              )

          );

        }

      }

    }

  }

  showlocation() async{
    var mylocation =  await FleetStack.currentLocation();
    if(mylocation?.latitude != null && mylocation?.longitude != null)
    {
      mymaplocation.value =   Marker(
        height: 35,
        width: 35,
        point: LatLng(
          mylocation?.latitude ?? 28.244746,
          mylocation?.longitude ?? 77.140898,
        ),
        builder: (ctx) =>
            GestureDetector(
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
              onTap: (){

              },
            ),

      );

    }
  }


}
