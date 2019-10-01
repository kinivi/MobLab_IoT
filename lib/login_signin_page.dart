import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home_page.dart';
import 'login_signup_page.dart';

// ENUM for togling form mode
enum FormMode { LOGIN, SIGNUP }

class LoginSignInPage extends StatefulWidget {
  LoginSignInPage({this.auth});
  final BaseAuth auth;

  @override
  _LoginSignInPageState createState() => _LoginSignInPageState();
}

class _LoginSignInPageState extends State<LoginSignInPage> {
  //Init key for working with form
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  String signedInString = "Signed in: ";
  String signedUpString = "Signed up: ";
  String appTitle = "Flutter login demo";
  String hintEmail = "Email";
  String hintPassword = "Password";
  String errorEmptyPassword = 'Password can\'t be empty';
  String errorEmptyEmail = 'Email can\'t be empty';
  String errorShortPassword = 'Password is too short';
  String errorEmptyPhone = 'Phone can\'t be empty';
  String errorShortName = 'Name is too short';
  String createAccountText = 'Create an account';
  String signinText = 'Have an account? Sign in';
  String errorEmptyName = 'Name can\'t be empty';
  String loginText = 'Login';

  bool _isIos;
  bool _isLoading;

// Check if form is valid
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print(signedInString + '$userId');

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => new HomePage(auth: widget.auth)),
              (Route<dynamic> route) => false);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Inital state
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get appropriate platform
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(appTitle),
      ),
      body: new Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 50.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/iot.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: hintEmail,
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? errorEmptyEmail : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: hintPassword,
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) return errorEmptyPassword;
          if (value.length < 8) return errorShortPassword;
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text(loginText,
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: new Text(createAccountText,
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: () => {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginSignUpPage(auth: widget.auth)))
      },
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
