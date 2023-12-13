import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../code/parking_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';

class parking extends StatelessWidget {
   parking({Key? key}) : super(key: key);
  final parking_code stack = Get.put(parking_code());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Obx(() =>
                      FlutterMap(
                        mapController: stack.mapController,
                        options: MapOptions(
                          center: stack.point.value,

                          zoom: 5,
                          maxZoom: 18,
                          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        children: <Widget>[
                          TileLayer(
                            urlTemplate: stack.tile.value,
                            // urlTemplate: 'http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}',
                          ),


                          //for Geofence
                          stack.isgeofence.value?
                          PolygonLayer(
                            polygons: stack.polygons.value,
                          ):Text(""),

                          stack.isgeofence.value?
                          PolylineLayer(
                            polylines: stack.polylines.value,
                          ):Text(""),

                          stack.isgeofence.value?
                          CircleLayer(
                            circles: stack.polycircle.value,
                          ):Text(""),

                          //for POI

                          stack.ispoi.value?
                          CircleLayer(
                            circles: stack.poipolycircle.value,
                          ):Text(""),
                          stack.ispoi.value?
                          MarkerLayer(
                            markers: stack.poimarkers.value,
                          ):Text(""),


                          //Display My current location
                          stack.ismylocation.value == false?
                         Text(""):stack.mymaplocation.value != null?  MarkerLayer(markers: [stack.mymaplocation.value!,]):
                          Text(""),

                          // Main Markers

                          MarkerClusterLayerWidget(
                            options: MarkerClusterLayerOptions(
                              zoomToBoundsOnClick: true,
                              centerMarkerOnClick: true,

                              maxClusterRadius: 45,
                              size: const Size(40, 40),
                              anchor: AnchorPos.align(AnchorAlign.center),
                              fitBoundsOptions: const FitBoundsOptions(
                                padding: EdgeInsets.all(50),
                                maxZoom: 18,
                              ),
                              markers: stack.markers,
                              builder: (context, markers) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue),
                                  child: Center(
                                    child: Text(
                                      markers.length.toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),



                        ],
                      ),
                  )
                ),

                Positioned(
                    top:60,
                    left: 18,
                    width: 38,
                    height: 38,
                    child: GestureDetector(
                      onTap: (){ Navigator.pop(context); },
                      child: Icon(Icons.arrow_back_outlined,
                        color: Colors.black87,
                        size: 30,),
                    )
                ),

                Positioned(
                    top: MediaQuery.of(context).size.height/7,
                    right: 15,
                    child: Column(
                      children: [
                        mapicon(micon: Icon(Icons.layers_sharp,
                            size: 21,
                            color: Color(0xff6a6a6a)
                        ),
                            icontap: (){
                              return showModalBottomSheet(context: context,
                                  backgroundColor: Color(0xFFc1c2c3),
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                  ),
                                  // clipBehavior: Clip.hardEdge,
                                  builder: (context)
                                  {
                                    return  Container(
                                      height: MediaQuery.of(context).size.height/5,
                                      color: Colors.white,
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 30),
                                              Text('map_types'.tr,
                                                style: TextStyle(fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff535454)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      padding: EdgeInsets.all(1.5), // Border width
                                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: SizedBox.fromSize(
                                                          size: Size.fromRadius(30), // Image radius
                                                          child: Image.asset('assets/images/default_map.png', fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      stack.changemap(1);
                                                    },
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text('default'.tr,
                                                    style: TextStyle(
                                                        fontSize: 11
                                                    ),)
                                                ],
                                              ),

                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      padding: EdgeInsets.all(1.5), // Border width
                                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: SizedBox.fromSize(
                                                          size: Size.fromRadius(30), // Image radius
                                                          child: Image.asset('assets/images/satellite_map.png', fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      print("changing map to the sattelite");
                                                      stack.changemap(2);
                                                    },
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text('satellite'.tr,
                                                    style: TextStyle(
                                                        fontSize: 11
                                                    ),)
                                                ],
                                              ),

                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      padding: EdgeInsets.all(1.5), // Border width
                                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: SizedBox.fromSize(
                                                          size: Size.fromRadius(30), // Image radius
                                                          child: Image.asset('assets/images/terrain_map.png', fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      stack.changemap(3);
                                                    },
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text('terrain'.tr,
                                                    style: TextStyle(
                                                        fontSize: 11
                                                    ),)
                                                ],
                                              ),




                                            ],
                                          ),
                                        ],
                                      ),
                                    );

                                  });
                            }),


                        SizedBox(height: 150),



                        mapicon(micon: Icon(Icons.settings,
                            size: 21,
                            color: Color(0xff6a6a6a)),
                            icontap: (){

                              return showModalBottomSheet(context: context,
                                  backgroundColor: Color(0xFFc1c2c3),
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                  ),
                                  // clipBehavior: Clip.hardEdge,
                                  builder: (context)
                                  {
                                    return  Container(
                                      height: MediaQuery.of(context).size.height/2.8,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(25),

                                      child:
                                      Obx(() =>
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Text('map_settings'.tr,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff535454)
                                                  )),
                                              SizedBox(height: 15),

                                              mapsettinglist(title: 'label'.tr, type: 'label', status: stack.islabel.value ,),
                                              mapsettinglist(title: 'poi'.tr, type: 'poi', status: stack.ispoi.value,),
                                              mapsettinglist(title: 'geofence'.tr, type: 'geofence',  status: stack.isgeofence.value,),
                                              // mapsettinglist(title: 'cluster'.tr,type: 'label',  status: false, toggletap: (){}),
                                              mapsettinglist(title: 'ripple'.tr, type: 'ripple', status: stack.isripple.value,),
                                              mapsettinglist(title: 'my_location'.tr, type: 'mylocation', status: stack.ismylocation.value,),


                                            ],
                                          )

                                      ),



                                    );

                                  });

                            }),



                      ],
                    )
                ),



              ],

            ),
          ),




          Container(
            height: MediaQuery.of(context).size.height/2,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(

            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Row(
                    children: [
                      Text('enable_disable_parking'.tr,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff535454)
                          )),
                    ],
                  ),
                  SizedBox(height: 15),


                  Obx(() {
                    return Column(
                      children: stack.all
                          .map(
                              (element) =>
                              vehiclelist(
                                 vehiclenumber: element["vehicleno"],
                                address: element["address"],
                                status: element["parkingenable"],
                                id:element["deviceid"],
                                lat:element["lastlatitude"]?? 0.0,
                                lon: element["lastlongitude"]?? 0.0,
                              )
                      )
                          .toList(),
                    );
                  }),


                  // venable( vicon: Icon(Icons.directions_car_filled,
                  //   color: Colors.green,
                  //   size: 30,
                  // ), vnumber: 'HR25 HN2535', vaddress: '14/72 Gauta, budhdha nagar , rajuarli circle, paranda india' ),



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// on map bottom toggle button list
class mapsettinglist extends StatelessWidget {
  mapsettinglist({Key? key, required this.title, required this.status,  required this.type}) : super(key: key);

