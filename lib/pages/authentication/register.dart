import 'package:flutter/material.dart';
import 'package:groupr/pages/loading.dart';
import 'package:groupr/pages/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        title: Text('Register New Groupr Account'),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.arrow_forward, color: Colors.white,),
              label: Text('Login', style: TextStyle(color: Colors.white),),
              onPressed: () {
                widget.toggleView();
              }
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        // Email and password form for login
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text('Sign up with email and password.'),
              SizedBox(height: 20.0),
              // Email
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              // Password
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.vpn_key)
                ),
                obscureText: true,
                validator: (val) => val.length < 5 ? 'Enter a password greater than 5 characters long.' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.indigo,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerAccount(email, password);

                    if (result == null) {
                      loading = false;
                      setState(() => error = 'Please confirm your email before proceeding.');
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
