import 'package:flutter/material.dart';
import 'package:groupr/pages/authentication/authentication.dart';
import 'package:groupr/pages/scanner/home.dart';
import 'package:groupr/pages/scanner/todo.dart';
import 'package:provider/provider.dart';
import 'package:groupr/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // This means that the user logged out or is not valid.
    if (user == null){
      return Authentication();
    }
    // Otherwise, it's a valid user, so show the home page.
    else {
      return Todo();
    }
  }
}