  final parking_code stack = Get.put(parking_code());
  final String title;
  final String type;
  final bool status;

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
              FleetStack.savelocal('is${type}',value.toString());
              type == "label"?stack.islabel.value = value:
              type == "geofence"?stack.isgeofence.value = value:
              type == "poi" ? stack.ispoi.value=value:
              type == "ripple"? stack.isripple.value=value:
              stack.ismylocation.value = value;

              Get.snackbar(title , 'updated_successfully'.tr);
              print(await FleetStack.getlocal('is${type}'));
              //stack.showvehicles();
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }
}

class vehiclelist extends StatelessWidget {
   vehiclelist({Key? key, required this.vehiclenumber, required this.address, required this.id, required this.status, required this.lat, required this.lon}) : super(key: key);
   final parking_code stack = Get.put(parking_code());
  final String vehiclenumber;
  final String address;
  final int id;
  final bool status;
  final double lat;
  final double lon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Icon(Icons.directions_car_filled,
              size: 35,
              color: Color(0xff2e2e2f),
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehiclenumber,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 5),
                  Container(
                    width: appcolor.width/2.5,
                    child: Text(address,
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF757576))),
                  ),
                ],
              ),
              onTap: (){
                stack.point.value = LatLng(lat, lon);
                stack.mapController.move(stack.point.value, 11);
              },
            ),
            Spacer(),

            Container(
              height: 40,
              width: 90,
              child: Switch(
                value: status,
                onChanged: (value) {
                  print("changed to ${value} for the id ${id}");
                  stack.changeparking( id, value);
                },
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


