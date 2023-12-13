import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../common/widgets.dart';


class tutorials extends StatefulWidget {
  const tutorials({Key? key}) : super(key: key);

  @override
  State<tutorials> createState() => _tutorialsState();
}

class _tutorialsState extends State<tutorials> {
  final List<YoutubePlayerController> _controllers = [
    'kSGuHeTPyic',
    '7CoLyTZuh_k',
    'eC71LI_oyBw',
    '2ju5w3ihFco',
    '0eq-_c5jdgU',


  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    ),
  )
      .toList();



  final List<Map<String, dynamic>> Content = [
    {'vkey': 'kSGuHeTPyic','title': 'Mobile Application Overview', 'des': "Tracking Vehicle through Mobile application"},
    {'vkey': '7CoLyTZuh_k','title': 'Web panel vehicle Tracking overview', 'des': "Tracking Vehicle through Web Dashboard"},
    {'vkey': 'eC71LI_oyBw','title': 'Web panel Map Selection', 'des': "how you can track vehicle with multiple map interfaces."},
    {'vkey': '2ju5w3ihFco','title': 'Web panel Vehicle History', 'des': "web based interface for vehicle history"},
    {'vkey': '0eq-_c5jdgU','title': 'Web panel Vehicle Replay', 'des': "web based interface for vehicle Replay"},

  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.gray,
      appBar: AppBar(
        title: Text('tutorials'.tr),
        backgroundColor: appcolor.white,
        foregroundColor: appcolor.lightblack,

      ),
      body:  ListView.separated(
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
              margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFf6f9ff),
                      Color(0xFFf6f9ff)
                    ]
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 25.0,
                  )
                ],
              ),
            child: Column(
              children: [

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text( Content[index]["title"],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: appcolor.black,
                              ),)
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              width: appcolor.width/1.5,
                              child: Text(Content[index]["des"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          Share.share(
                             Content[index]["title"].toString() +' \n Video Link:  https://www.youtube.com/watch?v='+Content[index]["vkey"].toString() ,
                              subject: Content[index]["title"]);
                        },
                        child: Icon(Icons.share))
                  ],
                ),


                SizedBox(height: 10),
                // YoutubePlayer(
                //   key: ObjectKey(_controllers[index]),
                //   controller: _controllers[index],
                //   actionsPadding: const EdgeInsets.only(left: 16.0),
                //   bottomActions: [
                //     CurrentPosition(),
                //     const SizedBox(width: 10.0),
                //     ProgressBar(isExpanded: true),
                //     const SizedBox(width: 10.0),
                //     RemainingDuration(),
                //     FullScreenButton(),
                //   ],
                // ),

                YoutubePlayer(
                  key: ObjectKey(_controllers[index].toString()),
                  controller:  _controllers[index],
                  actionsPadding: const EdgeInsets.only(left: 16.0),
                  bottomActions: [
                    CurrentPosition(),
                    const SizedBox(width: 10.0),
                    ProgressBar(isExpanded: true),
                    const SizedBox(width: 10.0),
                    RemainingDuration(),
                    FullScreenButton(),
                  ],
                ),



              ],
            )
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
