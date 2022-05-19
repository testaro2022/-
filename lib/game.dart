import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'score.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> recordlist = [];

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  int jankenCounter = 1;
  String? nowJanken; //先に出されたじゃんけん
  bool? nowOrder; //勝つか負けるかの指示
  bool? jankenResult; //正解か不正解か

  String? scoretime; //タイム記録用
  Stopwatch stopwatch = Stopwatch();
  int _timecounter = 0; //カウントダウン用の変数

  void GenOrder() {
    int? orderseed;
    setState(() {
      orderseed = Random().nextInt(100);
    });
    if (orderseed! % 2 == 0) {
      setState(() {
        nowOrder = true;
      });
    } else {
      setState(() {
        nowOrder = false;
      });
    }
  }

  void GenGesture() {
    int? gesseed;
    setState(() {
      gesseed = Random().nextInt(100);
    });
    if (gesseed! % 3 == 0) {
      setState(() {
        nowJanken = "gu";
      });
    } else if (gesseed! % 3 == 1) {
      setState(() {
        nowJanken = "choki";
      });
    } else {
      setState(() {
        nowJanken = "pa";
      });
    }
  }

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

  void HandleStopwatch(bool finishflag) {
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

  void janken(String ges) {
    if (Judge(ges)) jankenCounter++;
    if (jankenCounter != 10) {
      setState(() {
        Judge(ges) ? jankenResult = true : jankenResult = false;
      });
    }
    HandleStopwatch(jankenCounter == 10);
  }

  bool Judge(String playerges) {
    if (playerges == "gu" && nowJanken == "pa" && nowOrder == false) {
      return true;
    } else if (playerges == "gu" && nowJanken == "choki" && nowOrder == true) {
      return true;
    } else if (playerges == "choki" && nowJanken == "gu" && nowOrder == false) {
      return true;
    } else if (playerges == "choki" && nowJanken == "pa" && nowOrder == true) {
      return true;
    } else if (playerges == "pa" && nowJanken == "choki" && nowOrder == false) {
      return true;
    } else if (playerges == "pa" && nowJanken == "gu" && nowOrder == true) {
      return true;
    } else {
      return false;
    }
  }

  String orderpath() {
    if (jankenResult == null) {
      return "images/mu.png";
    } else {
      if (jankenResult!) {
        return "images/mark_maru.png";
      } else
        return "images/mark_batsu.png";
    }
  }

  @override
  void initState() {
    super.initState();
    _getStringList();
    GenGesture();
    GenOrder();

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
                    '$jankenCounter/10', //今何回目のじゃんけんか
                  ),
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('images/janken_${nowJanken}.png')),
                  Text(
                    //勝つか負けるかの指示
                    nowOrder! ? "勝ってください" : "負けてください",
                    style: TextStyle(
                        color: (nowOrder!) ? Colors.red : Colors.blue,
                        fontSize: 34),
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
                    //選択肢(gu,choki,pa)
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var ges in ["gu", "choki", "pa"])
                        GestureDetector(
                            onTap: () {
                              janken(ges);
                              GenOrder();
                              GenGesture();
                            },
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child:
                                    Image.asset("images/janken_${ges}.png"))),
                    ],
                  ),
                ],
              ),
              Visibility(
                //ゲーム終了後の画面
                visible: jankenCounter >= 10,
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
                //最初のカウントダウン
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
