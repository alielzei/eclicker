import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable 
class User {
  const User({@required this.uid});
  final String uid;
}

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  User user;

  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signUp({
    String email,
    String password
  }) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User> signIn({
    String email, 
    String password
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    return _userFromFirebase(authResult.user);
  }
  
}