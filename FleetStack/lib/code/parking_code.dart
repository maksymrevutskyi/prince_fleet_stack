import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:ripple_wave/ripple_wave.dart';
import '../common/widgets.dart';

import '../common/FleetStack.dart';

class parking_code extends GetxController{

  late MapController mapController;
  RxList<Marker> markers = <Marker>[].obs;
  var tile = "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;

  final mymaplocation = Rxn<Marker>();
  //final point = LatLng(25.2356, 78.25680);

  final islabel = true.obs;
  final isgeofence = true.obs;
  final ispoi = true.obs;
  final isripple = true.obs;
  final ismylocation = false.obs;
  final currentlanguage = "en_US".obs;
  Rx<LatLng> point = Rx(LatLng(12.650683, 65.978658));
  var points = [];
  var all = [].obs;

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
    mapController = MapController();
    super.onInit();

    showvehicles();
  }


  showvehicles() async{
    var result = await FleetStack.getauthdata('getListOfallDevice');
    getlocalsettings();
    if (result["respcode"] == true) {
      var vehiclelist = await FleetStack.stringtojson(result["data"]);

      markers.value = [];
      all.value = [];

      if(vehiclelist.length >0)
        {
          all.value = vehiclelist;

          for (var i = 0; i < vehiclelist.length; i++) {

            if( vehiclelist[i]["lastlatitude"] != null && vehiclelist[i]["lastlongitude"] != null )
              {

                final point = LatLng(
                  vehiclelist[i]["lastlatitude"],
                  vehiclelist[i]["lastlongitude"],
                );

                var temppoint = [ vehiclelist[i]["lastlatitude"],
                  vehiclelist[i]["lastlongitude"] ];
                points.add(temppoint);


                markers.add(
                  Marker(
                    height: 90,
                    width: 110,
                    point: point,
                    builder: (ctx) =>
                        GestureDetector(
                          child:   Column(
                            children: [

                              Transform.rotate(
                                // angle: FleetStack.getangle(vehiclelist[i]["preLatitude"], vehiclelist[i]["preLongitude"],
                                //     vehiclelist[i]["lastlatitude"], vehiclelist[i]["lastlongitude"]),
                                angle: FleetStack.angle(vehiclelist[i]["preLatitude"], vehiclelist[i]["preLongitude"],
                                    vehiclelist[i]["lastlatitude"], vehiclelist[i]["lastlongitude"]),
                                child:
                                isripple.value == true?

                                RippleWave(
                                  color: vehiclelist[i]["status"].toString() == "Stop"? appcolor.stopripple:
                                  vehiclelist[i]["status"].toString() == "Running"? appcolor.runningripple
                                      : appcolor.idleripple,
                                  child: Image.asset(
                                    'assets/images/icons/${vehiclelist[i]["vehicletype"]}${vehiclelist[i]["status"]}.png',
                                    width: 35,
                                    height: 35,
                                  ),
                                ):
                                Image.asset(
                                  'assets/images/icons/${vehiclelist[i]["vehicletype"]}${vehiclelist[i]["status"]}.png',
                                  width: 35,
                                  height: 35,
                                ),

                              ),

                              SizedBox(height: 5),
                              islabel.value == true?
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.7),
                                      spreadRadius: 1.0,
                                      blurRadius: 1.0,
                                    ),
                                  ],

                                ),

                                padding: EdgeInsets.only(left:5, right:5,top: 2, bottom: 2),
                                child: Text(vehiclelist[i]["vehicleno"].toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),),
                              ) :
                              Text(""),

                            ],
                          ),


                        ),
                  ),
                );


              }

          }

          var ak = await FleetStack.getCenterFromDegrees(points);
          point.value= ak;

        }

      print("printing the value of all");
     print(all.value);


    }



    mapController.move(point.value, mapController.zoom);


    

  }


  changemap(int type){
    switch (type) {
      case 1:
        tile.value = "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile', "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      case 2:
        tile.value = "http://www.google.com/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile', "http://www.google.com/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      case 3:
        tile.value = "http://www.google.com/maps/vt?lyrs=p@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile', "http://www.google.com/maps/vt?lyrs=p@189&gl=cn&x={x}&y={y}&z={z}");
        break;
      default:
        tile.value = "http://www.google.com/maps/vt?lyrs=h@189&gl=cn&x={x}&y={y}&z={z}";
        FleetStack.savelocal('tile', "http://www.google.com/maps/vt?lyrs=h@189&gl=cn&x={x}&y={y}&z={z}");
        break;
    }

  }


  getlocalsettings() async{
    islabel.value =   (await FleetStack.getlocal("islabel") == 'false')?false:true;
    isgeofence.value = (await FleetStack.getlocal("isgeofence") == 'false')?false:true;
    ispoi.value = (await FleetStack.getlocal("ispoi") == 'false')?false:true;
    isripple.value = (await FleetStack.getlocal("isripple") == 'false')?false:true;
    ismylocation.value = (await FleetStack.getlocal("ismylocation") == 'true') ? true : false;

    final String temptile = await FleetStack.getlocal("tile");
    tile.value =  temptile.length > 0? temptile.toString(): "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}";

    String languagevalue = await FleetStack.getlocal("language");
    currentlanguage.value = languagevalue == ''?"en_US": languagevalue;
    initializeDateFormatting(currentlanguage.value);

    if(ismylocation.value) {
      showlocation();
    }

    if(isgeofence.value) {
      showgeofence();
    }

    if(ispoi.value) {
      showpoi();
    }


  }


  changeparking(int deviceid, bool status) async{
    print('changing the parking for ${deviceid} for the status ${status}');


    var parking = (status)?"1":"0";

    Map<String, dynamic> postdata = {};
    postdata["deviceid"] = deviceid;
    postdata["status"] = parking;

    var result = await FleetStack.patchauthdata('ParkingOnOFF', postdata);
    print(result);
    if (result["respcode"] == true) {
      var data = FleetStack.stringtojson(result["data"]);
      if (data[0]["error"] == 1) {
       // isparking.value = status;
        if(status)
        {
          Get.snackbar("success".tr, "parking_mode_enabled".tr);
        }
        else{
          Get.snackbar("success".tr, "parking_mode_disable".tr);
        }
        showvehicles();

      }
      else if(data[0]["error"] == 0){
        Get.snackbar("result".tr, data[0]["msg"]);
        return;
      }
    }

   print(all.value);
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