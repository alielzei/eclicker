import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:eclicker_flutter/app/auth/auth_widget.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


//todo: put this somewhere else
ThemeData appTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.black,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: InputBorder.none,
  ),
  buttonColor: Colors.black,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    textTheme: TextTheme()
  ),
);

void main() => runApp(Eclicker());

class Eclicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        theme: appTheme,
        home: AuthWidget()
      ),
    );
  }
}