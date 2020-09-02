import 'package:eclicker_flutter/app/create_poll_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreatePollPage();
    // return Scaffold(
    //   // appBar: AppBar(
    //   //   title: Text('profile'),
    //   // ),
    //   body: Center(
    //     child: RaisedButton(
    //       onPressed: (){
    //         Navigator.push(context, MaterialPageRoute(
    //           fullscreenDialog: true,
    //           builder: (context){
    //             return CreatePollPage();
    //           }
    //         ));
    //       },
    //       child: Icon(Icons.create),
    //     )
    //   )
    // );
  }
}