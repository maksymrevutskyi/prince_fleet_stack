import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../common/FleetStack.dart';
import '../common/widgets.dart';

import 'login.dart';


class intro extends StatefulWidget {
  const intro({Key? key}) : super(key: key);

  @override
  State<intro> createState() => _introState();
}

class _introState extends State<intro> {

  final _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "title": "10X Accelerate your logistics",
      "subtitle":
      "Automate your business through cutting-edge\n IOT automation tool",
      "image": "assets/images/intro-1.png"
    },
    {
      "title": "Next-Gen Telematics platform",
      "subtitle":
      "Ultimate user experience for Driver behaviour ,\n sensor data , live tracking etc.",
      "image": "assets/images/intro-2.png"
    },
    {
      "title": "Monitor your Fleets",
      "subtitle":
      "Automate your Reports, Routes, \nnotifications & vehicle maintenance.",
      "image": "assets/images/intro-3.png"
    },
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: const Color(0xFF293241),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),

                      AspectRatio(
                        aspectRatio: 12 / 9,
                        child: Image.asset(
                          splashData[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          splashData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF424242),
                          ),
                        ),
                      ),
                      Text(
                        splashData[index]['subtitle']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Sofia",
                          fontSize: 15,
                          color: Colors.grey[400],
                          height: 1.5,
                        ),
                      ),

                      Spacer(),


                    ],
                  );
                },
                onPageChanged: (value) => setState(() => _currentPage = value),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (int index) => _buildDots(index: index),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                  ),
                  Spacer(),

                  GestureDetector(
                    child: Container(
                        height: 50,
                        width: appcolor.width/1.2 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, .6),
                          ]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, //New
                              blurRadius: 25.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 30.0,
                              ),

                              Text(
                                _currentPage + 1 == splashData.length
                                    ? 'Get Started'
                                    : 'Next',
                                style: TextStyle(
                                    //color: new Color(0xFF175ff0),
                                    color: Colors.black ,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.arrow_forward,
                               // color: Color(0xFF175ff0),
                                color: Colors.black ,
                                size: 28,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                            ],
                          ),
                        )),
                    onTap: (){
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                      if(_currentPage == 2)
                      {
                        FleetStack.savelocal('intro', 'true');
                        Get.to(login());
                      }
                    },
                  ),

                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
