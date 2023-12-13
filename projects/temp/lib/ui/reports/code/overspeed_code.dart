import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import '../../../common/FleetStack.dart';

class overspeed_code extends GetxController {
  var all = [].obs;

  final selectedvehicle = 0.obs;
  Rx<List<Map<String, dynamic>>> vehiclelist = Rx([]);
  var fromdtselection = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00)
      .obs;
  var todtselection = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 58)
      .obs;
  var isloading = false.obs;
  RxBool isPdf = true.obs;

  final List<Map<String, dynamic>> speedlist = [
    {"text": "30 km/hr", "value": 30},
    {"text": "40 km/hr", "value": 40},
    {"text": "50 km/hr", "value": 50},
    {"text": "60 km/hr", "value": 60},
    {"text": "70 km/hr", "value": 70},
    {"text": "80 km/hr", "value": 80},
    {"text": "90 km/hr", "value": 90},
    {"text": "100 km/hr", "value": 100},
    {"text": "110 km/hr", "value": 110},
    {"text": "120 km/hr", "value": 120},
    {"text": "130 km/hr", "value": 130}
  ];

  final selectedspeed = 80.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fillvehiclelist();
    // testing();
  }

  showresult() async {
    print("submit to the server");
    isloading.value = true;

    if (selectedvehicle.value == 0) {
      Get.snackbar('input_validation'.tr, 'kindly_select_vehicle'.tr);
      isloading.value = false;
      return;
    }

    all.value = [];

    // var fromdate = Uri.encodeComponent(fromdtselection.value.toString()).replaceAll(".000", "");

    var date =
        '${fromdtselection.value.year}-${fromdtselection.value.month}-${fromdtselection.value.day}';

    //getOverSpeedReport?devicesids=22&ondate=2023-01-17&overspeed=30
    var result = await FleetStack.getauthdata(
        'getOverSpeedReport?devicesids=${selectedvehicle.value}&ondate=${date}&overspeed=${selectedspeed.value}');

    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);

      print(data);

      if (data.length > 0) {
        all.value = data;
      }
    }

    isloading.value = false;
    Get.back();
  }

  fillvehiclelist() async {
    var data = await FleetStack.getauthdata('getDevices');
    if (data["respcode"] == true) {
      var vlist = await FleetStack.stringtojson(data["data"]);
      vehiclelist.value = List<Map<String, dynamic>>.from(vlist);
      print(vehiclelist.value);
    }
  }

  Widget customdropdown(
      {required int currentvalue, required List<Map<String, dynamic>> list}) {
    return Expanded(
      child: Container(
        // width:  double.infinity,

        child: DropdownButton<int>(
          iconSize: 30,
          // focusColor: appcolor.runninglight,
          alignment: Alignment.center,
          value: currentvalue,
          onChanged: (int? newValue) {
            if (newValue != null) {
              selectedvehicle.value = newValue!;
            }
          },
          items: [
            DropdownMenuItem<int>(
              value: 0,
              child: Text("Select Vehicle"),
            ),
            ...list.map((Map<String, dynamic> vehicle) {
              return DropdownMenuItem<int>(
                value: vehicle["deviceid"],
                child: Text(vehicle["vehicleno"]),
              );
            }),
          ],
        ),
      ),
    );
  }

  void onDownloadButton() async {
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    var directory = await getExternalStorageDirectory();
    String newPath = "";
    File file;
    List<List<dynamic>> rows = [];
    String convertedDirectoryPath = (directory?.path).toString();
    List<String> paths = convertedDirectoryPath.split("/");
    for (int x = 1; x < convertedDirectoryPath.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    var downloaderPath = '/storage/emulated/0/Download/';
    var time = DateTime.now();
    var fileName = "Overspeed_Report_" +
        time.hour.toString() +
        "_" +
        time.minute.toString() +
        "_" +
        time.day.toString() +
        "_" +
        time.month.toString();
    if (isPdf.isTrue) {
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          margin: const pw.EdgeInsets.all(30),
          pageFormat: PdfPageFormat.a3,
          build: (context) => [
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                "Sr. No.",
                "Vehicle No.",
                "Duration",
                "Top Speed",
                "Avg. Speed",
                "Date",
                "From Time",
                "To Time",
                "Start Address",
                "End Address"
              ],
              ...all.map((user) => [
                    user["srno"].toString(),
                    user["vehicle_no"],
                    user["duration"],
                    user["top_speed"].toString(),
                    user["average_speed"].toString(),
                    user["date"],
                    user["from_time"],
                    user["to_time"],
                    user["start_address"],
                    user["end_address"]
                  ])
            ]),
          ],
        ),
      );
      file =
          await File("$downloaderPath/$fileName.pdf").create(recursive: true);
      var isExist = await file.exists();
      isExist == false
          ? file = await File("${directory!.path}/$fileName.pdf")
              .create(recursive: true)
          : null;
      var data = await pdf.save();
      await file.writeAsBytes(data);
    } else {
      file =
          await File("$downloaderPath/$fileName.csv").create(recursive: true);
      var isExist = await file.exists();
      isExist == false
          ? file = await File("${directory!.path}/$fileName.csv")
              .create(recursive: true)
          : null;
      // var data = await pdf.save();
      // await file.writeAsBytes(data);
      List<dynamic> row = [];
      row.add('Sr. No.');

      row.add("Vehicle No.");
      row.add("Duration");
      row.add("Top Speed");
      row.add("Avg. Speed");
      row.add("Date");
      row.add("From Time");
      row.add("To Time");
      row.add("Start Address");
      row.add("End Address");
      rows.add(row);
      for (int i = 0; i < all.length; i++) {
        List<dynamic> row = [];
        row.add(all[i]['srno']);
        row.add(all[i]['vehicle_no']);
        row.add(all[i]['duration']);
        row.add(all[i]['top_speed']);
        row.add(all[i]['average_speed']);
        row.add(all[i]['from_time']);
        row.add(all[i]['to_time']);
        row.add(all[i]['start_address']);
        row.add(all[i]['end_address']);
        rows.add(row);
      }
      String csv = const ListToCsvConverter().convert(rows);
      file.writeAsString(csv);
    }
    OpenFilex.open(file.path);
  }
}
