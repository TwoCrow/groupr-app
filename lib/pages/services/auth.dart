import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupr/models/user.dart';
import 'package:groupr/pages/globals.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Creates a new user based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // Stream that updates the screen based on whether the user logged in
  // or did not.
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future loginAccount(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      currentUser = user.uid;
      //('HEY HERE IS THE CURRENT USUER: $currentUser');

      if (user.isEmailVerified) {
        print("Verified email!");
        return _userFromFirebaseUser(user);
      }
      else {
        return null;
      }
    }
    catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future registerAccount(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Wait for the user to confirm email.
      await user.sendEmailVerification();
    }
    catch (e) {
      print(e.toString());

      return null;
    }
  }

  // Signs the user out
  Future logout() async {
    try {
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}