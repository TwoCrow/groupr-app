import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupr/pages/globals.dart';
import 'package:groupr/pages/services/auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupr/pages/services/database.dart';

class Generate extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<Generate> {
  final CollectionReference userCollection = Firestore.instance.collection('users');
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override

//  test() async {
//    var document = await Firestore.instance.collection('users').document("3ecab7e8-c29d-ec5a-0b24-bc983e0b3932")
//        .get().then((docSnap) {
//      var channelName = snapshot['channelName'];
//      assert(channelName is String);
//      return channelName;
//    }));
//    ;
//
//    }

  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        backgroundColor: Colors.indigo[500],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');
          var length = snapshot.data.documents.length;
          DocumentSnapshot ds = snapshot.data.documents[length - 1];
          return Container(
            color: const Color(0xFFFFFFFF),
            child:  Column(
              children: <Widget>[
                Text(""),
                Text(snapshot.data.documents[0]['last']),
                Padding(
                  padding: const EdgeInsets.only(
                    top: _topSectionTopPadding,
                    left: 20.0,
                    right: 10.0,
                    bottom: _topSectionBottomPadding,
                  ),
                  child:  Container(
                    height: _topSectionHeight,
                    child:  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          // This is the drop down menu that allows the user to
                          // choose which group to generate a QR Code for.
                          // Once they pick a group, it will automatically
                          // create a new meeting.
                          child: DropdownButton(

//                              items: snapshot.data.documents.map((DocumentSnapshot document) {
//                                return new DropdownMenuItem<String>(
//                                  value: document.data['title'],
//                                  child: new Container(
//                                    decoration: new BoxDecoration(
//                                      color: Colors.white,
//                                      borderRadius: new BorderRadius.circular(5.0)
//                                    ),
//                                  ),
//                                );
//                              }).toList(),
//                              onChanged: null
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child:  FlatButton(
                            child:  Text("SUBMIT"),
                            onPressed: () {
                              setState((){
                                _dataString = _textController.text;
                                _inputErrorText = null;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child:  Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: QrImage(
                        data: _dataString,
                        size: 0.5 * bodyHeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),

      //_contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');

    } catch(e) {
      print(e.toString());
    }
  }

  getData() async {
    return await userCollection.getDocuments();
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Container(
        color: const Color(0xFFFFFFFF),
        child:  Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: _topSectionTopPadding,
                left: 20.0,
                right: 10.0,
                bottom: _topSectionBottomPadding,
              ),
              child:  Container(
                height: _topSectionHeight,
                child:  Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      // This is the drop down menu that allows the user to
                      // choose which group to generate a QR Code for.
                      // Once they pick a group, it will automatically
                      // create a new meeting.
                      child:  DropdownButton(
                          items: null,
                          onChanged: null
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child:  FlatButton(
                        child:  Text("SUBMIT"),
                        onPressed: () {
                          setState((){
                            _dataString = _textController.text;
                            _inputErrorText = null;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child:  Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: _dataString,
                    size: 0.5 * bodyHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}