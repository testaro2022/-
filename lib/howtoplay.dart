import 'package:flutter/material.dart';

class HowtoPage extends StatefulWidget {
  const HowtoPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HowtoPage> createState() => _HowtoPageState();
}

class _HowtoPageState extends State<HowtoPage> {
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
            children: <Widget>[
              Text(
                "遊び方",
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "画面中央の指示に従って,じゃんけんをしてください.\n"
                "必ずしもじゃんけんに勝つことが正解とは限りません.\n"
                "指示に従ってじゃんけんをしてください.\n"
                "10回正解するまでの時間があなたのスコアになります.\n"
                "いい成績を目指して頑張ってみてください.\n",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ));
  }
}
