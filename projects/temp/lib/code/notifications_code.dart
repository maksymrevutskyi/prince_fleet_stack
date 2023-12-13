import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/FleetStack.dart';
import '../common/widgets.dart';

class notifications_code extends GetxController{

  var all = [].obs;
  var dtselection = DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 00,00 ).obs;
  var isloading = false.obs;


  @override
  void onInit() {


    // Future.delayed(Duration(seconds: 4), () {
    //   displaynotify();
    // });

    displaynotify();
    super.onInit();
  }








  displaynotify() async{

    print("fatching the notificaitons...");

   var currentdt =  DateFormat(appcolor.appinputdate).format(DateTime.now());
   print(currentdt);

    var result = await FleetStack.getauthdata('gethistoryEvents?ondate=${currentdt}');
    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);
           print(data);
      all.value = data;

        }

  }


  showresult() async{
    print('showing for custom date');
    isloading.value = true;

    var requested =  '${dtselection.value.year}-${dtselection.value.month}-${dtselection.value.day}';


    var result=  await FleetStack.getauthdata('gethistoryEvents?ondate=${requested}');


    if (result["respcode"] == true) {
      var data = await FleetStack.stringtojson(result["data"]);

      all.value = [];
      if(data.length > 0) {
        all.value = data;
      }

    }

    isloading.value = false;
    Get.back();



  }

}