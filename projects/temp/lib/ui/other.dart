import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets.dart';
import 'geofence.dart';
import 'poi.dart';
import 'setting.dart';
import 'support.dart';
import 'privacy.dart';
import 'tutorials.dart';


class other extends StatelessWidget {
  const other({Key? key}) : super(key: key);

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
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset(
                                'assets/images/back.png'),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children:  <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 120,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  "other_navigation".tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    // fontFamily:
                                    // FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    letterSpacing: 0.0,
                                    color:
                                    Colors.blueAccent,
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
                              'checkout_application_settings_and_other_utility'.tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                letterSpacing: 0.0,
                                color: Colors.grey
                                    .withOpacity(0.5),
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

            nav( iconsrc : Icon(Icons.add_location_alt, color: Color(0xff2e2e2f), size: 30), title: 'poi'.tr, des: 'add_your_favorite_place_on_map'.tr,
                navtap:(){
              Get.to(poi());
                } ),
            nav( iconsrc : Icon(Icons.maps_ugc_outlined, color: Color(0xff2e2e2f), size: 30), title: 'geofence'.tr, des: 'mark_virtual_boundaries_on_maps_as_geofence'.tr,  navtap:(){ Get.to(geofence());} ),
            nav( iconsrc : Icon(Icons.settings, color: Color(0xff2e2e2f), size: 30), title: 'settings'.tr, des: 'control_your_app_behavior_notifications_and_language'.tr,  navtap:(){ Get.to(setting()); } ),
            nav( iconsrc : Icon(Icons.feedback, color: Color(0xff2e2e2f), size: 30), title: 'feedback'.tr, des: 'share_your_valuable_feedback_to_continuous_improvement'.tr,  navtap:(){ Get.to(support()); } ),
            nav( iconsrc : Icon(Icons.privacy_tip, color: Color(0xff2e2e2f), size: 30), title: 'privacy_policy'.tr, des: 'data_and_privacy_policy_about_application_uses'.tr,  navtap:(){ Get.to(privacy()); } ),
            nav( iconsrc : Icon(Icons.school_rounded, color: Color(0xff2e2e2f), size: 30), title: 'tutorials'.tr, des: 'to_know_more_about_fleet_management_and_application_uses'.tr,  navtap:(){ Get.to(tutorials()); } ),
          // nav( iconsrc : Icon(Icons.school_rounded, color: Color(0xff2e2e2f), size: 30), title: 'tutorials'.tr, des: 'to_know_more_about_fleet_management_and_application_uses'.tr,  navtap:(){ Get.to(newtest()); } ),


          ],

        ),
      ),
    );
  }
}
