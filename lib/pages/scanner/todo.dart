import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupr/pages/globals.dart';
import 'package:groupr/pages/services/auth.dart';

class Todo extends StatefulWidget {
  @override
  TodoState createState() {
    return TodoState();
  }
}

class TodoState extends State<Todo> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String body;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${doc.data['body']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  getUserTasks() {
    return Firestore.instance.collection('Todo').where('user', isEqualTo: currentUser).getDocuments();
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Body',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => body = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Groupr'),
          actions: <Widget>[
          FlatButton.icon(
          icon: Icon(Icons.exit_to_app, color: Colors.white,),
          label: Text('Logout',
            style: TextStyle(color: Colors.white), ),
          onPressed: () async {
            await _auth.logout();
        },
        ),
     ]),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.indigo,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('Todo').where('user', isEqualTo: currentUser).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('Todo').add({'body': '$body', 'user':'$currentUser'});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  updateData(DocumentSnapshot doc) async {
    var text = TextEditingController();
    String input;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Task'),
          content: TextField(
            controller: text,
            decoration: InputDecoration(hintText: 'Body'),
          ),
          actions: <Widget> [
            new FlatButton(
              child: new Text('Update'),
              onPressed: () {
                input = text.text;
                update(doc, input);
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  void update(DocumentSnapshot doc, String text) async {
    await db.collection('Todo').document(doc.documentID).updateData({'body' : '$text'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('Todo').document(doc.documentID).delete();
    setState(() => id = null);
  }
}