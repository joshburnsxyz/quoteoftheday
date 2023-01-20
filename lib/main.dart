import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Quote',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Your Quote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _quote = "";
  String _author = "";
  bool _loading = false;

  Future<http.Response> fetchQuote() async {
    return http.get(Uri.parse('https://zenquotes.io/api/random/'));
  }

  void newQuote() async {
    setState(() => {
      _loading = true
    });
    var res = await fetchQuote();
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var item = body[0];
      print(item);
      setState(() {
        _quote = item['q'];
        _author = item['a'];
      });
    };
    setState(() => { _loading = false });
  }

  @override
  Widget build(BuildContext context) {
    // Bootstrap a new quote
    if (_quote == "") {
      newQuote();
    }

    // Build UI
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_loading) Text('Loading...'),
            Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  '$_quote',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                )),
            Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  '$_author',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newQuote,
        tooltip: 'New Quote',
        child: const Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
