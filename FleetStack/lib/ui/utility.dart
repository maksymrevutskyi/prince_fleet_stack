import '/code/history_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets.dart';
import 'history.dart';
import 'immobilize.dart';
import 'parking.dart';
import 'replay.dart';
import 'reports.dart';
import 'tracklink.dart';

class utility extends StatelessWidget {
  const utility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset('assets/images/back.png'),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 120,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  "utility".tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    // fontFamily:
                                    // FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    letterSpacing: 0.0,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 120,
                              bottom: 12,
                              top: 4,
                              right: 16,
                            ),
                            child: Text(
                              'utility_to_optimize_fleet'.tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     Text('Utility',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     )
            //   ],
            // ),

            SizedBox(height: 25),

            nav(
                iconsrc: Icon(Icons.play_circle_outline,
                    color: Color(0xff2e2e2f), size: 30),
                title: 'replay'.tr,
                des: 'checkout_playback_history'.tr,
                navtap: () {
                  Get.to(
                    replay(deviceid: '0,28.629866,77.219684,Stop,car'),
                  );
                }),
            nav(
                iconsrc: Icon(Icons.manage_search,
                    color: Color(0xff2e2e2f), size: 30),
                title: 'history'.tr,
                des: 'vehicle_driven_history'.tr,
                navtap: () {
                  Get.to(() => history())!
                      .then((value) => Get.delete<history_code>());
                }),
            // nav( iconsrc : Icon(Icons.timeline, color: Color(0xff2e2e2f), size: 30), title: 'Advance Tracking', des: 'the timeline help you to analysis fleet driven' , navtap: (){
            //   Navigator.pushNamed(context, '/advancetracking');
            // } ),
            nav(
                iconsrc: Icon(Icons.local_parking,
                    color: Color(0xff2e2e2f), size: 30),
                title: 'parking'.tr,
                des: 'manage_vehicle_parking'.tr,
                navtap: () {
                  Get.to(parking());
                }),
            nav(
                iconsrc: Icon(Icons.lock, color: Color(0xff2e2e2f), size: 30),
                title: 'remote_stop'.tr,
                des: 'force_stop_resume_vehicle'.tr,
                navtap: () {
                  Get.to(immobilize());
                }),
            nav(
                iconsrc:
                    Icon(Icons.description, color: Color(0xff2e2e2f), size: 30),
                title: 'reports'.tr,
                des: 'get_fleet_related_reports'.tr,
                navtap: () {
                  Get.to(reports());
                }),
            nav(
                iconsrc:
                    Icon(Icons.add_link, color: Color(0xff2e2e2f), size: 30),
                title: 'track_link'.tr,
                des: 'create_share_external_tracking'.tr,
                navtap: () {
                  Get.to(tracklink());
                }),
          ],
        ),
      ),
    );
  }
}
