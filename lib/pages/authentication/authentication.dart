import 'package:flutter/material.dart';
import 'package:groupr/pages/authentication/login.dart';
import 'package:groupr/pages/authentication/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showLogin = true;

  void toggleShowLogin() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin == true) {
      return Login(toggleView: toggleShowLogin);
    }
    else {
      return Register(toggleView: toggleShowLogin);
    }
  }
}
