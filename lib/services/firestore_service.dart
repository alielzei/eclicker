import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class UserProfile {
  String name;
  String username;

  UserProfile({
    this.name,
    this.username,
  });

  factory UserProfile.fromSnapshot(snapshot){
    return UserProfile(
      name: snapshot.data['name'],
      username: snapshot.data['username'],
    );
  }
}

@immutable
class PollPost{
  final String title;
  final List<String> options;

  PollPost({
    @required this.title,
    @required this.options,
  });
}

@immutable
class FeedPost {
  final String docId;
  final String title;
  final String room;

  FeedPost({
    this.docId,
    this.title,
    this.room,
  });

  factory FeedPost.fromSnapshot(DocumentSnapshot snap){
    return snap == null ? null : FeedPost(
      docId: snap.documentID,
      title: snap.data['title'],
      room: snap.data['room']
    );
  }

}

@immutable
class FindUserResult {
  final String username;
  final String uid;
  final String email;
  final String name;

  FindUserResult({
    this.username,
    this.uid,
    this.email,
    this.name,
  });

  factory FindUserResult.fromSnapshot(DocumentSnapshot snapshot){
    return FindUserResult(
      username: snapshot.documentID,
      uid: snapshot['uid'],
      email: snapshot.data['email'],
      name: snapshot.data['name'],
    );
  }
}

class FirestoreService{
  FirestoreService({ this.me });
  final dynamic me;

  // acccount_page.dart
  Future<UserProfile> getUserProfile() async {
    final snapshot = await Firestore.instance
      .document('users/${me.uid}').get();
    
    return UserProfile.fromSnapshot(snapshot);
  }

  Future<bool> changeUsername(String newUsername) async {
    // separate this afterward
    final usernameSnap = await Firestore.instance
      .document('users/${me.uid}/usernames/$newUsername')
      .get();

    if(usernameSnap.data != null)
      return false;

    // this should not be allowed
    // or maybe done differently
    await Firestore.instance
      .document('usernames/$newUsername')
      .setData({
        "uid": me.uid,
      });
    
    return true;
  }
  
  // home_page.dart
  Future<List<FeedPost>> getUserFeed() async {
    final postsQuery = await Firestore.instance
      .collection('users/${me.uid}/feed')
      .getDocuments();

    return postsQuery.documents.map(
      (snap) => FeedPost.fromSnapshot(snap)
    ).toList();
  }

  // create_poll_page.dart
  Future<void> postPoll(PollPost pollPost) async {
    await Firestore.instance
      .collection('users/${me.uid}/posts')
      .add({
        "title": pollPost.title,
        "options": pollPost.options
      });
  }

  // follow_user.dart
  Future<FindUserResult> findUser(String username) async {
    if(username.length > 0){
      final usernameSnap = await Firestore.instance
        .document('usernames/$username').get();
      return usernameSnap.data != null
      ? FindUserResult.fromSnapshot(usernameSnap) : null;
    }

    return null;
  }

  Future<void> followUser(FindUserResult user) async {
    await Firestore.instance
      .document('users/${user.uid}/followers/${me.uid}')
      .setData({});
    return;
  }

}