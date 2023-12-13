import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';

class language extends StatelessWidget {
  const language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var languagelist = [
      {"lan_code": "en_US",       "language": "ENGLISH"      },
      {"lan_code": "hi_IN", "language": "हिंदी"      },
      {"lan_code": "es_ES",   "language": "Español"  },
      {"lan_code": "fr_FR",   "language": "Français"  },
      {"lan_code": "ar_AE",   "language": "العربية"  },
      {"lan_code": "ru_RU",   "language": "Русский"  },
      {"lan_code": "it_IT",   "language": "Italiano"  },
      {"lan_code": "de_DE",   "language": "Deutsch"  },
      {"lan_code": "pt_BR",   "language": "Português"  },
      {"lan_code": "id_ID",   "language": "Bahasa Indonesia"  },
      {"lan_code": "ja_JP",   "language": " 日本語"  },
      {"lan_code": "zh_CN",   "language": "中文"  },

    ];

   // var current = await FleetStack.getlocal("language").toString();

    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('choose_language'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,
      ),
      body: ListView.builder(
        itemCount: languagelist.length,
        itemBuilder: (context, index) {
          return   Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 15, 10),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   gradient: LinearGradient(
                  //       colors: [
                  //         Color(0xFFf6f9ff),
                  //         Color(0xFFf6f9ff)
                  //       ]
                  //   ),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey, //New
                  //       blurRadius: 25.0,
                  //     )
                  //   ],
                  // ),

                  child: Text(
                    languagelist[index]['language'].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                onTap: () async {

                  print("changing language.....");
                  FleetStack.savelocal("language", languagelist[index]['lan_code'].toString());
                  print(await FleetStack.getlocal("language"));
                  FleetStack.setlanguage();
                  Get.snackbar(
                    'Language',
                    'Language updated successfully',
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  // Get.updateLocale(Locale('hi', 'IN'));
                },
              ),
              // (languagelist[index]['lan_code'].toString() == await FleetStack.getlocal("language").toString())?
              // Icon(Icons.check,color: Colors.green,) : Text(''),
            ],
          );


          //   Container(
          //   padding: EdgeInsets.all(20),
          //   child: Text(languagelist[index]['language'].toString()),
          // );
        },
      ),
    );
  }
}
