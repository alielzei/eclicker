// import 'package:flutter/foundation.dart';

// @immutable 
// class User {
//   const User({@required this.uid});
//   final String uid;
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  FirestoreService({ this.user });
  final dynamic user;

  Future<QuerySnapshot> getUserFeed() async {
    return Firestore.instance
      .collection('users/${user.uid}/feed')
      .getDocuments();
  }
  
  Future<void> postPoll({
    String title,
    List<String> options,
    // todo: room
  }) {
    print(user.uid);
    Firestore.instance
    .collection('users/${user.uid}/polls')
    .add({
      "title": title,
      "options": options
    });
  }

}