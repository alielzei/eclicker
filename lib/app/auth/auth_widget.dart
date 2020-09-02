import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:eclicker_flutter/app/main_page.dart';
import 'package:eclicker_flutter/services/firestore_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_page.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null 
          ? Provider(
            create: (_) => FirestoreService(user: snapshot.data),
            child: MainPage()
          )
          : AuthPage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator()
          )
        );
      }
    );
  }
}