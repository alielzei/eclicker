import 'package:eclicker_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {

  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
    appBar: AppBar(
      title: Text("Account")
    ),
    body: FutureBuilder(
      future: db.getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot){
        if(!snapshot.hasData)
          return CircularProgressIndicator();

        _usernameController.text = snapshot.data.username;
        String currentUsername = snapshot.data.username;

        return ListView(
          children: [
            _buildTextField(),
            _buildSaveButton(context, currentUsername)
          ],
        );
      }
    )
      );
  }

  Widget _buildTextField(){
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: "Username",
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, String currentUsername){
    final db = Provider.of<FirestoreService>(context, listen: false);
    return RaisedButton(
      onPressed: (){
        final newUsername = _usernameController.text;
        if(newUsername != currentUsername)
          db.changeUsername(newUsername)
          .then((changed){
            if(changed) currentUsername = newUsername;
            else print('username already exists');
          });
      },
      child: Text("Save")
    );
  }


}