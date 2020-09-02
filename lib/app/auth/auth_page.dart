import 'package:eclicker_flutter/app/auth/signin_form.dart';
import 'package:eclicker_flutter/app/auth/signup_form.dart';

import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool _signInView = true;

  void _toggleView(){
    setState(() {
      _signInView = !_signInView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign ${!_signInView ? 'in' : 'up'}'),),
      body: 
      Column(
        children: [
          Expanded(child: Center(child: Text('some details'))),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: _signInView ? SignUpForm() : SignInForm(),
            transitionBuilder: (child, animation) => SlideTransition(
              child: child,
              position: Tween(
                begin: Offset(1.0, 0.0),
                end: Offset(0.0, 0.0)
              ).animate(animation),
            ),
          ),
          Expanded(child: Container()),
          _buildAlternateButton()
        ],
      )
    );
  }

  Widget _buildAlternateButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FlatButton(
        onPressed: (){
          _toggleView();
        },
        child: Text('Sign ${_signInView ? 'in' : 'up'} instead'),
      ),
    );
  }

}
