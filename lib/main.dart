import 'howtoplay.dart';
import 'package:flutter/material.dart';
import 'ges.dart';
import 'score.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '後だしじゃんけん',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '後出しじゃんけん'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MyHomePage(title: '後出しじゃんけん'),
        '/gamepage': (BuildContext context) => new GamePage(title: '後出しじゃんけん'),
        '/scorepage': (BuildContext context) => new ScorePage(title: 'レコード'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            SizedBox(
              width: 200,
              height: 80,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamePage(title: "後出しじゃんけん")),
                    );
                  },
                  child: Text("スタート")),
            ),
            SizedBox(
              width: 20.0,
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 80,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HowtoPage(title: "遊び方")),
                    );
                  },
                  child: Text("遊び方")),
            ),
          ],
        ),
      ),
    );
  }
}
