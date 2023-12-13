import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../code/notifications_code.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';

class notifications extends StatefulWidget {
  notifications({Key? key}) : super(key: key);

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  final notifications_code stack = Get.put(notifications_code());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stack.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecedee),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xFF175ff0) ,
        ),
        title: Text('notifications'.tr,
          style: TextStyle(
            color: Color(0xFF175ff0),
          ),),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {

              Get.bottomSheet(
                Container(
                  height: appcolor.height/3.2,
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


                          SizedBox(height: 25),


                          Text('Select Date',
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
                                          DateFormat(appcolor.appdate).format(stack.dtselection.value).toString()
                                          ,
                                          style: TextStyle(fontSize: 18, color: appcolor.grayblack),),
                                      ],
                                    ),
                                  ),
                                  onTap: () async{
                                    var selecteddate = await  FleetStack.pickdate(currentdatetime: stack.dtselection.value);
                                    stack.dtselection.value = selecteddate!;

                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),


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
                      )

                  ),
                ),
              );

            },
          )
        ],

      ),
      body: Obx(() =>
      stack.all.value.length > 0?

      ListView.builder(
        itemCount: stack.all.length,
        itemBuilder: (context, index) {
          var element = stack.all[index];
          return  bindnotify(vehicle: element["Heading"],
              dt: DateFormat(appcolor.appdatetime).format(DateTime.parse(element["insertdt"])).toString() ,
              msg: element["msgData"]
          );
        },
      )

          :
      Center(child: Image.asset("assets/images/notify.png"))
      ),
    );
  }
}

