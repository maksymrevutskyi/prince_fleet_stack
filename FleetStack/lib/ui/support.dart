import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../code/support_code.dart';
import '../common/widgets.dart';

class support extends StatelessWidget {
   support({Key? key}) : super(key: key);
  final support_code stack = Get.put(support_code());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('support_and_feedback'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),

                TextField(
                  controller: stack.titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'topic_title'.tr,
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: stack.desController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'enter_feedback'.tr,
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
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

                                Text("send_to_admin".tr, style: TextStyle(color:  Colors.black87, fontWeight: FontWeight.bold),),
                                SizedBox(width: 10.0,),
                                Icon(Icons.arrow_forward,
                                  size: 20,),
                                SizedBox(width: 20.0,),
                              ],
                            ),
                          )
                      ),
                      onTap: stack.sendfeedback,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
