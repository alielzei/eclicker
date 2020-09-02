import 'package:eclicker_flutter/services/auth_service.dart';
import 'package:eclicker_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context){
            return PollTileListView();
          }
        );
      },
    );
  }
}

class PollTileListView extends StatefulWidget {
  @override
  PollTileListViewState createState() => PollTileListViewState();
}

// class PollTileListViewState extends State<PollTileListView> with AutomaticKeepAliveClientMixin {
class PollTileListViewState extends State<PollTileListView>{

  // @override
  // bool get wantKeepAlive => true;

  List<DocumentSnapshot> pollDocumentSnapshotList;

  @override
  void initState() {
    super.initState();
    fetchNewPollTitles();
  }

  Future<void> fetchNewPollTitles(){
    print('fetching feed');
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);

    // refreshing should only load new titles
    // scrolling down is another thing...
    // lookup pagination or something

    return firestoreService
      .getUserFeed()
      .then((pollsQuerySnapshot){
        setState((){
          pollDocumentSnapshotList = pollsQuerySnapshot.documents;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('feed')),
      body: _buildTiles()
    ); 
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

  Widget _buildTiles(){
    return pollDocumentSnapshotList == null 
    ? Center(
      child: CircularProgressIndicator()
    )
    : RefreshIndicator(
      onRefresh: fetchNewPollTitles,
      child: ListView.separated(
        itemCount: pollDocumentSnapshotList.length,
        itemBuilder: (context, index){
          return _buildTile(pollDocumentSnapshotList[index]);
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

  Widget _buildTile(DocumentSnapshot pollDocumentSnapshot){
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _onTileTap(pollDocumentSnapshot.documentID),
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
                      _buildTitle(pollDocumentSnapshot['title']),
                      _buildRoom(pollDocumentSnapshot['room']),
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