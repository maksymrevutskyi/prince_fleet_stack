import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../code/poi_code.dart';
import '../common/widgets.dart';


class poi extends StatelessWidget {
   poi({Key? key}) : super(key: key);

  final poi_code stack = Get.put(poi_code());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  child:

                  Obx(() =>
                      FlutterMap(
                        mapController: stack.mapController,
                        options: MapOptions(
                          center: stack.point.value,
                          zoom: 10,
                          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: stack.tile.value,
                          ),

                          CircleLayer(
                            circles: stack.polycircle.value,
                          ),
                          MarkerLayer(
                            markers: stack.markers.value,
                          )
                        ],
                      )

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





                      ],
                    )
                ),

                // Add new POI

                // Positioned(
                //   bottom: 16.0,
                //   right: 16.0,
                //   child: FloatingActionButton(
                //     mini: true,
                //     onPressed: () {
                //       print("add new POI");
                //     },
                //     child: Icon(Icons.add),
                //   ),
                // ),

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
                      Text('list_of_poi'.tr,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff535454)
                          )),
                    ],
                  ),
                  SizedBox(height: 15),



                  Obx(() =>
                      stack.all.length > 0?
                      Column(
                        children: stack.all
                            .map(
                                (element) =>
                                poilist(id: element["id"],
                                    name: element["name"],
                                    details: element["des"],
                                    category: element["category"],
                                    geocolor: element["geocolor"]
                                )
                        )
                            .toList(),
                      ):
                          Container(
                            child: Column(
                             children: [
                               Image.asset('assets/images/geofence-1.png',
                               height: 250),
                               SizedBox(height: 25),
                               Text("No Poi",
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 25,
                               ),)
                             ],
                            ),
                          )


                  ),


                ],
              ),
            ),
          ),




        ],
      ),
    );
  }
}


class poilist extends StatelessWidget {
  poilist({Key? key, required this.id,  required this.name, required this.details, required this.geocolor, required this.category}) : super(key: key);

  final poi_code stack = Get.put(poi_code());
  final int id;
  final String name;
  final String details;
  final String category;
  final Color geocolor;


  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),

            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: geocolor,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(width: 20),
            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${name} ( ${category} )',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: Text(details,
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF757576))),
                  ),
                ],
              ),
              onTap:(){
                stack.focuspoi(id);
              },
            ),
            Spacer(),

            Container(
                height: 40,
                width: 50,
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                    ],
                  ),
                  onTap: (){
                    stack.delpoi(id);
                  },
                )

            ),



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
