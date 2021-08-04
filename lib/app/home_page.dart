import 'package:eclicker_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_drawer.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeedPost> feedPostsxyz = [];

  @override
  void initState() {
    super.initState();
    fetchNewPollTitles();
  }

  Future<void> fetchNewPollTitles() async {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final posts = await firestoreService.getUserFeed();
    setState(() {
      feedPostsxyz = posts;
    });
  }

  void _onTileTap(documentId){
    print(documentId);
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text('$documentId')
          )
        );
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      drawer: MainDrawer(),
      body: _buildTiles()
    );
  }

  Widget _buildTiles(){
    return feedPostsxyz == null 
    ? Center(
      child: CircularProgressIndicator()
    )
    : RefreshIndicator(
      onRefresh: fetchNewPollTitles,
      child: ListView.separated(
        itemCount: feedPostsxyz.length,
        itemBuilder: (context, index){
          return _buildTile(feedPostsxyz[index]);
        },
        separatorBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Divider(height: 0,),
          );
        },
      ),
    );
  }

  Widget _buildTile(FeedPost feedPost){
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _onTileTap(feedPost.docId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAvatar(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle(feedPost.title),
                      _buildRoom(feedPost.room),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget _buildAvatar(){
    //Avatar
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(),
    );
  }

  Widget _buildTitle(title){
    return Text('$title', 
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
      )
    );
  }

  Widget _buildRoom(room){
    //Room
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text('$room',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}