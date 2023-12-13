import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/widgets.dart';

class vehiclesetting extends StatelessWidget {
  const vehiclesetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('HR25 HN 2565'),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),

                Text("Vehicle Setting to modify details"
                  , style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),),


                SizedBox(
                  height: 40.0,
                ),

                SizedBox(
                  width: 183,
                  height: 45,
                  child: Image.asset(
                      'assets/images/logo.png'),
                ),

                SizedBox(
                  height: 40.0,
                ),

                GestureDetector(
                  onTap: (){
                    //  stack.logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('all_rights_reserved'.tr,
                          style: TextStyle(
                            color: appcolor.grayblack ,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )
                      ),



                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
