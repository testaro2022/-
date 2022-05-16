import 'package:flutter/material.dart';
import 'package:janken/ges.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String? text;
  String? url;
  List<String> hashtags = [];
  String? via;
  String? related;

  // _ScorePageState(
  //     {Key? key,
  //     @required this.text,
  //     this.url = "",
  //     this.hashtags = const [],
  //     this.via = "",
  //     this.related = ""});

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
                  width: 200,
                  height: 200,
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(4),
                    },
                    // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      for (var i in recordlist..sort())
                        if (recordlist.indexOf(i) < 5)
                          TableRow(children: [
                            Text(" no${recordlist.indexOf(i) + 1}:"),
                            Text(" $i"),
                          ]),
                    ],
                  ),
                ),
              ],
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
        )

            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     for (var i in recordlist..sort())
            //       if (recordlist.indexOf(i) < 5)
            //         Text("第${recordlist.indexOf(i) + 1}位:$i"),
            //     ElevatedButton(
            //         onPressed: () {
            //           Navigator.pushNamedAndRemoveUntil(
            //               context, "/home", (_) => false);
            //         },
            //         child: Text("最初に戻る")),
            //   ],
            // ),
            ));
  }
}
