import 'package:flutter/material.dart';

import './load_repos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 5KB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowRepo(),
    );
  }
}
