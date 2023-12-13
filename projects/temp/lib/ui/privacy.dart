import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/widgets.dart';

class privacy extends StatelessWidget {
  const privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('privacy_policy'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Text("Welcome to the Fleet Stack's mobile application ( Fleet Stack).",
                style: TextStyle(height: 1.4),),
                SizedBox(height: 20),
                Text("We understand that privacy is important to you, and we are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and share your personal information when you use the App.",
                    style: TextStyle(height: 1.4) ),
                SizedBox(height: 20),
                Text("Collection of Personal Information", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("When you use the App, we may collect certain personal information about you, including:" , style: TextStyle(height: 1.4)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- Your name and contact information, such as your email address and phone number"  , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- Your location data, including GPS coordinates and other information about your location"  , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- Information about your device, such as the type of device you are using and your device's unique identifier"  , style: TextStyle(height: 1.4)),
                  ],
                ),
                SizedBox(height: 20),
                Text("Use of Personal Information", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("We use the personal information we collect through the App for a variety of purposes, including:"  , style: TextStyle(height: 1.4)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- To provide and improve the App and our services"  , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- To communicate with you about the App and our services"  , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- To personalize your experience with the App"  , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- To protect the security and integrity of the App and our systems"  , style: TextStyle(height: 1.4)),
                  ],
                ),
                SizedBox(height: 20),
                Text("Sharing of Personal Information", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("We may share your personal information with third parties in the following circumstances:" , style: TextStyle(height: 1.4)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- With service providers and contractors who perform services on our behalf, such as hosting and maintenance services" , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- With law enforcement or other government agencies, if required by law or in response to a valid request" , style: TextStyle(height: 1.4)),
                    SizedBox(height: 4),
                    Text("- In the event that we sell or transfer all or a portion of our business or assets, your personal information may be transferred as part of that transaction" , style: TextStyle(height: 1.4)),
                  ],
                ),
                SizedBox(height: 20),
                Text("Security of Personal Information", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("We take steps to protect your personal information from unauthorized access, use, or disclosure. However, no security measures are perfect, and we cannot guarantee the security of your personal information." , style: TextStyle(height: 1.4)),
                SizedBox(height: 20),
                Text("Changes to this Privacy Policy", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("We may update this Privacy Policy from time to time to reflect changes to our practices or for other operational, legal, or regulatory reasons. If we make any material changes to this Privacy Policy, we will post the updated policy on this page and encourage you to review it." , style: TextStyle(height: 1.4)),
                SizedBox(height: 20),
                Text("Contact Us", style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 10),
                Text("If you have any questions or concerns about this Privacy Policy, please contact us by email at info@fleetstack.in " , style: TextStyle(height: 1.4)),
                SizedBox(height: 20),
                Text("Thank you for using the Fleet Stack mobile application." , style: TextStyle(height: 1.4)),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
