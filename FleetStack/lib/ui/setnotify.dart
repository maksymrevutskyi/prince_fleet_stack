import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../code/setnotify_code.dart';
import '../common/widgets.dart';
import 'notify.dart';


class setnotify extends StatelessWidget {
   setnotify({Key? key}) : super(key: key);
  final setnotify_code stack = Get.put(setnotify_code());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecedee),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF175ff0) ,

        ),
        title: Text('set_notifications'.tr,
          style: TextStyle(
            color: Color(0xFF175ff0),
          ),),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
            stack.displaybottomsheet();
              Get.bottomSheet(
               Obx(() =>

                   Container(
                     height: appcolor.height/3,
                     padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                     decoration: BoxDecoration(
                       color: Colors.white,
                     ),

                     child: stack.notifytoken.value.length > 0?
                     Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Your token"),
                         SizedBox(height: 15),
                         Text(stack.notifytoken.value,
                           style: TextStyle(
                               fontSize: 12,
                               color: appcolor.grayblack
                           ),),
                         SizedBox(height: 40),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             GestureDetector(
                               child: Container(
                                   height: 50,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(8),
                                     color: Colors.white,
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

                                         Text("configure_notify".tr, style: TextStyle(color:  Colors.black87, fontWeight: FontWeight.bold),),
                                         SizedBox(width: 10.0,),
                                         Icon(Icons.arrow_forward,
                                           size: 20,),
                                         SizedBox(width: 20.0,),
                                       ],
                                     ),
                                   )
                               ),
                               onTap: stack.configurenotify,
                             ),
                           ],
                         ),

                       ],
                     ):
                     Container(
                       padding: EdgeInsets.all(10.0),
                       margin: EdgeInsets.fromLTRB(20, 45, 20, 45),
                       height: 120,
                       decoration: BoxDecoration(
                         color: appcolor.idlelight,
                         border: Border.all(
                           color: appcolor.idle,
                           width: 2.0,
                         ),
                         borderRadius: BorderRadius.circular(5.0),
                       ),
                       child: Row(

                         children: [
                           Text("Note:",
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 18,
                               color: appcolor.idle,
                             ),),
                           SizedBox(width: 10),
                           Expanded(child: Text("Token not found please check permission or reinstall the application.",
                             style: TextStyle(
                                 fontSize: 15,
                                 color: appcolor.black
                             ),
                           ))


                         ],

                       ),
                     )
                   )
               )
              );

            },
          )
        ],
      ),
      body: Column(
        children: [
            SizedBox(height: 15),
          Obx(() =>
              Column(
                children: stack.all
                    .map(
                        (element) =>
                        vehiclelist(
                          title: element["vehicleno"],
                          id: element["deviceid"]
                        )

                )
                    .toList(),
              )
          ),


        ],
      ),
    );
  }
}



class vehiclelist extends StatelessWidget {
   vehiclelist({Key? key, required this.title, required this.id}) : super(key: key);
  final String title;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: GestureDetector(
            onTap: (){
              print("clicked at ${id}");
              Get.to(() => notify(
                  deviceid: id.toString()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car_filled,
                      color: Color(0xff2e2e2f),
                      size: 30
                    ),

                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 5),
                    Text(
                      'Set Notification behaviour for the fleet',
                      style: TextStyle(fontSize: 13, color: Color(0xFF757576)),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios,
                    size: 25, color: Color(0xff2e2e2f)),
              ],
            ),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 60, right: 25, top: 20, bottom: 20),
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


