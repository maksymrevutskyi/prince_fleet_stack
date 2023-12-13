import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../code/login_code.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

   final login_code stack = Get.put(login_code());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 30,
                        width: 80,
                        height: 440,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                  AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        right: -15,
                        top: 75,
                        width: 185,
                        height: 140,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/car.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 120),
                          child: Center(
                            child: Text(
                              "user_login".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            stack.demologin();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Center(
                              child: Text(
                                "demo_login".tr,
                                style: TextStyle(
                                    color: Color(0xFF2663ed),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 95,
                        width: 258,
                        height: 85,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                  AssetImage('assets/images/logo-bg.png'))),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        top: 109,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 228,
                              height: 56,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Image.asset(
                //         'assets/images/logo.png',
                //         width: 320,
                //         height: 120,
                //         fit: BoxFit.fitWidth,
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[




                            TextField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xFF5b73e8)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "username_email".tr,
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  // color: appStore.iconColor,
                                  size: 25,
                                ),
                                filled: true,
                              ),
                              textInputAction: TextInputAction.done,
                              controller: stack.usernameController,
                            ),

                            SizedBox(
                              height: 30.0,
                            ),

                            TextField(
                              // style: primaryTextStyle(),
                              // obscureText: passwordVisible,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'password'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 25,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xFF5b73e8)),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(stack.passwordText ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        stack.passwordText = !stack.passwordText;
                                      });
                                    },
                                  )),
                              obscureText: stack.passwordText,
                              controller: stack.passwordController,
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),



                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, '/home');
                         stack.loginsubmit();

                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(0, 84, 255, 1),
                                Color.fromRGBO(0, 84, 255, .6),
                              ])),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:  [
                              SizedBox(
                                width: 25.0,
                              ),
                             Text("login_account".tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "-- OR --",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       gradient: LinearGradient(colors: [
                      //         Color.fromRGBO(255, 255, 255, 1),
                      //         Color.fromRGBO(255, 255, 255, .6),
                      //       ]),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey, //New
                      //           blurRadius: 25.0,
                      //         )
                      //       ],
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           SizedBox(
                      //             width: 30.0,
                      //           ),
                      //           Image.asset(
                      //             'assets/images/google-icon.png',
                      //             width: 30,
                      //             height: 30,
                      //             fit: BoxFit.cover,
                      //           ),
                      //           Text(
                      //             "sign_in_google".tr,
                      //             style: TextStyle(
                      //                 color: new Color(0xFF175ff0),
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //           SizedBox(
                      //             width: 30.0,
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                      SizedBox(
                        height: 25.0,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('dont_have_account'.tr),
                      //     Text(
                      //       'sign_up'.tr,
                      //       style: TextStyle(
                      //         color: Color(0xFF175ff0),
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 35.0,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/externallogin');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'external_tracking'.tr,
                              style: TextStyle(
                                color: Color(0xFF175ff0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'all_rights_reserved'.tr,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
