import 'package:eclicker_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowUser extends StatefulWidget {
  @override
  _FollowUserState createState() => _FollowUserState();
}

class _FollowUserState extends State<FollowUser> {

  final _searchInput = new TextEditingController();

  FindUserResult _searchResult;
  String _message;

  bool _gettingUser = false;
  bool _addingUser = false;
  bool _addedUser = false;

  void _onSubmit(){
    setState(() {
      _gettingUser = true;
    });
    final database = Provider.of<FirestoreService>(context, listen: false);
    database.findUser(_searchInput.text).then((FindUserResult result){
      _searchInput.clear();
      setState(() {
        _gettingUser = false;
        _addingUser = false;
        _addedUser = false;
        _searchResult = result;
        _message = null;
        if(result == null)
          _message = "Could not find this username";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find')
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildField(),
          _buildButton(),
          _buildResult()
        ],
      )
    );
  }

  Widget _buildField(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: _searchInput,
        decoration: InputDecoration(
          hintText: 'Username'
        ),
      ),
    );
  }

  Widget _buildButton(){
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      height: 48.0,
      child: _gettingUser 
      ? Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()))
      : RaisedButton(
        onPressed: _onSubmit,
        child: Text('Go')
      ),
    );
  }

  Widget _buildResult(){
    if (_searchResult != null)
      return Card(
        child: ListTile(
          title:  Text('${_searchResult.name}'),
          subtitle: Text('${_searchResult.email}'),
          trailing: _addingUser
          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
          : IconButton(
            onPressed: (){
              setState(() {
                _addingUser = true;
              });
              final database = Provider.of<FirestoreService>(context, listen: false);
              database.followUser(_searchResult).then((v){
                setState(() {
                  _addingUser = false;
                  _addedUser = true;
                });
              });
            },
            color: Colors.black,
            iconSize: 30.0,
            icon: _addedUser ? Icon(Icons.done) : Icon(Icons.add_circle)
          ),
        )
      );
    
    if(_message != null)
      return Center(
          child: Text("$_message", style: Theme.of(context).textTheme.subtitle2),
        );

    return Container();
  }

}