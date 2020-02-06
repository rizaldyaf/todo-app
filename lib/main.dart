
import 'package:flutter/material.dart';
import 'activities/Home.dart';

//runner
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  @override //render
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Simple Todo App'),
    );
  }
}