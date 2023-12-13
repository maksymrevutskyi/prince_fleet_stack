import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../code/tracklink_code.dart';
import '../common/widgets.dart';
import '../common/FleetStack.dart';
import 'package:intl/intl.dart';

class tracklink extends StatelessWidget {
   tracklink({Key? key}) : super(key: key);
  final tracklink_code stack = Get.put(tracklink_code());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('tracking_link'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [



                SizedBox(height: 10.0),


               Obx(() =>
               stack.all.value.length > 0?
                   Column(
                     children: stack.all
                         .map(
                             (element) =>
                             linkitem(
                               id: element["shareid"],
                               validity: DateTime.parse(element["UptoDate"].toString()),
                               link: element["linkCode"] != null ? '${FleetStack.url}auth/track?id=${element["linkCode"]}' : "",
                             )
                     )
                         .toList(),
                   ):
                   Image.asset('assets/images/track-link.png')
               ),



              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: (){
          print("Create New Link");
          Get.bottomSheet(
            Container(
              height: appcolor.height/1.6,
              padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),

              ),
              child: Obx(() =>
                  Column(


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


                      Text('For Date',
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
                                      DateFormat(appcolor.appdatetime).format(stack.fordtselection.value).toString()
                                      ,
                                      style: TextStyle(fontSize: 18, color: appcolor.grayblack),),
                                  ],
                                ),
                              ),
                              onTap: () async{
                                var selecteddate = await  FleetStack.pickfuturedatetime(currentdatetime: stack.fordtselection.value);
                                stack.fordtselection.value = selecteddate!;

                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      togglebtn(title: "Geofene", type: "geofence", status: stack.isgeofence.value),
                      togglebtn(title: "Poi", type:"poi", status: stack.ispoi.value),
                      togglebtn(title: "Driver Details", type: "driver", status: stack.isdriverdetails.value),

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

                                      Text(  stack.isloading.value?"loading...".tr:"create_link".tr, style: TextStyle(color:  appcolor.white, fontWeight: FontWeight.bold),),
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
                        onTap: stack.isloading.value?(){}: stack.createlink,
                      ),


                    ],
                  )

              ),
            ),
          );

          } ,
        tooltip: 'New Link',
        child: const Icon(Icons.add),
      ),

    );
  }
}



class linkitem extends StatelessWidget {
   linkitem({Key? key, required this.id, required this.validity, required this.link}) : super(key: key);

   final tracklink_code stack = Get.put(tracklink_code());

   final int id;
   final DateTime validity;
   final String link;

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [
                Color(0xFFf6f9ff),
                Color(0xFFf6f9ff)
              ]
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey, //New
              blurRadius: 25.0,
            )
          ],
        ),
        child:
        Padding(

          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            children: [
              Row(
                children: [

                  Column(
                    children: [

                      Container(
                        width: 60,
                        height: 75,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child:  Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/vehicle-running.png'),

                                )
                            ),
                          ),

                        ),
                      ),



                    ],
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [

                            Text( DateFormat(appcolor.appdatetime).format(validity),
                                style:TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color:  Color(0xFF757576),
                                )),
                            SizedBox(width: 5),

                          ],
                        ),




                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.link,
                              color: Color(0xff5575b6),),
                            SizedBox(width: 7),
                            Container(
                              width: appcolor.width/1.9,
                              child: Text( link,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),



                      ],
                    ),
                  )


                ],
              ),

              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 8),
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFFd5dbe8),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               GestureDetector(
                    child: Icon(Icons.copy,
                        size: 24,
                        color: Colors.blueAccent),
                    onTap: (){
                      stack.copytext(link);
                    },
                  ),

                  GestureDetector(
                    child: Icon(Icons.share,
                        size: 24,
                        color: Colors.blueAccent),
                    onTap: (){
                      Share.share('Follow the Given Link \n ${link}',
                          subject: 'Checkout Live Tracking');
                    },
                  ),

                  GestureDetector(
                    child: Icon(Icons.delete,
                        size: 24,
                        color: Colors.blueAccent),
                    onTap: (){
                      stack.deletelink(id);
                    },
                  ),


                ],
              )
            ],
          ),





        ),
      ),



    );
  }
}

class togglebtn extends StatelessWidget {
   togglebtn({Key? key, required this.title, required this.status, required this.type}) : super(key: key);
   final tracklink_code stack = Get.put(tracklink_code());
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
              // FleetStack.savelocal('is${type}',value.toString());
              type == "geofence"?stack.isgeofence.value = value:
              type == "poi" ? stack.ispoi.value=value:
              stack.isdriverdetails.value = value;
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
