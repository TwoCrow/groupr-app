import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference groupCollection = Firestore.instance.collection('groups');
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get groups {
    return groupCollection.snapshots();
  }

  void getGroups() {
    userCollection.document(uid).get();
  }

}