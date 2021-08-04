
import 'package:eclicker_flutter/app/home_page.dart';
import 'package:eclicker_flutter/services/auth_service.dart';

import 'package:flutter/material.dart';

import 'auth_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if(userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : AuthPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      )
    );

  }
}