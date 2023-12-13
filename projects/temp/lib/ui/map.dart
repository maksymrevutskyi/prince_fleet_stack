import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';


import '../code/map_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';


class map extends StatelessWidget {
  map({Key? key}) : super(key: key);

  final map_code stack = Get.put(map_code());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Obx(
              () => FlutterMap(
                options: MapOptions(
                  center: stack.point.value,
                  zoom: 5,
                  maxZoom: 18,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                children: <Widget>[
                  // TileLayer(
                  //   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  //   subdomains: const ['a', 'b', 'c'],
                  // ),

                  TileLayer(
                    urlTemplate: stack.tile.value,
                    // urlTemplate: 'http://www.google.com/maps/vt?lyrs=m@189&gl=cn&x={x}&y={y}&z={z}',
                  ),

                  //for Geofence
                  stack.isgeofence.value
                      ? PolygonLayer(
                          polygons: stack.polygons.value,
                        )
                      : Text(""),

                  stack.isgeofence.value
                      ? PolylineLayer(
                          polylines: stack.polylines.value,
                        )
                      : Text(""),

                  stack.isgeofence.value
                      ? CircleLayer(
                          circles: stack.polycircle.value,
                        )
                      : Text(""),

                  //for POI

                  stack.ispoi.value
                      ? CircleLayer(
                          circles: stack.poipolycircle.value,
                        )
                      : Text(""),
                  stack.ispoi.value
                      ? MarkerLayer(
                          markers: stack.poimarkers.value,
                        )
                      : Text(""),

                  //Display My current location
                  stack.ismylocation.value == false
                      ? Text("")
                      : stack.mymaplocation.value != null
                          ? MarkerLayer(markers: [
                              stack.mymaplocation.value!,
                            ])
                          : Text(""),

                  // display all vehicle Icons with cluster
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
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 7,
              right: 15,
              child: Column(
                children: [
                  mapicon(
                      micon: Icon(Icons.layers_sharp,
                          size: 21, color: Color(0xff6a6a6a)),
                      icontap: () {
                        return showModalBottomSheet(
                            context: context,
                            backgroundColor: Color(0xFFc1c2c3),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            // clipBehavior: Clip.hardEdge,
                            builder: (context) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 5,
                                color: Colors.white,
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 30),
                                        Text(
                                          'map_types'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff535454)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    1.5), // Border width
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SizedBox.fromSize(
                                                    size: Size.fromRadius(
                                                        30), // Image radius
                                                    child: Image.asset(
                                                        'assets/images/default_map.png',
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                stack.changemap(1);
                                              },
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              'default'.tr,
                                              style: TextStyle(fontSize: 11),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    1.5), // Border width
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SizedBox.fromSize(
                                                    size: Size.fromRadius(
                                                        30), // Image radius
                                                    child: Image.asset(
                                                        'assets/images/satellite_map.png',
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                print(
                                                    "changing map to the sattelite");
                                                stack.changemap(2);
                                              },
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              'satellite'.tr,
                                              style: TextStyle(fontSize: 11),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    1.5), // Border width
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SizedBox.fromSize(
                                                    size: Size.fromRadius(
                                                        30), // Image radius
                                                    child: Image.asset(
                                                        'assets/images/terrain_map.png',
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                stack.changemap(3);
                                              },
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              'terrain'.tr,
                                              style: TextStyle(fontSize: 11),
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

                  SizedBox(height: 150),

                  mapicon(
                      micon: Icon(Icons.settings,
                          size: 21, color: Color(0xff6a6a6a)),
                      icontap: () {
                        return showModalBottomSheet(
                            context: context,
                            backgroundColor: Color(0xFFc1c2c3),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            // clipBehavior: Clip.hardEdge,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.8,
                                color: Colors.white,
                                padding: EdgeInsets.all(25),
                                child: Obx(() => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('map_settings'.tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff535454))),
                                        SizedBox(height: 15),

                                        mapsettinglist(
                                          title: 'label'.tr,
                                          type: 'label',
                                          status: stack.islabel.value,
                                        ),
                                        mapsettinglist(
                                          title: 'poi'.tr,
                                          type: 'poi',
                                          status: stack.ispoi.value,
                                        ),
                                        mapsettinglist(
                                          title: 'geofence'.tr,
                                          type: 'geofence',
                                          status: stack.isgeofence.value,
                                        ),
                                        // mapsettinglist(title: 'cluster'.tr,type: 'label',  status: false, toggletap: (){}),
                                        mapsettinglist(
                                          title: 'ripple'.tr,
                                          type: 'ripple',
                                          status: stack.isripple.value,
                                        ),
                                        mapsettinglist(
                                          title: 'my_location'.tr,
                                          type: 'mylocation',
                                          status: stack.ismylocation.value,
                                        ),
                                      ],
                                    )),
                              );
                            });
                      }),
                  // SizedBox(height: 25),
                  // mapicon(micon:
                  // Icon(Icons.fork_right,
                  //     size: 21,
                  //     color: Color(0xff6a6a6a)
                  // )
                  //     , icontap: (){
                  //
                  //       return showModalBottomSheet(context: context,
                  //           backgroundColor: Color(0xFFc1c2c3),
                  //           isScrollControlled: true,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                  //           ),
                  //
                  //           builder: (context)
                  //           {
                  //             return  Container(
                  //                 height: MediaQuery.of(context).size.height/2.8,
                  //                 color: Colors.white,
                  //                 padding: EdgeInsets.all(25),
                  //
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //
                  //                   children: [
                  //                     Text('select_time'.tr,
                  //                         style: TextStyle(
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Color(0xff535454)
                  //                         )),
                  //                     SizedBox(height: 15),
                  //
                  //                     simplenav(title: '5_min'.tr),
                  //                     simplenav(title: '30_min'.tr),
                  //                     simplenav(title: '1_hour'.tr),
                  //                     simplenav(title: '6_hours'.tr),
                  //                     simplenav(title: '1_day'.tr)
                  //
                  //
                  //                   ],
                  //                 )
                  //             );
                  //
                  //           });
                  //
                  //
                  //     })
                ],
              )),
        ],
      ),
    );
  }
}

// on map bottom toggle button list
class mapsettinglist extends StatelessWidget {
  mapsettinglist(
      {Key? key, required this.title, required this.status, required this.type})
      : super(key: key);

  final map_code stack = Get.put(map_code());
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
              FleetStack.savelocal('is${type}', value.toString());
              type == "label"
                  ? stack.islabel.value = value
                  : type == "geofence"
                      ? stack.isgeofence.value = value
                      : type == "poi"
                          ? stack.ispoi.value = value
                          : type == "ripple"
                              ? stack.isripple.value = value
                              : stack.ismylocation.value = value;

              Get.snackbar(title, 'updated_successfully'.tr);
              print(await FleetStack.getlocal('is${type}'));
              stack.addvehicles();
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
