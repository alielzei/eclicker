import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:eclicker_flutter/app/auth/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/auth/auth_widget_builder.dart';

//todo: put this somewhere else
ThemeData appTheme = ThemeData(
  primaryColor: Colors.teal,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: InputBorder.none,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
  ),
);

void main() => runApp(Eclicker());

class Eclicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: AuthWidgetBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: appTheme,
            home: AuthWidget(userSnapshot: userSnapshot)
          );
        }
      ),
    );
  }
}