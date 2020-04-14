import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupr/pages/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:groupr/pages/services/database.dart';
import 'generate.dart';
import 'scan.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().groups,
        child: Scaffold(
          backgroundColor: Colors.indigo[100],
          appBar: AppBar(
            title: Text('Groupr'),
            backgroundColor: Colors.indigo[500],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.exit_to_app, color: Colors.white,),
                label: Text('Logout',
                  style: TextStyle(color: Colors.white), ),
                onPressed: () async {
                  await _auth.logout();
                },
              ),
            ],
          ),
          body: Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: RaisedButton(
                        color: Colors.indigo,
                        textColor: Colors.white,
                        splashColor: Colors.blueGrey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Scan()),
                          );
                        },
                        child: const Text('Scan')
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: RaisedButton(
                        color: Colors.indigo,
                        textColor: Colors.white,
                        splashColor: Colors.blueGrey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Generate()),
                          );
                        },
                        child: const Text('Generate')
                    ),
                  ),
                ],
              )
          ),
        ),
    );

  }
}
