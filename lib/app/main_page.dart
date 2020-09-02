import 'package:eclicker_flutter/app/profile_page.dart';
import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feed_page.dart';

class MainPage extends StatefulWidget {
  final List<IconData> _bottomBarIcons = [
    Icons.home,
    Icons.person,
  ];

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedBottomTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        FlatButton(
          onPressed: () async {
            final auth = Provider.of<AuthService>(context, listen: false);
            await auth.signOut();
          },
          child: Text('logout')
        )
      ],),
      body: IndexedStack(
        index: _selectedBottomTab, 
        children: <Widget>[
          FeedPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildBottomBarItem(int i){
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() { _selectedBottomTab = i;}),
        child: Icon(widget._bottomBarIcons[i],
          color: i == _selectedBottomTab ? null : Color.fromRGBO(0, 0, 0, 0.4)
        )
      ),
    );
  }

  Widget _buildBottomBar(){
    return Container(
      color: Theme.of(context).primaryColor,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          widget._bottomBarIcons.length, (i) => _buildBottomBarItem(i)
        ),
      ),
    );
  }
}