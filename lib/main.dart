import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home_page.dart';
import 'login_signin_page.dart';

FirebaseUser firebaseUser;
final auth = new Auth();
final firebaseAuth = FirebaseAuth.instance;

Future main() async {
  firebaseUser = await firebaseAuth.currentUser();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  String appTitle = 'Flutter Login Demo';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: appTitle,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _chooseStartingPage());
  }

  Widget _chooseStartingPage() {
    if (firebaseUser != null) {
      return new HomePage(auth: auth);
    } else {
      return new LoginSignInPage(auth: auth);
    }
  }
}
