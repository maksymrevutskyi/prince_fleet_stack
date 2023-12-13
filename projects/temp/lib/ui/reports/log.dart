import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/FleetStack.dart';
import '../../common/widgets.dart';
import 'code/log_code.dart';


class log extends StatelessWidget {
   log({Key? key}) : super(key: key);
  final log_code stack = Get.put(log_code());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text("Log Report"),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {

              Get.bottomSheet(
                Container(
                  height: appcolor.height/2,
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
                                          DateFormat(appcolor.appdate).format(stack.fromdtselection.value).toString()
                                          ,
                                          style: TextStyle(fontSize: 18, color: appcolor.grayblack),),
                                      ],
                                    ),
                                  ),
                                  onTap: () async{
                                    var selecteddate = await  FleetStack.pickdate(currentdatetime: stack.fromdtselection.value);
                                    stack.fromdtselection.value = selecteddate!;

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
                      )

                  ),
                ),
              );

            },
          )
        ],

      ),
      body: SingleChildScrollView(
        child: Container(
          child:
          Obx(() =>
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("IMEI")),
                    DataColumn(label: Text("Time")),
                    DataColumn(label: Text("Latitude")),
                    DataColumn(label: Text("Longitude")),
                    DataColumn(label: Text("Location")),
                    DataColumn(label: Text("Satellites")),
                    DataColumn(label: Text("Speed")),
                    DataColumn(label: Text("Ignition")),
                    DataColumn(label: Text("Motion")),
                    DataColumn(label: Text("Attribute")),
                  ],
                  rows: stack.all.map((dataRow) => DataRow(cells: [
                    DataCell(Text(dataRow["imei"].toString())),
                    DataCell(Text(dataRow["time"])),
                    DataCell(Text(dataRow["lat"].toString())),
                    DataCell(Text(dataRow["lon"].toString())),
                    DataCell(Text(dataRow["location"])),
                    DataCell(Text(dataRow["sat"]?.toString() ?? "N/A")),
                    DataCell(Text(dataRow["speed"].toString())),
                    DataCell(Text(dataRow["ignition"].toString())),
                    DataCell(Text(dataRow["motion"].toString())),
                    DataCell(Text(dataRow["attribute"].toString())),
                  ])).toList(),
                ),
              )
          )
        ),
      )



    );
  }
}
