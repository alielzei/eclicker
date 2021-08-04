
import 'package:eclicker_flutter/services/auth_service.dart';

import 'package:eclicker_flutter/services/firestore_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder }) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return user != null 
        ? Provider(
          create: (_) => FirestoreService(me: snapshot.data),
          child: builder(context, snapshot)
        )
        : builder(context, snapshot);
      }
    );
  }
}