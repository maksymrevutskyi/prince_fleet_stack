import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FleetStack {
  static final url = 'http://app.fleetstack.in/';
  //static final url = 'http://13.126.240.116/';
  static final baseurl = '${url}api/';
  //static final baseurl = 'http://18.215.228.117/api/';

  static final dio = Dio();

  static Future<dynamic> login(String username, String password) async {
    try {
      final response = await dio.post(
        baseurl + 'GetUserTocken',
        data: {"username": username, "password": password},
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (error) {
      return null;
    }
  }

  static void savelocal(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getlocal(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = (prefs.getString(key) ?? '');
    return value;
  }

  static void deletelocal(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<dynamic> getauthdata(String endpoint) async {
    var token = await FleetStack.getlocal("token");
    dio.options.headers = {
      "accept": "text/plain",
      "Authorization": 'bearer $token'
    };
    var url = baseurl + endpoint;
    final response = await dio.get(url);
    return response.data;
  }

  static Future<dynamic> postauthdata(
      String endpoint, Map<String, dynamic> data) async {
    var token = await FleetStack.getlocal("token");
    dio.options.headers = {
      "accept": "text/plain",
      "Authorization": 'bearer $token'
    };

    var url = baseurl + endpoint;
    // final response = await dio.get(url);
    //  final response = await dio.post(url, data: jsonEncode(data));
    final response = await dio.post(url, queryParameters: data);
    return response.data;
  }

  static Future<dynamic> delauthdata(
      String endpoint, Map<String, dynamic> data) async {
    var token = await FleetStack.getlocal("token");
    dio.options.headers = {
      "accept": "text/plain",
      "Authorization": 'bearer $token'
    };

    var url = baseurl + endpoint;
    // final response = await dio.get(url);
    final response = await dio.delete(url, queryParameters: data);
    return response.data;
  }

  static Future<dynamic> patchauthdata(
      String endpoint, Map<String, dynamic> data) async {
    var token = await FleetStack.getlocal("token");
    dio.options.headers = {
      "accept": "text/plain",
      "Authorization": 'bearer $token'
    };

    var url = baseurl + endpoint;
    // final response = await dio.get(url);
    final response = await dio.patch(url, queryParameters: data);
    return response.data;
  }

  static List<dynamic> stringtojson(String jsonString) {
    return json.decode(jsonString);
  }

  static String jsontostring(List<dynamic> jsonObject) {
    return jsonEncode(jsonObject);
  }

  static void setlanguage() async {
    var language = await FleetStack.getlocal("language");

    if (language.length > 0) {
      List<String> parts = language.split('_');
      Get.updateLocale(Locale(parts[0], parts[1]));
    } else {
      // language = Platform.isIOS ? 'en_US' : Get.deviceLocale.toString();
      language = 'en_US';
      List<String> parts = language.split('_');
      Get.updateLocale(Locale(parts[0], parts[1]));
      // if (language.length > 0) {
      //   List<String> parts = language.split('_');
      //   Get.updateLocale(Locale(parts[0], parts[1]));
      // } else {
      //   Get.updateLocale(Locale('hi', 'IN'));
      // }
    }
  }

  static String mintostr(int? minutes) {
    if (minutes == null) {
      return "Not Found";
    }
    int seconds = minutes * 60;
    int years = seconds ~/ 31536000;
    int months = (seconds % 31536000) ~/ 2628000;
    int days = (seconds % 2628000) ~/ 86400;
    int hours = (seconds % 86400) ~/ 3600;
    int min = (seconds % 3600) ~/ 60;
    int sec = seconds % 60;

    String timeString = "";

    if (years > 0) {
      timeString += "${years} year${years > 1 ? "s" : ""} ";
      if (months > 0) {
        timeString += "${months} month${months > 1 ? "s" : ""} ";
      }
    } else {
      if (months > 0) {
        timeString += "${months} month${months > 1 ? "s" : ""} ";
        if (days > 0) {
          timeString += "${days} day${days > 1 ? "s" : ""} ";
        }
      } else {
        if (days > 0) {
          timeString += "${days} day${days > 1 ? "s" : ""} ";
          if (hours > 0) {
            timeString += "${hours} hr${hours > 1 ? "s" : ""} ";
          }
        } else {
          if (hours > 0) {
            timeString += "${hours} hr${hours > 1 ? "s" : ""} ";
            if (min > 0) {
              timeString += "${min} min${min > 1 ? "s" : ""} ";
            }
          } else {
            if (min > 0) {
              timeString += "${min} min${min > 1 ? "s" : ""} ";
              if (sec > 0) {
                timeString += "${sec} second${sec > 1 ? "s" : ""}";
              }
            } else {
              timeString += "${sec} second${sec > 1 ? "s" : ""}";
            }
          }
        }
      }
    }

    return timeString.trim();
  }

  static double angle(
      double oldLat, double oldLog, double newLat, double newLng) {
    var dy = newLng - oldLog;
    var dx = newLat - oldLat;
    var theta = math.atan2(dy, dx); // range (-PI, PI]
    theta *= 180 / math.pi; // rads to degs, range (-180, 180]
    //if (theta < 0) theta = 360 + theta; // range [0, 360)
    return theta;
  }

  static Future<LocationData?> currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = new Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  static LatLng getCenterFromDegrees(List<dynamic> data) {
    if (data.isEmpty) {
      return LatLng(24.650683, 76.978658);
    }

    int numCoords = data.length;

    double X = 0.0;
    double Y = 0.0;
    double Z = 0.0;

    for (var i = 0; i < data.length; i++) {
      var lat = data[i][0] * math.pi / 180;
      var lon = data[i][1] * math.pi / 180;

      var a = math.cos(lat) * math.cos(lon);
      var b = math.cos(lat) * math.sin(lon);
      var c = math.sin(lat);

      X += a;
      Y += b;
      Z += c;
    }

    X /= numCoords;
    Y /= numCoords;
    Z /= numCoords;

    var lon = math.atan2(Y, X);
    var hyp = math.sqrt(X * X + Y * Y);
    var lat = math.atan2(Z, hyp);

    double newX = lat * 180 / math.pi;
    double newY = lon * 180 / math.pi;
    return LatLng(newX, newY);
  }

  static double bearing(double lat1, double lon1, double lat2, double lon2) {
    lat1 = lat1 * pi / 180;
    lon1 = lon1 * pi / 180;
    lat2 = lat2 * pi / 180;
    lon2 = lon2 * pi / 180;
    var dLon = lon2 - lon1;
    var y = math.sin(dLon) * math.cos(lat2);
    var x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    var bearing = math.atan2(y, x);
    bearing = bearing * 180 / pi;
    bearing = (bearing + 360) % 360;
    return bearing * pi / 180;
  }

  static Future<List<dynamic>> refinedata(
      List<dynamic> obj, int stopagetime) async {
    bool lstmotion = false;
    double distance = 0.0;
    double lastdistance = 0.0;
    double lastSpeed = 0.0;
    int staytime = stopagetime;
    var RecordArr = [];

    bool lstmotionStart = false;
    for (var i = 0; i < obj.length; i++) {
      var rld = obj[i];
      if (i > 0) {
        if (lstmotionStart == obj[i]["motion"] && obj[i]["motion"] == true) {
          //  var diffTime = Math.abs(Date.parse(obj[i].device_dt) - Date.parse(obj[i-1].device_dt));
          //  var diffmin = Math.ceil(diffTime / (1000 * 60));

          DateTime dt1 = DateTime.parse(obj[i - 1]["device_dt"].toString());
          DateTime dt2 = DateTime.parse(obj[i]["device_dt"].toString());
          Duration diff = dt2.difference(dt1);
          int diffmin = (diff.inSeconds / 60).ceil();

          if (diffmin > 5) {
            obj[i - 1]["motion"] = false;
          }
        }
      }
      lstmotionStart = obj[i]["motion"];
    }

    for (var i = 0; i < obj.length; i++) {
      var resultArr = [];
      if (i == 0) {
        lstmotion = obj[i]["motion"];
        distance = double.parse(obj[i]["meter"].toString());
        lastdistance = double.parse(obj[i]["meter"].toString());
        lastSpeed = double.parse(obj[i]["speed"].toString());
        resultArr = [
          i,
          obj[i]["device_dt"],
          distance,
          lstmotion,
          lastdistance,
          lastSpeed
        ];
        RecordArr.add(resultArr);
      } else {
        if (lstmotion != obj[i]["motion"]) {
          resultArr = [
            i,
            obj[i]["device_dt"],
            distance,
            obj[i]["motion"],
            lastdistance,
            lastSpeed
          ];
          RecordArr.add(resultArr);
          lstmotion = obj[i]["motion"];
          distance += double.parse(obj[i]["meter"].toString());
          lastdistance = double.parse(obj[i]["meter"].toString());
          lastSpeed = double.parse(obj[i]["speed"].toString());
        } else {
          distance += double.parse(obj[i]["meter"].toString());
          lastdistance += double.parse(obj[i]["meter"].toString());
          if (lastSpeed < obj[i]["speed"])
            lastSpeed = double.parse(obj[i]["speed"].toString());
        }
      }
    }

    var RecordArrNew = [];
    for (var i = 0; i < RecordArr.length; i++) {
      var rldata = RecordArr[i];

      if (i == 0) {
        lstmotion = rldata[3];
        RecordArrNew.add(RecordArr[i]);
      } else {
        if (lstmotion == false && (rldata[3] == true) ? true : false == true) {
          DateTime dt1 = DateTime.parse(RecordArr[i - 1][1].toString());
          DateTime dt2 = DateTime.parse(RecordArr[i][1].toString());
          Duration diff = dt2.difference(dt1);
          int diffmin = (diff.inSeconds / 60).ceil();
          if (diffmin < staytime) {
            var fcal = double.parse(RecordArr[i - 1][4].toString()) +
                double.parse(RecordArr[i][4].toString());
            var spd = double.parse(RecordArr[i - 1][5].toString()) >
                    double.parse(RecordArr[i][5].toString())
                ? double.parse(RecordArr[i - 1][5].toString())
                : double.parse(RecordArr[i][5].toString());

            RecordArrNew.removeLast();
            RecordArrNew.add([
              RecordArr[i][0],
              RecordArr[i][1],
              RecordArr[i][2],
              RecordArr[i][3],
              fcal,
              spd
            ]);
          } else {
            RecordArrNew.add(RecordArr[i]);
            lstmotion = rldata[3];
          }
        } else {
          RecordArrNew.add(RecordArr[i]);
          lstmotion = rldata[3];
        }
      }
    } // loop ends

    var finalSet = [];
    // var flastdt = rldata[1];
    var flastdt = RecordArrNew[0][1];
    var fsrno = 1;
    lastSpeed = 0;
    lastdistance = 0;
    for (var i = 0; i < RecordArrNew.length; i++) {
      var rldata = RecordArrNew[i];
      if (i == 0) {
        lstmotion = rldata[3];
        finalSet.add([
          fsrno,
          rldata[0],
          rldata[1],
          rldata[1],
          rldata[3],
          rldata[2],
          rldata[4],
          rldata[5],
          0
        ]);
        fsrno++;
        flastdt = rldata[1];
        lastSpeed = rldata[5];
        lastdistance = rldata[4];
      } else {
        if (lstmotion != rldata[3]) {
          var sd = finalSet[finalSet.length - 1];

          DateTime dt1 = DateTime.parse(sd[2].toString());
          DateTime dt2 = DateTime.parse(RecordArrNew[i][1].toString());
          Duration diff = dt2.difference(dt1);
          int diffmin = (diff.inSeconds / 60).ceil();

          if (lastSpeed < rldata[5]) lastSpeed = rldata[5];
          finalSet[finalSet.length - 1][8] = diffmin;
          finalSet[finalSet.length - 1][3] = RecordArrNew[i][1];
          finalSet[finalSet.length - 1][3] = RecordArrNew[i][1];
          finalSet[finalSet.length - 1][5] = rldata[2];
          finalSet[finalSet.length - 1][6] = lastdistance + rldata[4];
          finalSet[finalSet.length - 1][7] = lastSpeed;

          finalSet.add([
            fsrno,
            rldata[0],
            rldata[1],
            rldata[1],
            rldata[3],
            rldata[2],
            rldata[4],
            rldata[5],
            0
          ]);
          fsrno++;
          lstmotion = rldata[3];
          lastSpeed = rldata[5];
          lastdistance = 0;
        } else {
          if (lastSpeed < rldata[5]) lastSpeed = rldata[5];
          lastdistance = lastdistance + rldata[4];
        }
      }
    }

    return finalSet;
  }

  static Future<DateTime?> pickdatetime({DateTime? currentdatetime}) async {
    if (currentdatetime == null) {
      currentdatetime = DateTime.now();
    }

    DateTime? date = await pickdate(currentdatetime: currentdatetime);
    if (date == null) return DateTime.now();
    TimeOfDay? time = await picktime(currentdatetime: currentdatetime);
    if (time == null) return DateTime(date.year, date.month, date.day, 00, 00);
    var finaldate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return finaldate;
  }

  static Future<DateTime?> pickdate({DateTime? currentdatetime}) async {
    if (currentdatetime == null) {
      currentdatetime = DateTime.now();
    }
    DateTime? picker = await showDatePicker(
        context: Get.context!,
        initialDate: currentdatetime,
        firstDate: DateTime(2023),
        lastDate: DateTime.now().add(Duration(hours: 15)));
    return picker;
  }

  static Future<TimeOfDay?> picktime({DateTime? currentdatetime}) async {
    if (currentdatetime == null) {
      currentdatetime = DateTime.now();
    }
    TimeOfDay? pickertime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay(
            hour: currentdatetime.hour, minute: currentdatetime.minute));
    return pickertime;
  }

  static Future<DateTime?> pickfuturedatetime(
      {DateTime? currentdatetime}) async {
    if (currentdatetime == null) {
      currentdatetime = DateTime.now();
    }

    DateTime? date = await pickfuturedate(currentdatetime: currentdatetime);
    if (date == null) return DateTime.now();
    TimeOfDay? time = await picktime(currentdatetime: currentdatetime);
    if (time == null) return DateTime(date.year, date.month, date.day, 00, 00);
    var finaldate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return finaldate;
  }

  static Future<DateTime?> pickfuturedate({DateTime? currentdatetime}) async {
    if (currentdatetime == null) {
      currentdatetime = DateTime.now();
    }
    DateTime? picker = await showDatePicker(
        context: Get.context!,
        initialDate: currentdatetime,
        firstDate: DateTime(2023),
        lastDate: DateTime(2100));
    return picker;
  }

  static LatLng GeoCenter(List<List<LatLng>> coordinatesList) {
    double totalLatitude = 0;
    double totalLongitude = 0;
    int totalPoints = 0;

    coordinatesList.forEach((coordinates) {
      coordinates.forEach((coordinate) {
        totalLatitude += coordinate.latitude;
        totalLongitude += coordinate.longitude;
        totalPoints++;
      });
    });

    return LatLng(
      totalLatitude / totalPoints,
      totalLongitude / totalPoints,
    );
  }

  static LatLng GeoPointCenter(List<LatLng> data) {
    double totalLatitude = 0;
    double totalLongitude = 0;
    int totalPoints = data.length;

    data.forEach((coordinate) {
      totalLatitude += coordinate.latitude;
      totalLongitude += coordinate.longitude;
    });

    return LatLng(
      totalLatitude / totalPoints,
      totalLongitude / totalPoints,
    );
  }
}
