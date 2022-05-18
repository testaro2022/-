import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'score.dart';
import 'package:shared_preferences/shared_preferences.dart';

String gu = "gu";
String choki = "choki";
String pa = "pa";
String gupath = 'images/janken_gu.png';
String chokipath = 'images/janken_choki.png';
String papath = 'images/janken_pa.png';
List<String> recordlist = [];

// TODO リトライで自分に遷移 (リトライ後homeに戻るが消えるのが不満だが直せない5/16)
// TODO UI改善　ボタン位置サイズ　appbar 文字色　背景 scoretable twitterbutton gamepage遷移時にoverlayで321カウントダウン

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  int counter = 1;
  int orderseed = Random().nextInt(100);
  int gesseed = Random().nextInt(100);
  bool flag = false;
  bool? order;
  String? gespath;
  String? nowges;
  bool? noworder;
  bool? visible;
  bool? result;
  int score = 0;
  bool startflag = false;
  String? scoretime;
  Stopwatch stopwatch = Stopwatch();
  int _timecounter = 0;

  void _getStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recordlist = prefs.getStringList('record')!;
    });
  }

  void _setStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('record', recordlist);
  }

  String genorder() {
    setState(() {
      orderseed = Random().nextInt(100);
    });
    if (orderseed % 2 == 0) {
      setState(() {
        noworder = true;
      });
      return "勝ってください";
    } else {
      setState(() {
        noworder = false;
      });
      return "負けて下さい";
    }
  }

  String genges() {
    setState(() {
      gesseed = Random().nextInt(100);
    });
    if (gesseed % 3 == 0) {
      nowges = gu;
      return gupath;
    } else if (gesseed % 3 == 1) {
      nowges = choki;
      return chokipath;
    } else {
      nowges = pa;
      return papath;
    }
  }

  void handlestopwatch(bool finishflag) {
    if (stopwatch.isRunning == false) {
      stopwatch.start();
    }
    if (stopwatch.isRunning == true && finishflag == true) {
      setState(() {
        stopwatch.stop();
        scoretime = "${stopwatch.elapsed}".substring(3);
        recordlist.add("$scoretime");
        stopwatch.reset();
        _setStringList();
      });
    }
  }

  void nextq(String ges) {
    if (judge(ges)) counter++;
    if (counter != 10) {
      if (judge(ges)) {
        setState(() {
          visible = true;
          result = true;
        });
      } else {
        setState(() {
          visible = false;
          result = false;
        });
      }
    } else {
      setState(() {
        flag = true;
      });
    }
    handlestopwatch(counter == 10);
  }

  bool judge(String playerges) {
    if (playerges == gu && nowges == pa && noworder == false) {
      return true;
    } else if (playerges == gu && nowges == choki && noworder == true) {
      return true;
    } else if (playerges == choki && nowges == gu && noworder == false) {
      return true;
    } else if (playerges == choki && nowges == pa && noworder == true) {
      return true;
    } else if (playerges == pa && nowges == choki && noworder == false) {
      return true;
    } else if (playerges == pa && nowges == gu && noworder == true) {
      return true;
    } else {
      return false;
    }
  }

  String orderpath() {
    if (result == null) {
      return "images/mu.png";
    } else {
      if (result!) {
        return "images/mark_maru.png";
      } else
        return "images/mark_batsu.png";
    }
  }

  // AnimationController? controller;
  // Animation<double>? opacityAnimation;
  // Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
    _getStringList();
    Timer.periodic(
      // 第一引数：繰り返す間隔の時間を設定
      const Duration(seconds: 1),
      // 第二引数：その間隔ごとに動作させたい処理を書く
      (Timer timer) {
        _timecounter++;
        if (_timecounter < 4) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 252, 217, 1),
        appBar: AppBar(
          title: Text(widget.title),
          toolbarHeight: 30,
          backgroundColor: Colors.grey,
        ),
        body: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$counter/10',
                  ),
                  SizedBox(
                      width: 100, height: 100, child: Image.asset(genges())),
                  Text(
                    genorder(),
                    style: TextStyle(
                        color:
                            // (genorder() == "勝ってください")
                            (noworder!) ? Colors.red : Colors.blue,
                        fontSize: 34),
                    // style: Theme.of(context).textTheme.headline4,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(orderpath()),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            nextq(gu);
                          },
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset("images/janken_gu.png"))),
                      GestureDetector(
                          onTap: () {
                            nextq(choki);
                          },
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset("images/janken_choki.png"))),
                      GestureDetector(
                          onTap: () {
                            nextq(pa);
                          },
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset("images/janken_pa.png"))),
                    ],
                  ),
                ],
              ),
              Visibility(
                visible: flag,
                child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${scoretime}",
                              style: TextStyle(
                                fontSize: 24,
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil("/gamepage",
                                              ModalRoute.withName("/home"));
                                    },
                                    child: Text("リトライ")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScorePage(title: "レコード")),
                                      );
                                    },
                                    child: Text("レコード")),
                              ]),
                        ])),
              ),
              Visibility(
                visible: !(_timecounter >= 3),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.grey.withOpacity(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${3 - _timecounter}",
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
