import 'package:flutter/material.dart';

import 'authentication.dart';
import 'login_signin_page.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userId = "";
  String _userName = "";
  String signOutButtonText = "Sign Out";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.uid;
        }
      });
    });
  }

  void _onSignedOut() {
    widget.auth.signOut();
    setState(() {
      _userId = "";
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LoginSignInPage(auth: widget.auth)),
        (Route<dynamic> route) => false);
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.length > 0 && _userId != null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter login demo"),
        ),
        body: new ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
          _showBoy(),
          new Text("uID!!!: " + _userId),
          new Text("Name: " + _userName),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),
          ),
          new MaterialButton(
            elevation: 5.0,
            minWidth: 100.0,
            height: 50.0,
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text(signOutButtonText),
            onPressed: _onSignedOut,
          )
        ]),
      );
    } else
      return _buildWaitingScreen();
  }

  Widget _showBoy() {
    return new Hero(
      tag: 'boy',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 30.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/fboy.png'),
        ),
      ),
    );
  }
}
