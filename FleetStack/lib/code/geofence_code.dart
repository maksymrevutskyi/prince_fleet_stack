import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../common/FleetStack.dart';

class geofence_code extends GetxController{

  late MapController mapController;
  var tile = "http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}".obs;
 //  Rx<List<Map<String, dynamic>>> all = Rx([]);
 var all = [].obs;
 Rx<List<Polygon>> polygons = Rx([]);
  Rx<List<Polyline>> polylines = Rx([]);
  Rx<List<CircleMarker>> polycircle = Rx([]);

 Rx<List<List<LatLng>>>  listpolypoints = Rx([]);
 Rx<LatLng> point = Rx(LatLng(12.650683, 65.978658));



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    mapController = MapController();

     displaygeo();

  }

  displaygeo() async {
    print("showing the geofence");

    var result = await FleetStack.getauthdata('GeofanceAllList');

    if(result["respcode"] ==  true)
      {
         var geodata = FleetStack.stringtojson(result["data"]);
         print(geodata);

         if(geodata.length >0){

           all.value = [];
           polygons.value = [];
           listpolypoints.value = [];

           for (int i=0; i< geodata.length; i++)
             {


               List<LatLng> coordinates = geodata[i]["startstr"].split("\$").map((coord) => LatLng(double.parse(coord.split(",")[1]), double.parse(coord.split(",")[0]))).toList().cast<LatLng>();
              print('printing for ${i} the list Latlng\n');
               print(coordinates);

               all.value.add(
                   {
                     "id": geodata[i]["geofid"],
                     "type": geodata[i]["geotype"],
                     "name": geodata[i]["geofname"],
                     "geocolor": Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000),
                     "des": geodata[i]["geofdetail"],
                     "distance": geodata[i]["geodistance"],
                     "coordinates": coordinates,
                     // "polgon":   Polygon(
                     //   points: coordinates,
                     //   isFilled: true, // By default it's false
                     //   borderColor: Color(int.parse(geodata[i]["displaycolor"].substring(1, 7), radix: 16) + 0xFF000000),
                     //   borderStrokeWidth: 4,
                     // ),

                   }
               );

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




               listpolypoints.value.add(coordinates);

             }



         }


      }

    print("printing the all value");
    print(all.value);

   // print(polygons.value);
    print(listpolypoints.value);

    if(listpolypoints.value.length > 0)
      {
        point.value =  FleetStack.GeoCenter(listpolypoints.value);
      }


    // print(centerresult);
    mapController.move(point.value, mapController.zoom);

  }

  focusfence( int id){
    print("focusing the geofence by id : ${id}");
    List<LatLng>  coordinates = [];
    for(int i=0; i<  all.value.length; i++){
      if(all[i]["id"] == id){
        coordinates = all[i]["coordinates"];
      }
    }

    point.value = FleetStack.GeoPointCenter(coordinates);

    mapController.move(point.value, 15);

  }


   delfence( int id)  async{

    print('deleteing the ${id}');


    Map<String, dynamic> postdata = {};
    postdata["gfid"] = id.toString();

    var result = await FleetStack.delauthdata('DelGeofanceByID', postdata);
    print(result);
    if(result["respcode"] == true)
    {
        Get.snackbar( "deleted".tr, "deleted_successfully".tr );
        displaygeo();
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