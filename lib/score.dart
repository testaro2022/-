import 'package:flutter/material.dart';
import 'package:janken/game.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// 余裕があったらtweetボタンをもっとかっこよく

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  //tweet用の変数
  String? text;
  String? url;
  List<String> hashtags = [];
  String? via;
  String? related;
  final int MAX_RECORD_NUM = 5;

  void _tweet() async {
    final Map<String, dynamic> tweetQuery = {
      "text": this.text,
      "url": this.url,
      "hashtags": this.hashtags.join(","),
      "via": this.via,
      "related": this.related,
    };

    final Uri tweetScheme =
        Uri(scheme: "twitter", host: "post", queryParameters: tweetQuery);

    final Uri tweetIntentUrl =
        Uri.https("twitter.com", "/intent/tweet", tweetQuery);

    await canLaunch(tweetScheme.toString())
        ? await launch(tweetScheme.toString())
        : await launch(tweetIntentUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          toolbarHeight: 30,
          backgroundColor: Colors.grey,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(
                          decoration: const BoxDecoration(color: Colors.grey),
                          children: [
                            Text(
                              "NO.",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Score",
                              textAlign: TextAlign.center,
                            ),
                          ]),
                      for (var timescore in recordlist..sort())
                        if (recordlist.indexOf(timescore) <
                            MAX_RECORD_NUM) //上位5位まで表示
                          TableRow(children: [
                            Text(
                              "${recordlist.indexOf(timescore) + 1}",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "$timescore", //記録
                              textAlign: TextAlign.center,
                            ),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 0,
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (_) => false);
                    },
                    child: Text("最初に戻る")),
              ],
            ),
            SizedBox(
              width: 0,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      text = "後出しじゃんけんの最高記録は${recordlist[0]}です";
                      _tweet();
                    },
                    child: Text("No.1のScoreをTweet")),
              ],
            )
          ],
        )));
  }
}
