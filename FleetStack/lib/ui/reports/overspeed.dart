import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/FleetStack.dart';
import '../../common/widgets.dart';
import 'code/overspeed_code.dart';

class overspeed extends StatelessWidget {
  overspeed({Key? key}) : super(key: key);
  final overspeed_code stack = Get.put(overspeed_code());
  @override
  Widget build(BuildContext context) {
    return GetX<overspeed_code>(builder: (controller) {
      return Scaffold(
          backgroundColor: appcolor.gray,
          appBar: AppBar(
            title: Text("Overspeed Report"),
            backgroundColor: appcolor.white,
            foregroundColor: appcolor.lightblack,
            actions: <Widget>[
              // IconButton(
              //     onPressed: () {
              //       stack.onDownloadButton();
              //     },
              //     icon: Icon(Icons.download)),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      height: appcolor.height / 2,
                      padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   topRight: Radius.circular(20),
                        // ),
                      ),
                      child: Obx(() => Column(
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
                              DropdownButton(
                                value: stack.selectedspeed.value,
                                items: stack.speedlist.map((item) {
                                  return DropdownMenuItem(
                                      value: item['value'],
                                      child: Text(item['text']));
                                }).toList(),
                                onChanged: (newValue) {
                                  stack.selectedspeed.value =
                                      int.parse(newValue.toString());
                                },
                              ),
                              SizedBox(height: 20),
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
                                        padding:
                                            EdgeInsets.fromLTRB(30, 5, 30, 5),
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: appcolor.white,
                                          border: Border.all(
                                            color: appcolor.blue,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        // child: Center(child: Text(stack.fromdtselection.value.toString() ,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.calendar_month),
                                            Text(
                                              DateFormat(appcolor.appdate)
                                                  .format(stack
                                                      .fromdtselection.value)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: appcolor.grayblack),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        var selecteddate =
                                            await FleetStack.pickdate(
                                                currentdatetime: stack
                                                    .fromdtselection.value);
                                        stack.fromdtselection.value =
                                            selecteddate!;
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(
                                                stack.isloading.value
                                                    ? "loading...".tr
                                                    : "show_result".tr,
                                                style: TextStyle(
                                                    color: appcolor.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              stack.isloading.value
                                                  ? CircularProgressIndicator(
                                                      color: appcolor.white,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_forward,
                                                      size: 20,
                                                      color: appcolor.white,
                                                    ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                                onTap: stack.isloading.value
                                    ? () {}
                                    : stack.showresult,
                              ),
                            ],
                          )),
                    ),
                  );
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
                child: Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Sr. No.")),
                        DataColumn(label: Text("Vehicle No.")),
                        DataColumn(label: Text("Duration")),
                        DataColumn(label: Text("Top Speed")),
                        DataColumn(label: Text("Avg. Speed")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("From Time")),
                        DataColumn(label: Text("To Time")),
                        DataColumn(label: Text("Start Address")),
                        DataColumn(label: Text("End Address")),
                      ],
                      rows: stack.all
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e["srno"].toString())),
                                DataCell(Text(e["vehicle_no"])),
                                DataCell(Text(e["duration"])),
                                DataCell(Text(e["top_speed"].toString())),
                                DataCell(Text(e["average_speed"].toString())),
                                DataCell(Text(e["date"])),
                                DataCell(Text(e["from_time"])),
                                DataCell(Text(e["to_time"])),
                                DataCell(Text(e["start_address"])),
                                DataCell(Text(e["end_address"])),
                              ]))
                          .toList(),
                    )))),
          ),
          floatingActionButton: controller.all.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.picture_as_pdf),
                                title: Text('PDF'),
                                onTap: () {
                                  stack.isPdf.value = true;
                                  stack.onDownloadButton();
                                  Get.back();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.document_scanner),
                                title: Text('CSV'),
                                onTap: () {
                                  stack.isPdf.value = false;
                                  stack.onDownloadButton();
                                  Get.back();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(Icons.download),
                )
              : null);
    });
  }
}
