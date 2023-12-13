import 'package:get/get.dart';
import '../common/FleetStack.dart';
import '../common/notificationservice.dart';
import '../ui/login.dart';

class profile_code extends GetxController {
  final name = ''.obs;
  final company = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void getData() async {
    var result = await FleetStack.getlocal("userdetails");
    var userdetails = FleetStack.stringtojson(result);
    name.value = userdetails[0]["ContactPerson"];
    company.value = userdetails[0]["CompanyName"];
    print(userdetails);
    update();
  }

  void logout() async {
    // delete token & userdetails
    await delnotifytoken();
    FleetStack.deletelocal("token");
    FleetStack.deletelocal("userdetails");

    Get.offAll(login(), predicate: (route) => false);

    // Get.to(login());
  }

  void logoclick() async {
    print("logo click");
    var result = await FleetStack.getauthdata('getAllDeviceStatus');
    //var  result =  await FleetStack.getauthdata('getDevices');
    print(result);
  }

  delnotifytoken() async {
    var token = await LocalNotificationService.notifytoken();

    Map<String, dynamic> postdata = {};
    postdata["playerid"] = token;
    var result = await FleetStack.delauthdata('delPlayerId', postdata);
  }
}
