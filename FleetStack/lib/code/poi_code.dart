import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../common/FleetStack.dart';

class poi_code extends GetxController{

  late MapController mapController;
  var tile = "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;

  var all = [].obs;

  Rx<List<Marker>> markers = Rx([]);
  Rx<List<CircleMarker>> polycircle = Rx([]);
  Rx<LatLng> point = Rx(LatLng(12.650683, 65.978658));



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    mapController = MapController();

    // Future.delayed(Duration(seconds: 8), () {
    //   displaypoi();
    // });

   displaypoi();

  }

  displaypoi() async {


    var result = await FleetStack.getauthdata('PoiAllList');

    if(result["respcode"] ==  true)
    {
      var poidata = FleetStack.stringtojson(result["data"]);

      print('Printing Poi Data');
      print(poidata);

      if(poidata.length >0){

        all.value = [];
        markers.value = [];
        polycircle.value = [];

        List<LatLng> allpoi = [];

        for (int i=0; i< poidata.length; i++)
        {
          List<String> startstr = poidata[i]["startstr"].split(",");
          double ilat = double.parse(startstr[1]);
          double ilon = double.parse(startstr[0]);


          all.value.add(
              {
                "id": poidata[i]["pid"],
                "name": poidata[i]["title"],
                "geocolor": Color(int.parse(poidata[i]["color"].substring(1, 7), radix: 16) + 0xFF000000),
                "des": poidata[i]["des"],
                "category": poidata[i]["pcatname"],
                "distance": poidata[i]["pmeter"],
                "coordinates": LatLng(ilat, ilon),
              }
          );

          markers.value.add(
            Marker(
              point: LatLng(
               ilat,
                ilon,
              ),
              builder: (context) =>
                  Image.asset(
                    'assets/images/poi-marker.png',
                    width: 15,
                    height: 15,
                    fit: BoxFit.cover,
                  )
            )
          );

          polycircle.value.add(
              CircleMarker(
                  point: LatLng(ilat, ilon),
                  color: Color(int.parse(poidata[i]["color"].substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.7),
                  borderStrokeWidth: 2,
                  borderColor: Color(int.parse(poidata[i]["color"].substring(1, 7), radix: 16) + 0xFF000000),
                  useRadiusInMeter: true,
                  radius: poidata[i]["pmeter"] // 2000 meters | 2 km
              )

          );

          allpoi.add(
            LatLng(ilat, ilon),
          );

      // Add markers and poly circle







         // listpolypoints.value.add(coordinates);

        }

        point.value = FleetStack.GeoPointCenter(allpoi);

      }


    }


    mapController.move(point.value, mapController.zoom);



  }

  focuspoi( int id){
    print("focusing the geofence by id : ${id}");

    for(int i=0; i<  all.value.length; i++){
      if(all[i]["id"] == id){
        point.value = all[i]["coordinates"];
      }
    }

   // point.value = FleetStack.GeoPointCenter(coordinates);

    mapController.move(point.value, 15);

  }


  delpoi( int id)  async{

    print('deleteing the ${id}');


    Map<String, dynamic> postdata = {};
    postdata["poiid"] = id.toString();

    var result = await FleetStack.delauthdata('DelPoiByID', postdata);
    print(result);
    if(result["respcode"] == true)
    {
      Get.snackbar( "deleted".tr, "deleted_successfully".tr );
      displaypoi();
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

}