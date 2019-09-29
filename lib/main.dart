import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  String appTitle = 'Flutter Login Demo';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(auth: new Auth())
    );
  }
}