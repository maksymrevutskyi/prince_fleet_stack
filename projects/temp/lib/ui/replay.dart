import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../code/replay_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';


class replay extends StatefulWidget {
  final String deviceid;
  const replay({super.key, required this.deviceid});

  @override
  State<replay> createState() => _replayState(deviceid);
}

class _replayState extends State<replay> {
  final replay_code stack = Get.put(replay_code());
  _replayState(String deviceid) {
    stack.tracking(deviceid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(stack.playtimer.isActive){ stack.playtimer.cancel(); }

    stack.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // covers 20% of total height
            height: MediaQuery.of(context).size.height,
            child: Obx(() =>
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child:
                      FlutterMap(
                        mapController: stack.mapController,
                        options: MapOptions(
                          center: stack.point.value,
                          zoom: 15,
                          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: stack.tile.value,
                            userAgentPackageName: 'com.example.app',
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




                          // predefine trackingline
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points:  stack.preline.value,
                                strokeWidth: 2,
                                color: appcolor.preline,
                                // gradientColors: [
                                //   const Color(0xffE40203),
                                //   const Color(0xffFEED00),
                                //   const Color(0xff007E2D),
                                // ],
                              ),
                            ],
                          ),

                          stack.istrackline.value==true?


                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points:  stack.line.value,
                                strokeWidth: 2,
                                color: appcolor.trackline,
                                // gradientColors: [
                                //   const Color(0xffE40203),
                                //   const Color(0xffFEED00),
                                //   const Color(0xff007E2D),
                                // ],
                              ),
                            ],
                          ): Text(""),


                          MarkerLayer(
                            markers: [
                              stack.current.value,
                            ],

                          ),

                          stack.isstoppage.value==true?
                          MarkerLayer(
                              markers:
                              stack.stopage.value
                          ): Text(''),

                          // My location

                          // stack.ismylocation.value==true?
                          // MarkerLayer(
                          //     markers:
                          //     stack.locationmarker.value
                          // ): Text(''),

                          //Display My current location
                          stack.ismylocation.value == false?
                          Text(""):stack.mymaplocation.value != null?  MarkerLayer(markers: [stack.mymaplocation.value!,]):
                          Text(""),


                        ],
                      ),




                    ),




                    Positioned(
                        top: MediaQuery.of(context).size.height/6.5,
                        right: 15,

                        child: Column(
                          children: [

                            mapicon(micon: Icon(Icons.filter_list,
                                size: 21,
                                color: Color(0xff6a6a6a)),
                                icontap: (){
                                  return showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Obx(() =>
                                            Container(
                                              padding: EdgeInsets.all(30),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    children: [
                                                      stack.customdropdown(
                                                        currentvalue: stack.selectedvehicle.value,
                                                        list: stack.vehiclelist.value,
                                                      ),
                                                    ],
                                                  ),



                                                  SizedBox(height: 25),


                                                  Text('From Date',
                                                      style: TextStyle(
                                                        fontSize: 21,
                                                      )),
                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          child: Container(
                                                            padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              color: appcolor.white,
                                                              border: Border.all(
                                                                color: appcolor.blue,
                                                                width: 2.0,
                                                              ),
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            // child: Center(child: Text(stack.fromdtselection.value.toString() ,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [

                                                                Icon(Icons.calendar_month),

                                                                Text(
                                                                  DateFormat(appcolor.appdatetime).format(stack.fromdtselection.value).toString()
                                                                  ,
                                                                  style: TextStyle(fontSize: 18, color: appcolor.grayblack),),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async{
                                                            var selecteddate = await  FleetStack.pickdatetime(currentdatetime: stack.fromdtselection.value);
                                                            stack.fromdtselection.value = selecteddate!;

                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 15),

                                                  Text('To Date',
                                                      style: TextStyle(
                                                        fontSize: 21,
                                                      )),
                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          child: Container(
                                                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              color: appcolor.white,
                                                              border: Border.all(
                                                                color: appcolor.blue,
                                                                width: 2.0,
                                                              ),
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            // child: Center(child: Text(stack.fromdtselection.value.toString() ,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Icon(Icons.calendar_month),
                                                                Text(
                                                                  DateFormat(appcolor.appdatetime).format(stack.todtselection.value).toString()
                                                                  ,
                                                                  style: TextStyle(fontSize: 18, color: appcolor.grayblack),),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async{
                                                            var selecteddate = await  FleetStack.pickdatetime(currentdatetime: stack.todtselection.value);
                                                            stack.todtselection.value = selecteddate!;

                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 50),

                                                  GestureDetector(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                            height: 55,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              color: appcolor.blue,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey, //New
                                                                  blurRadius: 5.0,
                                                                )
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(15.0),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  SizedBox(width: 20.0,),

                                                                  Text(  stack.isloading.value?"loading...".tr:"show_result".tr, style: TextStyle(color:  appcolor.white, fontWeight: FontWeight.bold),),
                                                                  SizedBox(width: 10.0,),
                                                                  stack.isloading.value?
                                                                  CircularProgressIndicator(
                                                                    color: appcolor.white,
                                                                  ):
                                                                  Icon( Icons.arrow_forward,
                                                                    size: 20,
                                                                    color: appcolor.white,),
                                                                  SizedBox(width: 20.0,),
                                                                ],
                                                              ),
                                                            )
                                                        ),

                                                      ],
                                                    ),
                                                    onTap: stack.isloading.value?(){}: stack.showresult,
                                                  ),



                                                ],

                                              ),
                                            )
                                        );
                                      }
                                  );


                                }),


                            SizedBox(height: 30),


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
                                        return   Container(
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
                            mapicon(micon: Icon(Icons.shutter_speed,
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

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Text('speed'.tr,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff535454)
                                                  )),
                                              SizedBox(height: 15),

                                              speedlist(title: 'slower_1x'.tr,
                                                  tap: (){
                                                    setState(() {
                                                      stack.playspeed.value = 2000;
                                                      stack.isplay.value = !stack.isplay.value;
                                                      stack.play_pause();
                                                      stack.isplay.value = !stack.isplay.value;
                                                      stack.play_pause();
                                                      Get.snackbar('speed'.tr, 'updated_successfully'.tr);
                                                    });
                                                  }),
                                              speedlist(title: 'slow_2x'.tr, tap: (){
                                                setState(() {
                                                  stack.playspeed.value = 1100;
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  Get.snackbar('speed'.tr, 'updated_successfully'.tr);
                                                });
                                              }),
                                              speedlist(title: 'normal_3x'.tr, tap: (){
                                                setState(() {
                                                  stack.playspeed.value = 600;
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  Get.snackbar('speed'.tr, 'updated_successfully'.tr);
                                                });
                                              }),
                                              speedlist(title: 'fast_4x'.tr, tap: (){
                                                setState(() {
                                                  stack.playspeed.value = 250;
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  Get.snackbar('speed'.tr, 'updated_successfully'.tr);
                                                });
                                              }),
                                              speedlist(title: 'faster_5x'.tr, tap: (){
                                                setState(() {
                                                  stack.playspeed.value = 75;
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  stack.isplay.value = !stack.isplay.value;
                                                  stack.play_pause();
                                                  Get.snackbar('speed'.tr, 'updated_successfully'.tr);
                                                });
                                              }),

                                              // simplenav(title: 'slower_1x'.tr),
                                              // simplenav(title: 'slow_2x'.tr),
                                              // simplenav(title: 'normal_3x'.tr),
                                              // simplenav(title: 'fast_4x'.tr),
                                              // simplenav(title: 'faster_5x'.tr)


                                            ],
                                          )


                                      );

                                    });

                              },
                            ),
                            SizedBox(height: 20),



                            SizedBox(height: 20),

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
                                            height: MediaQuery.of(context).size.height/2.1,
                                            color: Colors.white,
                                            padding: EdgeInsets.fromLTRB(25, 10, 25, 5),

                                            child: Obx(() =>
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


                                                    mapsettinglist(title: 'poi'.tr, type: 'poi', status: stack.ispoi.value),
                                                    mapsettinglist(title: 'geofence'.tr, type: 'geofence',  status: stack.isgeofence.value),
                                                    mapsettinglist(title: 'stoppage'.tr, type:'stoppage', status: stack.isstoppage.value),
                                                    mapsettinglist(title: 'trackline'.tr, type: "trackline",  status: stack.istrackline.value),
                                                    mapsettinglist(title: 'ripple'.tr, type: 'ripple', status: stack.isripple.value,),
                                                    mapsettinglist(title: 'my_location'.tr, type: 'mylocation', status: stack.ismylocation.value)




                                                  ],
                                                ))
                                        );

                                      });

                                }),



                          ],
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
                      bottom:0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 2),
                        height: MediaQuery.of(context).size.height/8.2,
                        width: MediaQuery.of(context).size.width,

                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child:  Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(child: Icon(
                                    (stack.isplay.value)?Icons.pause_circle: Icons.play_circle),
                                  onTap: (){
                                    stack.isplay.value = !stack.isplay.value;
                                    stack.play_pause();
                                  },
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Slider(
                                    value: stack.slider.value,
                                    divisions: 100,
                                    onChanged: (value) {
                                      stack.slider.value = value;
                                      print('at the slider point ${value}');
                                      stack.replaydrawline(value);
                                      setState(() {

                                      });
                                    },
                                    min: 0.0,
                                    max: stack.maxslider.value,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('date'.tr, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    )),
                                    SizedBox(height: 5),
                                    Text(stack.replaydate.value,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                        ))

                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('time'.tr,style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    )),
                                    SizedBox(height: 5),
                                    Text(stack.replaytime.value, style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                    ))

                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('speed'.tr, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    )),
                                    SizedBox(height: 5),
                                    Text(stack.replayspeed.value, style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                    ))

                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('km'.tr, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    )),
                                    SizedBox(height: 5),
                                    Text(stack.replaykm.value, style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                    ))

                                  ],
                                ),
                              ],
                            )
                          ],
                        ),


                      ),
                    ),

                    stack.preline.value.length > 0?  Positioned(
                        top:35,
                        //left: MediaQuery.of(context).size.width/3,
                        right: 0,

                        child: Center(
                          child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 210,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border: Border.all(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // color: Colors.white.withOpacity(0.4),
                              // color: Colors.transparent,
                              child: Obx(() =>
                                  Text(
                                    stack.replayaddress.value,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: appcolor.lightblack,
                                    ),
                                  ),
                              )

                          ),
                        )
                    ): Text(""),




                  ],
                ),

            ),
          ),
        ],
      ),

    );
  }
}






class speedlist extends StatelessWidget {
   speedlist({Key? key, required this.title, required this.tap}) : super(key: key);

  final String title;
   final Function() tap;

  final replay_code stack = Get.put(replay_code());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        children: [
          Row(
            children: [Text(title), Spacer(), Icon(Icons.arrow_forward)],
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xffdddee0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
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

  final replay_code stack = Get.put(replay_code());
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
              type == "poi"? stack.ispoi.value=value:
                  type=="geofence"?stack.isgeofence.value=value:
                      type=="stoppage"?stack.isstoppage.value=value:
                          type=="trackline"?stack.istrackline.value=value:
                              type=="ripple"?stack.isripple.value=value:
                                  stack.ismylocation.value=value;

              Get.snackbar(title , 'updated_successfully'.tr);
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }
}


