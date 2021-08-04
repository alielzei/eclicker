import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_page.dart';
import 'follow_user_page.dart';
import 'create_poll_page.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(child: Container()),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildAccount(context),
                _buildFollowUser(context),
                _buildCreatePoll(context),
              ],
            ),
          ),
          _buildLogout(context),
        ],
      ),
    );
  }

  Widget _buildAccount(BuildContext context){
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Account'),
      onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AccountPage()
          ));
      }
    );
  }

  Widget _buildFollowUser(BuildContext context){
    return ListTile(
      leading: Icon(Icons.person_add),
      title: Text('Follow user'),
      onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => FollowUser()
          ));
      }
    );
  }

  Widget _buildCreatePoll(BuildContext context){
    return ListTile( 
      leading: Icon(Icons.create),
      title: Text('Create a poll'),
      onTap: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CreatePollPage()
        ));
      }
    );
  }

  Widget _buildLogout(BuildContext context){
    return ListTile( 
      leading: Icon(Icons.power_settings_new),
      title: Text('Logout'),
      onTap: (){
        final authService = Provider.of<AuthService>(context, listen: false);
        authService.signOut();
      },
    );
  }

}